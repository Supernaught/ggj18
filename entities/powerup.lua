local GameObject = require "alphonsus.gameobject"
local assets = require "assets"
local _ = require "lib.lume"
local anim8 = require "lib.anim8"

local Popup = require "entities.popup"
local UIText = require "alphonsus.uitext"

local Powerup = GameObject:extend()

function Powerup:new(x, y, w, h)
	Powerup.super.new(self, x, y, w, h)
	self.name = "Powerup"
	self.isPowerup = true
	self.isSolid = false
	self.color = color or {255,255,255}

	self.collider = {
		x = x - self.offset.x,
		y = y + self.offset.y,
		w = self.width,
		h = self.height,
		ox = -self.offset.x,
		oy = -self.offset.y
	}

	-- anim
	self.isLayerYPos = true
	self.sprite = assets.spritesheet
	-- self.flippedH = false
	self.offset = { x = G.tile_size/2, y = G.tile_size/2 }
	local g = anim8.newGrid(G.tile_size, G.tile_size, self.sprite:getWidth(), self.sprite:getHeight())
	self.animation = anim8.newAnimation(g('2-2',19), 0.1)

	return self
end

function Powerup:update()
end

function Powerup:draw()
end

function Powerup:collisionFilter(other)
	return "cross"
end

function Powerup:collide(other)
	if other.isPlayer and not self.toRemove then
		-- picked up
		self.toRemove = true
		local randPowerup = _.randomchoice(G.powerups_array)
		other:pickupPowerup(randPowerup)
		
		local popup = Popup(self, self.pos.x, self.pos.y, randPowerup:upper(), 50)
		popup.shadowColor = G.colors[other.playerNo]
		scene:addEntity(popup)
	end
end

return Powerup