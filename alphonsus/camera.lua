local _ = require "lib.lume"
local Object = require "lib.classic"
local gamera = require "lib.gamera"
local shack = require "lib.shack"

local Camera = Object:extend()
local assets = require "assets"

function Camera:new(followSpeed, zoomSpeed)
	if G.fullscreen then
		desktopWidth, desktopHeight = love.window.getDesktopDimensions()
		self.cam = gamera.new(x or 0, y or 0, desktopWidth, desktopHeight)
		self.cam:setWindow(0, 0, desktopWidth, desktopHeight)
	else
		self.cam = gamera.new(x or 0, y or 0, G.width, G.height)
		self.cam:setWindow(0, 0, G.width, G.height)
	end

	self.pos = {
		x = x or 0,
		y = y or 0
	}

	self.offset = {
		x = 0,
		y = 0
	}

	self.constantZoom = G.fullscreen and G.scale or 1.0
	self.zoom = 1.0
	self.cam:setScale(self.constantZoom * self.zoom)

	-- setup default boundaries
	-- self.cam:setWorld(0,0,10000,10000)

	self.followTarget = nil -- must be GameObject type
	self.followSpeed = followSpeed or 3
	self.zoomSpeed = zoomSpeed or 3

	return self
end

function Camera:isPointVisible(x, y)
	local l,t,w,h = self.cam:getVisible()
	return x < l+w and x > l and y > t and y < t+h
end

function Camera:getVisibleEntities(entities)
	return _.filter(entities, function(e) return self:isPointVisible(e.pos.x, e.pos.y) end)
end

function Camera:setPosition(x, y)
	self.pos.x = x
	self.pos.y = y
end

-- target must be GameObject
function Camera:startFollowing(target, offsetX, offsetY)
	self.followTarget = target
	self.offset.x = offsetX or 0
	self.offset.y = offsetY or 0
end

function Camera:update(dt)
	local f = self.followTarget
	if f then
		self.pos.x = _.lerp(self.pos.x, f.pos.x, dt * self.followSpeed)
		self.pos.y = _.lerp(self.pos.y, f.pos.y, dt * self.followSpeed)
	end
	local z = _.lerp(self.cam.scale, self.zoom * self.constantZoom, dt * self.zoomSpeed)
	-- self.cam:setScale(z)
	self.cam:setPosition(math.floor(self.pos.x + self.offset.x), math.floor(self.pos.y + self.offset.y))
end

function Camera:shake(amount)
	shack:setShake(amount or 10)
end

return Camera