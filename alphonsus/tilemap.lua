GameObject = require "alphonsus.gameobject"

local sti = require "lib.sti"

local TileMap = GameObject:extend()
local assets =  require "assets"

function TileMap:new(mapPath, x, y, bumpWorld)
	TileMap.super.new(self, x or 0, y or 0)
	self.name = "TileMap"
	self.isTileMap = true

	self.bumpWorld = bumpWorld

	-- self.map = sti("maps/plain.lua")
	-- self.map = sti("maps/plain2.lua")
	local map = sti(mapPath, { "bump" })
	self.map = map
	self.map:bump_init(self.bumpWorld)
	self.map:resize(1000,1000)

	for lindex, layer in ipairs(map.layers) do
		if layer.properties.isSolid then
			local isOneWay = layer.properties.isOneWay
			for y, tiles in ipairs(layer.data) do
				for x, tile in pairs(tiles) do
					local xpos, ypos = (x-1) * map.tilewidth, (y-1) * map.tileheight
					local bumpObject = {
						collider = {
							x = x-1,
							y = y-1,
							w = tile.width,
							h = tile.height,
						},
						name = layer.name,
						isOneWay = isOneWay,
						isSolid = true
					}
					bumpWorld:add(bumpObject, xpos, ypos, tile.width, tile.height)
				end
			end
		elseif layer.properties.isDecor then
			for y, tiles in ipairs(layer.data) do
				for x, tile in pairs(tiles) do
					-- local xpos, ypos = x * map.tilewidth, y * map.tileheight
					-- TODO: add gameobject
				end
			end
		end

		-- if layer.type == "objectgroup" then
		--     for _, object in ipairs(layer.objects) do
		--         local ctor = require("src.entities." .. object.type)
		--         local e = ctor(object)
		--         if object.type == "Player" then
		--             player = e
		--         end
		--         world:add(e)
		--     end
		--     tileMap:removeLayer(lindex)
		-- end
	end

	return self
end

function TileMap:update(dt)
end

function TileMap:draw()
	local camScale = scene.camera.cam:getScale()
	local l,t = scene.camera.cam:getVisible()
	self.map:draw(math.floor(-l), math.floor(-t), camScale, camScale)

	local items,len = self.bumpWorld:getItems()
	for i,item in ipairs(items) do
		if item.collider and G.debug then
			local x,y,w,h = item.collider.x, item.collider.y, item.collider.w, item.collider.h
			if item.isOneWay then
				love.graphics.setColor(0, 255, 0)
			else
				love.graphics.setColor(255, 0, 0)
			end
			love.graphics.rectangle("line", x * self.map.tilewidth, y * self.map.tileheight, w, h)
			love.graphics.setColor(255, 255, 255)
		end
	end
end

return TileMap