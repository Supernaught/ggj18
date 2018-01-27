local Particles = require "alphonsus.particles"
local timer = require "lib.hump.timer"
local _ = require "lib.lume"
local Vector = require "lib.hump.vector"
local anim8 = require "lib.anim8"

local GameObject = require "alphonsus.gameobject"
local assets = require "assets"

local Disc = GameObject:extend()

local status = { thrown=0, picked=1, pickable=2 }

local discTrail = require "entities.particles.discTrail"

function Disc:new(x, y)
	Disc.super.new(self, x, y)
	self.name = "Disc"
	self.isDisc = true
	self.color = G.colors.red

	self.owner = nil -- player object

	self.layer = G.layers.bullet

	-- disc behavior
	self.speedMultiplier = 1.0
	self.status = status.pickable
	self.dontHitOwner = true
	self.isStopping = false
	self.maxBounces = 3
	self.bounces = 0

	local speed = 150
	local maxVelocity = 200

	local angle = 150
	self.speed = speed

	-- draw
	-- self.isLayerYPos = true
	-- self.sprite = assets.spritesheet
	-- self.flippedH = false
	-- self.offset = { x = G.tile_size/2, y = G.tile_size/2 }
	-- local g = anim8.newGrid(G.tile_size, G.tile_size, self.sprite:getWidth(), self.sprite:getHeight())
	-- self.animation = anim8.newAnimation(g('1-1',19), 0.1)

	-- movable
	self.movable = {
		velocity = { x = 0, y = 0 },
		acceleration = { x = 0, y = 0 },
		drag = { x = 0, y = 0 },
		maxVelocity = { x = maxVelocity, y = maxVelocity },
		speed = { x = 0, y = 0 }
	}

	-- collider
	self.collider = {
		x = x - self.offset.x,
		y = y - self.offset.y,
		w = self.width,
		h = self.height,
		ox = -self.offset.x,
		oy = -self.offset.y
	}

	self.trailPs = Particles(-50,-50)
	self.trailPs.layer = G.layers.bulletTrail
	self.trailPs:load(discTrail)
	scene:addEntity(self.trailPs)

	-- self.nonCollidableTags = {"isDisc", "isPlayer"}
	
	return self
end

function Disc:collisionFilter(other)
	if other.isDisc then
		return "cross"
	end

	if self.status == status.picked then
		return "cross"
	end

	if other.isPowerup then
		return "cross"
	end

	if other.isSolid and not other.isPlayer then
		return "bounce"
	end
end

function Disc:onKillPlayer(player)
	player:hitByDisc(self)
	-- self:stop()
end

function Disc:stop()
	if self.speedMultiplier > 1.0 then self.speedMultiplier = 1.0 end
	self.isStopping = true
end

function Disc:onPickedByPlayer(player)
	if self.owner == nil and not player.hasDisc then
		player:pickDisc()
		self.toRemove = true
	end
end

function Disc:shoot(angle, charge)
	self.trailPs.pos.x = self.pos.x
	self.trailPs.pos.y = self.pos.y

	self.speedMultiplier = 1.0 + (charge/50)
	local ox, oy = _.vector(math.rad(angle), 1)
	local v = Vector(ox, oy):normalized() * self.speed
	self.status = status.thrown
	self.movable.velocity.x = v.x * self.speedMultiplier
	self.movable.velocity.y = v.y * self.speedMultiplier

	timer.after(0.3, function()
		self.dontHitOwner = false
	end)
end

function Disc:collide(other, col)
	if other.isDisc then return end

	if other.isPlayer and other.isAlive then
		if self.status == status.thrown then
			-- if self.dontHitOwner and self.owner.playerNo == other.playerNo then
			-- else
			if self.owner.playerNo == other.playerNo then
			else
				self:onKillPlayer(other)
			end
		elseif self.status == status.pickable then
			self:onPickedByPlayer(other)
		end
	end

	if other.isSolid and not other.isPlayer then
		local nx, ny = col.normal.x, col.normal.y
		local vx, vy = self.movable.velocity.x, self.movable.velocity.y
		if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
			vx = -vx
		end

		if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
			vy = -vy
		end

		-- on bounce
		self.movable.velocity.x = vx
		self.movable.velocity.y = vy

		self.bounces = self.bounces + 1

		if self.bounces >= self.maxBounces then
			self:stop()
		end
	end
end

function Disc:update(dt)
	self.angle = self.angle + 0.2

	self.color = (self.status == status.thrown) and G.colors.red or G.colors.green
	local vel = self.movable.velocity

	local v = Vector(vel.x, vel.y):normalized()
	self.trailPs.pos.x = self.pos.x + (v.x*5) + _.random(-3,3)
	self.trailPs.pos.y = self.pos.y + (v.y*5) + _.random(-3,3)

	if self.trailPs and self.owner then
		if math.abs(vel.x) < 30 and math.abs(vel.y) < 30 then
			self.trailPs.pos.x = _.lerp(self.trailPs.pos.x, self.pos.x, dt * 100)
			self.trailPs.pos.y = _.lerp(self.trailPs.pos.y, self.pos.y, dt * 100)
		end

		if (math.abs(math.floor(vel.x)) > 1 or math.abs(math.floor(vel.y)) > 1) then
			-- local x, y = self:getMiddlePosition()
			self.trailPs.ps:emit(math.random(2,5))
		end
	end

	if self.owner and self.status == status.picked then
		self.movable.velocity.x = 0
		self.movable.velocity.y = 0

		local o = self.owner
		if not o.isAiming then
			self.pos.x = o.pos.x
			self.pos.y = o.pos.y
		end
	end

	if self.isStopping and self.speedMultiplier > 0 then
		-- self.speedMultiplier = self.speedMultiplier - 0.005
		self.speedMultiplier = _.lerp(self.speedMultiplier, 0, dt * 0.1)

		self.movable.velocity.x = self.movable.velocity.x * self.speedMultiplier
		self.movable.velocity.y = self.movable.velocity.y * self.speedMultiplier

		local max = math.max(math.abs(self.movable.velocity.x), math.abs(self.movable.velocity.y))

		if max < 5 then
			self.status = status.pickable
			self.owner = nil
		end

		if self.speedMultiplier < 0.5 then
			self.speedMultiplier = 0
		end
	end
end

function Disc:draw()
	-- if self.status == status.picked then return end
	-- love.graphics.setColor(self.color)
	-- love.graphics.rectangle("fill", self.pos.x-self.offset.x, self.pos.y-self.offset.y, self.width, self.height)
	-- love.graphics.setColor(255,255,255)

	-- love.graphics.setColor({255,})
	love.graphics.circle("fill", self.pos.x, self.pos.y, 6, 6)
	-- love.graphics.setColor(255,255,255)
end

return Disc