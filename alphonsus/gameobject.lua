local _ = require "lib.lume"
local Object = require "lib.classic"
local timer = require "lib.hump.timer"

local GameObject = Object:extend()
local assets = require "assets"

Direction = {
	up = 'up',
	down = 'down',
	left = 'left',
	right = 'right'
}

function GameObject:new(x, y, w, h)
	-- gameobject
	self.name = "GameObject"
	self.tag = ""
	self.isAlive = true
	self.toRemove = false

	self.isVisible = true
	self.isSolid = true

	-- draw layer
	self.layer = 0

	-- if true, drawSystem will set self.layer to self.pos.y on update loop
	-- used for 2.5D topdown games
	self.isLayerYPos = false

	-- transform
	self.pos = { x = x or 0, y = y or 0 }
	self.width = w or G.tile_size
	self.height = h or G.tile_size
	self.offset = { x = self.width/2, y = self.height/2 }
	self.scale = { x = 1, y = 1 }
	self.angle = 0 -- in radians

	-- collider component
	-- self.collider = {
	-- 	x = x - self.offset.x,
	-- 	y = y - self.offset.y,
	-- 	w = self.width,
	-- 	h = self.height,
	-- 	ox = 0,
	-- 	oy = 0
	-- }

	-- used for collision filters in collisionSystem
	-- if collides with entities with these tags, they will "slide"
	self.collidableTags = {}

	-- if collides with entities with these tags, they will "cross"
	self.nonCollidableTags = {}

	return self
end

function GameObject:getMiddlePosition()
	return self.pos.x + self.width/2, self.pos.y + self.height/2
end

function GameObject:selfDestructIn(seconds)
	timer.after(seconds, function() self.toRemove = true end)
end

function GameObject:distanceFrom(gameobject)
	return _.distance(self.pos.x, self.pos.y, gameobject.pos.x, gameobject.pos.y)
end

function GameObject:getNearbyEntities(distance, tag)
	return scene:getNearbyEntitiesFromSource(self, distance, tag)
end

function GameObject:getNearestEntity(withDistance, tag)
	return scene:getNearestEntityFromSource(self, withDistance, tag)
end

function GameObject:collisionFilter(other)
	for i,tag in ipairs(self.collidableTags) do
		if other[tag] then return "slide" end
	end

	for i,tag in ipairs(self.nonCollidableTags) do
		if other[tag] then return "cross" end
	end

	if self.isSolid then
		if other.isOneWay then return "onewayplatform" end
		if other.isSolid then return "slide" end
		return "cross"
	end
end

return GameObject