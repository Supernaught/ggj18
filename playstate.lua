local Scene = require "alphonsus.scene"
local Input = require "alphonsus.input"
local GameObject = require "alphonsus.gameobject"

local PaletteSwitcher = require 'lib/PaletteSwitcher'
local shack = require "lib.shack"
local _ = require "lib.lume"
local moonshine = require "lib.moonshine"
local Gamestate = require "lib.hump.gamestate"

local Square = require "entities.square"
local Player = require "entities.player"
local Bullet = require "entities.bullet"
local Disc = require "entities.disc"
local TileMap = require "alphonsus.tilemap"
local Dummy = require "entities.Dummy"

local PlayState = Scene:extend()

-- entities
local player = {}
local player2 = {}
local middlePoint = {}
local tileMap = {}

-- helper function
function getMiddlePoint(pos1, pos2)
	return (pos1.x + pos2.x)/2 + player.width/2, (pos1.y + pos2.y)/2 - player.width/2
end

function PlayState:enter()
	PlayState.super.enter(self)
	scene = self

	-- dummy
	self:addEntity(Dummy(50,50))

	-- setup tile map
	tileMap = TileMap("assets/maps/level.lua", nil, nil, self.bumpWorld)
	self:addEntity(tileMap)

	-- setup players
	player = Player(G.width - G.tile_size * 4, 80, 1)
	player2 = Player(G.tile_size * 3, 80, 2)

	self:addEntity(player)
	self:addEntity(player2)

	middlePoint = GameObject(getMiddlePoint(player.pos, player2.pos),0,0)
	middlePoint.collider = nil

	-- add borders
	-- self:addEntity(Square(0, 0, {255,255,255}, G.tile_size, G.height))
	-- self:addEntity(Square(G.width-G.tile_size, 0, {255,255,255}, G.tile_size, G.height))
	-- self:addEntity(Square(0, 0, {255,255,255}, G.width, G.tile_size))
	-- self:addEntity(Square(0, G.height-16, {255,255,255}, G.width, G.tile_size))

	self:addEntity(Disc(G.width/2, G.width/2))

	-- setup camera
	-- self.camera:setPosition(middlePoint.pos.x, middlePoint.pos.y)
	-- self.camera:startFollowing(middlePoint, 0, 0)
	-- self.camera.followSpeed = 5

	-- setup shaders
	PaletteSwitcher.init('assets/img/palettes.png', 'alphonsus/shaders/palette.fs');
	sepiaShader = love.graphics.newShader('alphonsus/shaders/sepia.fs')
	bloomShader = love.graphics.newShader('alphonsus/shaders/bloom.fs')

	effect = moonshine(moonshine.effects.filmgrain)
	-- effect.filmgrain.size = 2
end

function PlayState:stateUpdate(dt)
	PlayState.super.stateUpdate(self, dt)

	local x, y = getMiddlePoint(player.pos, player2.pos)
	middlePoint.pos.x = x
	middlePoint.pos.y = y

	local d = _.distance(player.pos.x, player.pos.y, player2.pos.x, player2.pos.y)

	self.camera.zoom = 1
	if d > G.height then
		self.camera.zoom = 0.8
	end

	if d > G.height * 1.5 then
		self.camera.zoom = 0.6
	end

	if Input.wasKeyPressed('`') then
		G.debug = not G.debug
 	end

 	if Input.wasKeyPressed('r') then
		Gamestate.switch(PlayState())
	end

	if Input.wasKeyPressed('z') then
		player:jump()
	end

	if Input.wasPressed('zoomIn') then
		self.camera.zoom = self.camera.zoom+0.2
	end

	if Input.wasPressed('zoomOut') then
		self.camera.zoom = self.camera.zoom-0.2
	end
end

function PlayState:draw()
	-- moonshine shader
	-- effect(function()
		-- PlayState.super.draw(self)
	-- end)

	-- palette switcher
	-- PaletteSwitcher.set();
	-- love.graphics.setShader(bloomShader)

	PlayState.super.draw(self)

	-- PaletteSwitcher.unset()
	-- love.graphics.setShader()
end

return PlayState