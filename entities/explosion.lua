local _ = require "lib.lume"
local GameObject = require "alphonsus.gameobject"

local Square = require "entities.square"

local Explosion = Square:extend()

function Explosion:new(x, y, w, h)
	Explosion.super.new(self, x, y, {100,250,250}, w, h)
	self.name = "Explosion"
	self.isExplosion = true
	self.isLayerYPos = false

	self.layer = G.layers.explosion

	self.collider = nil

	self.pos.x = self.pos.x - self.width / 2
	self.pos.y = self.pos.y - self.width / 2

	self:selfDestructIn(_.random(0.03,0.1))

	return self
end

return Explosion