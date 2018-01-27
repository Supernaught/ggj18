local GameObject = require "alphonsus.gameobject"
local Input = require "alphonsus.input"
local Particles = require "alphonsus.particles"
local anim8 = require "lib.anim8"
local _ = require "lib.lume"
local assets = require "assets"

local Bullet = require "entities.bullet"

local Player = GameObject:extend()

function Player:new(x, y, playerNo)
	Player.super.new(self, x, y)
	self.name = "Player"

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
	self.idleAnimation = anim8.newAnimation(g('1-3',1), 0.1)
	self.animation = self.idleAnimation

	-- physics
	self.isSolid = true
	self.direction = Direction.right
	local maxVelocity = 180
	local speed = maxVelocity * 10
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
	self.trailPs = Particles()
	local playerTrail = require "entities.particles.playerTrail"
	if self.playerNo == 2 then playerTrail.colors = {82, 127, 157, 255} end
	self.trailPs:load(playerTrail)
	scene:addEntity(self.trailPs)

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
	-- self.nonCollidableTags = {"isSquare"}
	-- self.collider.ox = G.tile_size/2 - G.tile_size/4
	-- self.collider.oy = G.tile_size/2
	-- self.collider.w = G.tile_size/2
	-- self.collider.h = G.tile_size/2

	-- platformer component
	-- self.platformer = {
	-- 	isGrounded = false,
	-- 	jumpForce = -maxVelocity,
	-- }

	return self
end

function Player:collide(other)
end

function Player:update(dt)
	self:moveControls(dt)
	self:shootControls()

	if self.trailPs then
		local x, y = self:getMiddlePosition()
		self.trailPs.pos.x = x + _.random(-5,5)
		self.trailPs.pos.y = y + 10
		self.trailPs.ps:emit(1)
	end

	if self.platformer then
		local jump = love.keyboard.isDown('z')

		if jump then
			self.movable.drag.y = G.gravity/2
		else
			self.movable.drag.y = G.gravity
		end
	end

	-- if self.trailPs then
	-- 	self.trailPs.ps:setPosition(self.pos.x + math.random(-2,2), self.pos.y + 10)
	-- 	self.trailPs.ps:emit(1)
	-- end
end

-- function Player:getMidPos()
-- 	return self.pos.x + self.offset.x, self.pos.y + self.offset.y
-- end

function Player:shootControls()
	if Input.wasPressed(self.playerNo .. '_shoot') or Input.wasGamepadPressed('a', self.playerNo) then
		self:shoot()
	end
end

function Player:jump()
	if self.platformer and self.platformer.isGrounded then
		self.platformer.isGrounded = false
		self.movable.velocity.y = self.platformer.jumpForce
	end
end

function Player:shoot()
	local angle = (self.direction == Direction.right and 0 or 180)
	local speed = 150
	local x, y = self.pos.x, self.pos.y
	local b = Bullet(x, y, angle, speed, self)
	b.target = self:getNearestEntity(nil, "enemy")
	-- if b.target then print(b.target.name) end

	scene:addEntity(b)
end

function Player:moveControls(dt)
	local left = Input.isDown(self.playerNo .. '_left') or Input.isAxisDown(self.playerNo, 'leftx', '<')
	local right = Input.isDown(self.playerNo .. '_right') or Input.isAxisDown(self.playerNo, 'leftx', '>')
	local up = Input.isDown(self.playerNo .. '_up') or Input.isAxisDown(self.playerNo, 'lefty', '<')
	local down = Input.isDown(self.playerNo .. '_down') or Input.isAxisDown(self.playerNo, 'lefty', '>')
	local rotate = Input.isDown('rotate')

	if rotate then
		self.angle = self.angle + 10/180
	end

	if left and not right then
		self.movable.acceleration.x = -self.movable.speed.x
		self.direction = Direction.left
	elseif right and not left then
		self.movable.acceleration.x = self.movable.speed.x
		self.direction = Direction.right
	else
		self.movable.acceleration.x = 0
	end

	if up and not down then
		self.movable.acceleration.y = -self.movable.speed.y
	elseif down and not up then
		self.movable.acceleration.y = self.movable.speed.y
	else
		self.movable.acceleration.y = 0
	end
end

function Player:draw()
end

return Player
