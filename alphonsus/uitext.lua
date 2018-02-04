GameObject = require "alphonsus.gameobject"

local UIText = GameObject:extend()
local assets =  require "assets"

function UIText:new(x, y, text, width, align, fontSize, font, fontScale)
	UIText.super.new(self, x or 0, y or 0)
	self.name = "UIText"
	self.isUiText = true

	self.collider = nil
	self.isSolid = false
	self.layer = G.layers.ui

	-- Draw UI System
	self.text = text or ""
	self.width = width or G.width
	self.align = align or "center"
	self.fontSize = fontSize or 8
	self.font = font or assets.font_sm
	self.fontScale = fontScale or 1

	return self
end

function UIText:draw()
	if self.isVisible == false then
        return
    end
    
	if self.font then
		love.graphics.setFont(self.font)
	else
		love.graphics.setFont(love.graphics.newFont(self.fontSize))
	end

	love.graphics.scale(self.fontScale)
	love.graphics.printf(self.text, self.pos.x/self.fontScale, self.pos.y/self.fontScale, self.width/self.fontScale, self.align)
	love.graphics.scale(1)

	-- reset font
	love.graphics.setFont(love.graphics.newFont())
end

return UIText