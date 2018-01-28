local GameObject = require "alphonsus.gameobject"
local assets = require "assets"
local anim8 = require "lib.anim8"
local flux = require "lib.flux"

local Popup = GameObject:extend()

function Popup:new(x, y, text, width, align, fontSize, font, fontScale)
	Popup.super.new(self, x, y)
	self.name = "Popup"
	self.isPopup = true

	self.text = text or ""
	self.width = width or love.graphics.getWidth()/G.scale
	self.align = align or "center"
	self.fontSize = fontSize or 8
	self.font = font or assets.font_sm
	self.fontScale = fontScale or 1

	self.layer = G.layers.ui

	self.owner = owner

	-- self.sprite = assets.player
	-- self.offset.x = self.sprite:getWidth()/2
	self.offset.x = width/2

	self.modifierPos = { x = 0, y = 10 }
	flux.to(self.modifierPos, 1, { y = self.modifierPos.y - 20 }):ease("elasticout"):oncomplete(function() self:selfDestructIn(1) end)

	return self
end

function Popup:update(dt)
	if self.owner then
		self.pos.x = self.owner.pos.x
		self.pos.y = self.owner.pos.y
	end

	self.pos.x = self.pos.x + self.modifierPos.x
	self.pos.y = self.pos.y + self.modifierPos.y
end

function Popup:draw()
	if self.isVisible == false then
        return
    end

    if self.sprite then
    	return
    end
    
	if self.font then
		love.graphics.setFont(self.font)
	else
		love.graphics.setFont(love.graphics.newFont(self.fontSize))
	end

	love.graphics.scale(self.fontScale)
	love.graphics.printf(self.text, self.pos.x/self.fontScale - self.offset.x, self.pos.y/self.fontScale - self.offset.y, self.width/self.fontScale, self.align)
	love.graphics.scale(1)

	-- reset font
	love.graphics.setFont(love.graphics.newFont())

end

return Popup