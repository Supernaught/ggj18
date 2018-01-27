local _ = require "lib.lume"
local GameObject = require "alphonsus.gameobject"
local assets = require "assets"
local anim8 = require "lib.anim8"

local Square = require "entities.square"

local Explosion = Square:extend()

function Explosion:new(x, y, w, h)
	Explosion.super.new(self, x, y, {100,250,250}, w, h)
	self.name = "Explosion"
	self.isExplosion = true
	self.isLayerYPos = false

	self.layer = G.layers.explosion

	self.collider = nil

	-- self.pos.x = self.pos.x - self.width / 2
	-- self.pos.y = self.pos.y - self.width / 2

	-- anim
	self.sprite = assets.spritesheet
	self.flippedH = false
	self.offset = { x = G.tile_size/2, y = G.tile_size/2 }
	local g = anim8.newGrid(G.tile_size, G.tile_size, self.sprite:getWidth(), self.sprite:getHeight())
	self.animation = anim8.newAnimation(g('1-7',20), 0.05)

	self:selfDestructIn(0.05*6)

	return self
end

function Explosion:update()
end

function Explosion:draw()
end

return Explosion