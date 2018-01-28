local GameObject = require "alphonsus.gameobject"
local assets = require "assets"
local anim8 = require "lib.anim8"
local flux = require "lib.flux"

local PopupAnimation = GameObject:extend()

function PopupAnimation:new(owner, x, y, animColumns, animRow, popup)
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
	self.animation = anim8.newAnimation(g(animColumns,animRow), 0.07)

	self.modifierPos = { x = 0, y = -16 }
	if popup then
		self.modifierPos = { x = 0, y = 0 }
		flux.to(self.modifierPos, 1, { y = self.modifierPos.y - 16 }):ease("elasticout"):oncomplete(function() self:selfDestructIn(1) end)
	end

	return self
end

function PopupAnimation:update()
	self.pos.x = self.owner.pos.x + self.modifierPos.x
	self.pos.y = self.owner.pos.y + self.modifierPos.y
	self.layer = self.owner.layer
end

function PopupAnimation:draw()
end

return PopupAnimation
