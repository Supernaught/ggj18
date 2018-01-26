GameObject = require "alphonsus.gameobject"

local Particles = GameObject:extend()
local assets =  require "assets"

function Particles:new(x, y)
	Particles.super.new(self, x or G.width/2, y or G.width/2)
	self.name = "Particles"
	self.isParticles = true

	self.collider = nil
	self.layer = G.layers.particles

	self.ps = love.graphics.newParticleSystem(assets.whiteCircle, 100)
	return self
end

function Particles:load(p)
	self.ps = love.graphics.newParticleSystem(assets.whiteCircle, 100)
	-- self.ps:setPosition(self.pos.x, self.pos.y)
	self.ps:setColors(unpack(p.colors)) -- rgba

	self.ps:setParticleLifetime(unpack(p.particleLifetime))
	self.ps:setDirection(p.direction)
	self.ps:setSpread(p.spread)

	self.ps:setLinearAcceleration(unpack(p.linearAcceleration)) -- x, y acceleration
	self.ps:setLinearDamping(p.linearDamping) -- decceleration (for x and y)

	self.ps:setRotation(unpack(p.rotation)) -- initial rotation
	self.ps:setSpin(unpack(p.spin)) -- angular velocity

	self.ps:setSizes(unpack(p.sizes)) -- initial size
	
	self.ps:setInsertMode(p.insertMode)
end

function Particles:update(dt)
	self.ps:update(dt)
	self.ps:setPosition(self.pos.x, self.pos.y)
end

function Particles:draw()
	love.graphics.draw(self.ps, 0, 0, 0, 1, 1)
end

return Particles