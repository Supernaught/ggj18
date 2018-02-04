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

function Disc:new(x, y, owner)
	Disc.super.new(self, x, y)
	self.name = "Disc"
	self.isDisc = true
	self.color = G.colors.red

	self.owner = owner -- player object

	self.layer = G.layers.bullet

	-- disc behavior
	self.speedMultiplier = 1.0
	self.status = status.pickable
	self.dontHitOwner = true
	self.isStopping = false
	self.maxBounces = G.maxBounces
	self.bounces = 0
	self.isFromDual = false
	self.isBig = false
	self.isSpeed = false

	-- default speed = 100, default maxVelocity = 300
	local speed = 120
	local maxVelocity = 0

	local angle = 150
	self.speed = speed

	-- draw
	self.sprite = assets.whiteCircle
	self.width = 12
	self.height = 12
	self.offset = { x = 6, y = 6 }

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

	-- particles
	self.trailPs = Particles(-50,-50)
	self.trailPs.layer = G.layers.bulletTrail
	self.trailPs:load(discTrail)
	scene:addEntity(self.trailPs)
	
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
end

function Disc:stop()
	if self.speedMultiplier > 1.0 then self.speedMultiplier = 1.0 end
	self.isStopping = true
	self.maxBounces = G.maxBounces
end

function Disc:onPickedByPlayer(player)
	if self.owner == nil and not player.hasDisc then
		player:pickDisc()
		self.owner = player
		self.toRemove = true
	end
end

function Disc:shoot(angle, charge)
	self.trailPs.ps:setColors(G.colors[self.owner.playerNo])
	self.trailPs.pos.x = self.pos.x
	self.trailPs.pos.y = self.pos.y

	self.speedMultiplier = 1.0 + (charge/40)

	if self.isBig then
		self.scale.x = 2
		self.scale.y = 2
		self.collider.ox = self.collider.ox - 6
		self.collider.oy = self.collider.oy - 6
		self.collider.w = 24
		self.collider.h = 24
		self.speedMultiplier = self.speedMultiplier/2
	end

	if self.isFromDual then angle = angle + 22.5 end

	self.status = status.thrown
	self.movable.velocity.x = math.cos(math.rad(angle)) * self.speed * self.speedMultiplier
	self.movable.velocity.y = math.sin(math.rad(angle)) * self.speed * self.speedMultiplier

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
		bounce_sfx = _.randomchoice({
			assets.bullet_sfx:clone(),
		})
		bounce_sfx:play()

		self.movable.velocity.x = vx
		self.movable.velocity.y = vy

		self.bounces = self.bounces + 1

		if self.bounces >= self.maxBounces then
			self:stop()
		end
	end
end

function Disc:update(dt)
	self.color = (self.status == status.thrown) and G.colors.red or G.colors.green
	local vel = self.movable.velocity

	local v = Vector(vel.x, vel.y):normalized()
	local trailAhead = self.isBig and 2 or 5
	self.trailPs.pos.x = self.pos.x + (v.x*trailAhead) + _.random(-2,2)
	self.trailPs.pos.y = self.pos.y + (v.y*trailAhead) + _.random(-2,2)

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
			if self.isFromDual then self.toRemove = true end
			self.status = status.pickable
			self.owner = nil

			self.scale.x = _.lerp(self.scale.x, 1, dt * 10)
			self.scale.y = _.lerp(self.scale.y, 1, dt * 10)

			self.collider.w = _.lerp(self.collider.w, self.width, dt * 10)
			self.collider.h = _.lerp(self.collider.h, self.height, dt * 10)

			self.collider.ox = _.lerp(self.collider.ox, -self.offset.x, dt * 10)
			self.collider.oy = _.lerp(self.collider.oy, -self.offset.y, dt * 10)
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
	-- if self.isBig and self.status == status.thrown then
	-- 	love.graphics.circle("fill", self.pos.x, self.pos.y, 12, 12)
	-- else
	-- 	love.graphics.circle("fill", self.pos.x, self.pos.y, 6, 6)
	-- end
	-- love.graphics.setColor(255,255,255)
end

return Disc