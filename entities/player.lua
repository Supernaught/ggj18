local timer = require "lib.hump.timer"
local GameObject = require "alphonsus.gameobject"
local Input = require "alphonsus.input"
local Particles = require "alphonsus.particles"
local anim8 = require "lib.anim8"
local _ = require "lib.lume"
local assets = require "assets"

local Disc = require "entities.disc"
local Bullet = require "entities.bullet"

local Player = GameObject:extend()

function Player:new(x, y, playerNo)
	Player.super.new(self, x, y)
	self.name = "Player"

	-- disc behavior
	self.hasDisc = false
	self.disc = nil
	self.isAiming = false
	self.aimAngle = nil
	self.charge = 0

	-- tags
	self.isPlayer = true
	self.playerNo = playerNo
	self.tag = "player"

	-- draw/sprite component
	self.layer = G.layers.player
	self.isLayerYPos = true
	self.sprite = assets.spritesheet
	self.flippedH = false
	self.offset = { x = G.tile_size/2, y = G.tile_size/2 }
	local g = anim8.newGrid(G.tile_size, G.tile_size, self.sprite:getWidth(), self.sprite:getHeight())
	self.idleAnimation = anim8.newAnimation(g('1-4',2), 0.1)
	self.runningAnimation = anim8.newAnimation(g('1-10',1), 0.05)
	self.dashAnimation = anim8.newAnimation(g('1-3',1), 0.1)
	self.animation = self.idleAnimation

	-- physics
	self.isSolid = true
	self.direction = Direction.right
	local maxVelocity = 180
	local speed = maxVelocity * 20
	local drag = maxVelocity * 20

	-- movable component
	self.movable = {
		velocity = { x = 0, y = 0 },
		acceleration = { x = 0, y = 0 },
		drag = { x = drag, y = drag },
		maxVelocity = { x = maxVelocity, y = maxVelocity },
		speed = { x = speed, y = speed } -- used to assign to acceleration
	}

	-- particles
	-- self.trailPs = Particles()
	-- local playerTrail = require "entities.particles.playerTrail"
	-- if self.playerNo == 2 then playerTrail.colors = {82, 127, 157, 255} end
	-- self.trailPs:load(playerTrail)
	-- scene:addEntity(self.trailPs)

	-- collider
	self.collider = {
		x = x - self.offset.x,
		y = y - self.offset.y,
		w = self.width,
		h = self.height,
		ox = 0,
		oy = 0
	}
	self.collidableTags = {"isEnemy"}
	self.nonCollidableTags = {"isDisc"}
	-- self.collider.ox = G.tile_size/2 - G.tile_size/4
	-- self.collider.oy = G.tile_size/2
	-- self.collider.w = G.tile_size/2
	-- self.collider.h = G.tile_size/2

	return self
end

function Player:collide(other)
end

function Player:update(dt)
	self:moveControls(dt)
	self:shootControls()
	self:updateAnimations()

	-- if self.trailPs then
	-- 	local x, y = self:getMiddlePosition()
	-- 	self.trailPs.pos.x = x + _.random(-5,5)
	-- 	self.trailPs.pos.y = y + 10
	-- 	self.trailPs.ps:emit(1)
	-- end
end

function Player:updateAnimations()
	if self.movable.acceleration.x < 0 then
		self.flippedH = true
	elseif self.movable.acceleration.x > 0 then
		self.flippedH = false
	end

	if self.movable.velocity.x == 0 and self.movable.velocity.y == 0 then
		self.animation = self.idleAnimation
	else
		self.animation = self.runningAnimation
	end
end

-- function Player:getMidPos()
-- 	return self.pos.x + self.offset.x, self.pos.y + self.offset.y
-- end

function Player:shootControls()
	if self.isAlive and self.hasDisc then
		if Input.isDown(self.playerNo .. '_shoot') or Input.isGamepadButtonDown('a', self.playerNo) then
			self.isAiming = true

			if self.charge < 100 then
				self.charge = self.charge + 2
			end
		else
			if self.isAiming == true then
				self.isAiming = false
				self:releaseDisc()
			end
		end
	end
end

function Player:pickDisc()
	self.hasDisc = true
end

function Player:releaseDisc()
	-- local angle = (self.direction == Direction.right and 0 or 180)
	local disc = Disc(self.pos.x, self.pos.y)
	scene:addEntity(disc)
	disc:shoot(self.aimAngle, self.charge)
	disc.owner = self
	self.hasDisc = false
	self.charge = 0
end

function Player:moveControls(dt)
	if not self.isAlive then return end

	local left = Input.isDown(self.playerNo .. '_left') or Input.isAxisDown(self.playerNo, 'leftx', '<')
	local right = Input.isDown(self.playerNo .. '_right') or Input.isAxisDown(self.playerNo, 'leftx', '>')
	local up = Input.isDown(self.playerNo .. '_up') or Input.isAxisDown(self.playerNo, 'lefty', '<')
	local down = Input.isDown(self.playerNo .. '_down') or Input.isAxisDown(self.playerNo, 'lefty', '>')

	if self.hasDisc and self.isAiming then
		self.movable.acceleration.x = 0
		self.movable.acceleration.y = 0

		-- aim direction
		if up and left then self.aimAngle = -135
		elseif up and right then self.aimAngle = -45
		elseif down and left then self.aimAngle = 135
		elseif down and right then self.aimAngle = 45
		elseif left then self.aimAngle = 180
		elseif right then self.aimAngle = 0
		elseif up then self.aimAngle = -90
		elseif down then self.aimAngle = 90
		end

		-- if left then
		-- 	if up or down then
		-- 		self.disc.pos.x = self.pos.x - 16
		-- 	else
		-- 		self.disc.pos.x = self.pos.x - 16
		-- 		self.disc.pos.y = self.pos.y
		-- 	end
		-- elseif right then
		-- 	if up or down then
		-- 		self.disc.pos.x = self.pos.x + 16
		-- 	else
		-- 		self.disc.pos.x = self.pos.x + 16
		-- 		self.disc.pos.y = self.pos.y
		-- 	end
		-- end

		-- if up then
		-- 	if left or right then
		-- 		self.disc.pos.y = self.pos.y - 16
		-- 	else
		-- 		self.disc.pos.y = self.pos.y - 16
		-- 		self.disc.pos.x = self.pos.x
		-- 	end
		-- elseif down then
		-- 	if left or right then
		-- 		self.disc.pos.y = self.pos.y + 16
		-- 	else
		-- 		self.disc.pos.y = self.pos.y + 16
		-- 		self.disc.pos.x = self.pos.x
		-- 	end
		-- end

		return
	end

	if left and not right then
		self.movable.acceleration.x = -self.movable.speed.x
		self.direction = Direction.left
		self.aimAngle = 180
	elseif right and not left then
		self.movable.acceleration.x = self.movable.speed.x
		self.direction = Direction.right
		self.aimAngle = 0
	else
		self.movable.acceleration.x = 0
	end

	if up and not down then
		self.movable.acceleration.y = -self.movable.speed.y
		self.aimAngle = -90
	elseif down and not up then
		self.movable.acceleration.y = self.movable.speed.y
		self.aimAngle = 90
	else
		self.movable.acceleration.y = 0
	end
end

function Player:hitByDisc(disc)
	scene.camera:shake(15)
	self.isAlive = false
	self.movable.velocity.x = 0
	self.movable.velocity.y = 0
	self.movable.acceleration.x = 0
	self.movable.acceleration.y = 0
	timer.after(2, function()
		self:respawn()
	end)

	self.isSolid = false
end

function Player:respawn()
	self.isAlive = true
	self.isSolid = true
end

function Player:draw()
end

return Player
