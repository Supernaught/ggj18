local _ = require "lib.lume"
local GameObject = require "alphonsus.gameobject"
local Square = require "entities.square"

local Enemy = Square:extend()

function Enemy:new(x, y, color)
	Enemy.super.new(self, x, y)
	self.name = "Enemy"
	self.isEnemy = true
	self.tag = "enemy"
	self.isSolid = false
	self.isLayerYPos = false

	self.layer = G.layers.enemy

	self.movable = {
		velocity = { x = 0, y = 0 },
		acceleration = { x = 0, y = 0 },
		drag = { x = 0, y = 0 },
		maxVelocity = { x = 50, y = 50 },
		speed = { x = 50, y = 50 } -- used to assign to acceleration
	}

	-- self.isMoveTowardsPosition = true
	-- self.targetPosition = {
	-- 	x = self.pos.x + 50,
	-- 	y = self.pos.y - 50
	-- }

	self.color = color or {155,100,0}
	return self
end

function Enemy:update(dt)
	-- self:isMoveTowardsPosition()
	-- self:moveTowardsPosition()
end

function Enemy:moveTowardsPosition()
	local distanceToTarget = _.distance(self.pos.x, self.pos.y, self.targetPosition.x, self.targetPosition.y)
	if _.round(distanceToTarget) <= 0 then
		self.targetPosition.x = self.targetPosition.x + _.random(-2,2) * 20
		self.targetPosition.y = self.targetPosition.y + _.random(-2,2) * 20
	end
end

return Enemy