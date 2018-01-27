local GameObject = require "alphonsus.gameobject"
local assets = require "assets"
local anim8 = require "lib.anim8"

local PopupAnimation = GameObject:extend()

function PopupAnimation:new(owner, x, y, w, h)
	PopupAnimation.super.new(self, x, y, w, h)
	self.name = "PopupAnimation"
	self.isPopupAnimation = true
	self.isSolid = false

	self.owner = owner

	-- anim
	self.sprite = assets.spritesheet
	self.flippedH = false
	self.offset = { x = G.tile_size/2, y = G.tile_size/2 }
	local g = anim8.newGrid(G.tile_size, G.tile_size, self.sprite:getWidth(), self.sprite:getHeight())
	self.animation = anim8.newAnimation(g('1-5',owner.playerNo+14), 0.07)

	return self
end

function PopupAnimation:update()
	self.pos.x = self.owner.pos.x
	self.pos.y = self.owner.pos.y - 16
end

function PopupAnimation:draw()
end

return PopupAnimation
