local push = require "lib.push"
local timer = require "lib.hump.timer"
local Scene = require "alphonsus.scene"
local Input = require "alphonsus.input"
local GameObject = require "alphonsus.gameobject"

local PaletteSwitcher = require 'lib/PaletteSwitcher'
local shack = require "lib.shack"
local _ = require "lib.lume"
local moonshine = require "lib.moonshine"
local Gamestate = require "lib.hump.gamestate"

local assets = require "assets"
local Square = require "entities.square"
local Player = require "entities.player"
local Bullet = require "entities.bullet"
local Disc = require "entities.disc"
local TileMap = require "alphonsus.tilemap"
local Dummy = require "entities.Dummy"
local Powerup = require "entities.powerup"

local PlayState = Scene:extend()

-- entities
local player1 = nil
local player2 = nil
local player3 = nil
local player4 = nil
local middlePoint = {}
local tileMap = {}

local noOfPlayers = 4
local remainingPlayers = {}

-- helper function
function getMiddlePoint(pos1, pos2)
	return (pos1.x + pos2.x)/2 + player1.width/2, (pos1.y + pos2.y)/2 - player1.width/2
end

function PlayState:enter()
	PlayState.super.enter(self)
	scene = self

	-- dummy
	-- self:addEntity(Dummy(50,50))

	-- setup tile map
	tileMap = TileMap("assets/maps/level.lua", nil, nil, self.bumpWorld)
	self:addEntity(tileMap)

	for i=1,noOfPlayers,1 do
		table.insert(remainingPlayers,i)
	end

	-- setup players
	player1 = Player(G.tile_size * 5, G.tile_size * 5, 1)
	self:addEntity(player1)
	self:addEntity(Disc(player1.pos.x - G.tile_size, player1.pos.y - G.tile_size))


	player2 = Player(G.width - G.tile_size * 5, 80, 2)
	self:addEntity(player2)
	self:addEntity(Disc(player2.pos.x + G.tile_size, player2.pos.y - G.tile_size))

	if noOfPlayers > 2 then
		player3 = Player(G.tile_size * 5, G.height - G.tile_size * 5, 3)
		self:addEntity(player3)
		self:addEntity(Disc(player3.pos.x - G.tile_size, player3.pos.y + G.tile_size))
	end

	if noOfPlayers > 3 then
		player4 = Player(G.width - G.tile_size * 5, G.height - G.tile_size * 5, 4)
		self:addEntity(player4)
		self:addEntity(Disc(player4.pos.x + G.tile_size, player4.pos.y + G.tile_size))
	end

	-- add borders
	-- self:addEntity(Square(0, 0, {255,255,255}, G.tile_size, G.height))
	-- self:addEntity(Square(G.width-G.tile_size, 0, {255,255,255}, G.tile_size, G.height))
	-- self:addEntity(Square(0, 0, {255,255,255}, G.width, G.tile_size))
	-- self:addEntity(Square(0, G.height-16, {255,255,255}, G.width, G.tile_size))

	-- self:addEntity(Powerup(120,100))
	-- self:addEntity(Powerup(150,100))

	-- setup camera
	middlePoint = GameObject(getMiddlePoint(player1.pos, player2.pos),0,0)
	middlePoint.collider = nil
	self.camera:setPosition(middlePoint.pos.x, middlePoint.pos.y)
	self.camera:startFollowing(middlePoint, 0, 0)
	self.camera.followSpeed = 5

	-- setup shaders
	PaletteSwitcher.init('assets/img/palettes.png', 'alphonsus/shaders/palette.fs');
	sepiaShader = love.graphics.newShader('alphonsus/shaders/sepia.fs')
	bloomShader = love.graphics.newShader('alphonsus/shaders/bloom.fs')

	effect = moonshine(moonshine.effects.filmgrain)
	-- effect.filmgrain.size = 2

	timer.after(5, function()
		self:spawnPowerup()
		-- print("1")
	end)

	self.isGameOver = false
end

function PlayState:spawnPowerup()
	if self.isGameOver then return end

	local ts = G.tile_size
	local pos = _.randomchoice({
		-- { G.width/2, G.height/2 },
		{ ts * 4, ts * 4 },
		{ G.width - ts * 4, ts * 4 },
		{ ts * 4, G.height - ts * 4 },
		{ G.width - ts * 4, G.height - ts * 4 },
	})

	self:addEntity(Powerup(unpack(pos)))

	timer.after(5, function()
		self:spawnPowerup()
	end)
end

function PlayState:stateUpdate(dt)
	PlayState.super.stateUpdate(self, dt)

	-- local x, y = getMiddlePoint(player1.pos, player2.pos)
	-- middlePoint.pos.x = x
	-- middlePoint.pos.y = y

	local d = _.distance(player1.pos.x, player1.pos.y, player2.pos.x, player2.pos.y)

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

	-- if Input.wasKeyPressed('z') then
	-- 	player:jump()
	-- end

	-- if Input.wasPressed('zoomIn') then
	-- 	self.camera.zoom = self.camera.zoom+0.2
	-- end

	-- if Input.wasPressed('zoomOut') then
	-- 	self.camera.zoom = self.camera.zoom-0.2
	-- end
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

	-- player 1 UI
	push:start()
	shack:apply()
	love.graphics.draw(assets.p1, 0, 0)
	love.graphics.draw(assets.p2, G.width - 16, G.height - 16)

	if player1 then
		for i=1,player1.hp,1 do
			love.graphics.draw(assets.head1, 0 + (16*i), 0)
		end
	end

	if player2 then
		for i=player2.hp,1,-1 do
			love.graphics.draw(assets.head2, G.width - (16*5) + (16*i), G.height - 16)
		end
	end
	push:finish()

	-- PaletteSwitcher.unset()
	-- love.graphics.setShader()
end

function PlayState:playerDead(playerNo)
	table.remove(remainingPlayers, playerNo)
	if #remainingPlayers <= 1 then
		self:gameOver()
	end
end

function PlayState:gameOver()
	self.isGameOver = true

	timer.after(1, function()
		-- print("1")
	end)
	timer.after(2, function()
		-- print("2")
	end)
end

return PlayState