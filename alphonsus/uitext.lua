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

	-- To add shadow:
	-- self.shadow = {
	-- 	color = G.colors.p_red,
	-- 	size = 1,
	-- 	x = 0,
	-- 	y = 1
	-- }

	return self
end

function UIText:addShadow(color, x, y, size)
	self.shadow = {
		color = color,
		size = size,
		x = x,
		y = y
	}
end

function UIText:draw()
	if self.isVisible == false then
        return
    end
    
	love.graphics.setFont(self.font or love.graphics.newFont(self.fontSize))
	love.graphics.scale(self.fontScale)

	if self.shadow then
		love.graphics.setColor(self.shadow.color)
		love.graphics.printf(self.text, self.pos.x/self.fontScale + self.shadow.x, self.pos.y/self.fontScale + self.shadow.y, self.width/self.fontScale, self.align)
	end

	love.graphics.setColor(255,255,255)
	love.graphics.printf(self.text, self.pos.x/self.fontScale, self.pos.y/self.fontScale, self.width/self.fontScale, self.align)

	-- reset
	love.graphics.scale(1)
	love.graphics.setFont(love.graphics.newFont())
end

return UIText