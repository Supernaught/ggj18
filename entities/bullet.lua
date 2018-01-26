local GameObject = require "alphonsus.gameobject"

local _ = require "lib.lume"

local Circle = require "entities.circle"
local Square = require "entities.square"
local Explosion = require "entities.explosion"

local Bullet = Square:extend()

-- angle in degrees
function Bullet:new(x, y, angle, speed, owner)
	Bullet.super.new(self, x, y)
	self.name = "Bullet"
	self.isBullet = true
	self.isSolid = false
	self.angle = math.rad(angle or 90)
	self.layer = G.layers.bullet
	self.isLayerYPos = false

	self.owner = owner
	self.tag = self.owner.tag

	self.isMoveTowardsAngle = true

	local maxVelocity = speed

	-- movable component
	self.movable = {
		velocity = { x = speed, y = 0 },
		drag = { x = 0, y = 0 },
		maxVelocity = { x = maxVelocity, y = maxVelocity },
		speed = { x = speed, y = speed },
		acceleration = { x = 0, y = 0 }
	}

	self.width = G.tile_size/2
	self.height = G.tile_size/2

	-- collider
	self.collider = {
		x = x,
		y = y,
		w = self.width,
		h = self.height
	}

	self.nonCollidableTags = {"isBullet"}

	self.offset = { x = self.collider.w/2, y = self.collider.h/2 }

	self.color = {255,255,255}
	return self
end

function Bullet:update(dt)
	-- rotate towards target
	if self.target and _.distance(self.pos.x, self.pos.y, self.target.pos.x, self.target.pos.y) < 100 then
		local targetAngle = _.angle(self.pos.x, self.pos.y, self.target.pos.x, self.target.pos.y)
		self.angle = _.lerp(self.angle, targetAngle, dt * 1)
		print("lerping to " .. self.target.name .. " " .. targetAngle)
		-- self.angle = _.angle(self.pos.x, self.pos.y, self.target.pos.x, self.target.pos.y)
	end
end

function Bullet:collide(other)
	if self.tag ~= other.tag then
		self.toRemove = true

		local x, y = self:getMiddlePosition()
		local c = Circle(x, y, size, size)
		c.layer = G.layers.explosion
		c:selfDestructIn(0.03)
		scene:addEntity(c)
		-- for i=0,5 do
		-- 	local size = _.random(10,20)
		-- 	scene:addEntity(Explosion(x + _.random(-6,6), y + _.random(-6,6), size, size))
		-- end
		-- scene.camera:shake(2)
	end
end

return Bullet