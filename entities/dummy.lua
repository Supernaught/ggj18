local GameObject = require "alphonsus.gameobject"
local assets = require "assets"
local anim8 = require "lib.anim8"

local Dummy = GameObject:extend()

function Dummy:new(x, y, w, h)
	Dummy.super.new(self, x, y, w, h)
	self.name = "Dummy"
	self.isDummy = true
	self.isSolid = true
	self.color = color or {255,255,255}

	self.collider = {
		x = x - self.offset.x,
		y = y + self.offset.y,
		w = self.width,
		h = self.height,
		ox = -self.offset.x,
		oy = -self.offset.y
	}

	self.isLayerYPos = true
	self.sprite = assets.spritesheet
	self.flippedH = false
	self.offset = { x = G.tile_size/2, y = G.tile_size/2 }
	local g = anim8.newGrid(G.tile_size, G.tile_size, self.sprite:getWidth(), self.sprite:getHeight())
	self.animation = anim8.newAnimation(g('1-3',1), 0.1)

	-- movable component
	local maxVelocity = 200
	local Speed = 100
	self.movable = {
		velocity = { x = 100, y = 0 },
		acceleration = { x = 0, y = 0 },
		drag = { x = 0, y = 0 },
		maxVelocity = { x = maxVelocity, y = maxVelocity },
		speed = { x = speed, y = speed } -- used to assign to acceleration
	}

	return self
end

function Dummy:update()
	self.angle = self.angle + 0.3
end

function Dummy:draw()
end

return Dummy