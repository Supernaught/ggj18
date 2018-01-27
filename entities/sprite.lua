local GameObject = require "alphonsus.gameobject"
local assets = require "assets"
local anim8 = require "lib.anim8"

local Sprite = GameObject:extend()

function Sprite:new(sprite, x, y, w, h)
	Sprite.super.new(self, x, y, w, h)
	self.name = "Sprite"
	self.isSprite = true
	self.isSolid = false

	-- anim
	self.sprite = sprite
	self.offset = { x = G.tile_size/2, y = G.tile_size/2 }
	-- local g = anim8.newGrid(G.tile_size, G.tile_size, self.sprite:getWidth(), self.sprite:getHeight())
	-- self.animation = anim8.newAnimation(g('1-5',owner.playerNo+14), 0.07)

	return self
end

function Sprite:update()
end

function Sprite:draw()
end

return Sprite
