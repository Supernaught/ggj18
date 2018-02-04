local push = require "lib.push"
local timer = require "lib.hump.timer"
local flux = require "lib.flux"
local Scene = require "alphonsus.scene"
local Input = require "alphonsus.input"
local GameObject = require "alphonsus.gameobject"

local PaletteSwitcher = require 'lib/PaletteSwitcher'
local shack = require "lib.shack"
local _ = require "lib.lume"
local moonshine = require "lib.moonshine"
local Gamestate = require "lib.hump.gamestate"

local assets = require "assets"
local UIText = require "alphonsus.uitext"
local Square = require "entities.square"
local Player = require "entities.player"
local Bullet = require "entities.bullet"
local Disc = require "entities.disc"
local TileMap = require "alphonsus.tilemap"
local Sprite = require "entities.sprite"
-- local Dummy = require "entities.dummy"
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
local canGoToMenu = false
local ranking = {}
local kills = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

-- helper function
function getMiddlePoint(pos1, pos2)
	return (pos1.x + pos2.x)/2 + player1.width/2, (pos1.y + pos2.y)/2 - player1.width/2
end

function PlayState:enter()

	PlayState.super.enter(self)
	scene = self

	player1 = nil
	player2 = nil
	player3 = nil
	player4 = nil
	middlePoint = {}
	tileMap = {}

	noOfPlayers = 4
	remainingPlayers = {}
	canGoToMenu = false
	ranking = {}
	kills = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
	}

	-- timer:clear()

	-- dummy
	-- self:addEntity(Dummy(50,50))

	-- setup tile map
	tileMap = TileMap("assets/maps/level.lua", nil, nil, self.bumpWorld)
	self:addEntity(tileMap)

	for i=1,noOfPlayers,1 do
		table.insert(remainingPlayers,i)
	end

	-- setup players
	-- P1
	player1 = Player(G.tile_size * 5, G.tile_size * 5, 1)
	self:addEntity(player1)
	self:addEntity(Disc(player1.pos.x - G.tile_size, player1.pos.y - G.tile_size))

	-- P2
	player2 = Player(G.width - G.tile_size * 5, G.height - G.tile_size * 5, 2)
	self:addEntity(player2)
	self:addEntity(Disc(player2.pos.x + G.tile_size, player2.pos.y + G.tile_size))

	-- P3
	if noOfPlayers > 2 then
		player3 = Player(G.width - G.tile_size * 5, G.tile_size * 5, 3)
		self:addEntity(player3)
		self:addEntity(Disc(player3.pos.x + G.tile_size, player3.pos.y - G.tile_size))
	end

	-- P4
	if noOfPlayers > 3 then
		player4 = Player(G.tile_size * 5, G.height - G.tile_size * 5, 4)
		self:addEntity(player4)
		self:addEntity(Disc(player4.pos.x - G.tile_size, player4.pos.y + G.tile_size))
	end

	-- setup camera
	middlePoint = GameObject(getMiddlePoint(player1.pos, player2.pos),0,0)
	middlePoint.collider = nil
	-- self.camera:setPosition(middlePoint.pos.x, middlePoint.pos.y)
	-- self.camera:startFollowing(middlePoint, 0, 0)
	-- self.camera.followSpeed = 5

	-- setup shaders
	PaletteSwitcher.init('assets/img/palettes.png', 'alphonsus/shaders/palette.fs');
	sepiaShader = love.graphics.newShader('alphonsus/shaders/sepia.fs')
	bloomShader = love.graphics.newShader('alphonsus/shaders/bloom.fs')

	effect = moonshine(moonshine.effects.filmgrain)
	-- effect.filmgrain.size = 2

	timer.after(10, function()
		self:spawnPowerup()
	end)

	self.isGameOver = false
	-- self:gameOver()
end

function PlayState:spawnPowerup()
	if self.isGameOver then return end

	local ts = G.tile_size
	local pos = _.randomchoice({
		{ G.width/2, ts * 4 }, -- top center
		{ G.width/2, G.height - ts * 4 },  -- bottom center

		{ ts * 4, G.height/2}, -- center left
		{ G.width - ts * 4, G.height/2},  -- center right


		{ ts * 4, ts * 4 }, --topleft
		{ G.width - ts * 4, ts * 4 }, --topright
		{ ts * 4, G.height - ts * 4 }, --bottomleft
		{ G.width - ts * 4, G.height - ts * 4 }, --bottomright
	})

	self:addEntity(Powerup(unpack(pos)))

	-- timer.after(5, function()
	-- 	self:spawnPowerup()
	-- end)
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

	if self.isGameOver and canGoToMenu then
		if Input.wasKeyPressed('return') or Input.isGamepadButtonDown('start', 1) or Input.isGamepadButtonDown('start', 2) then
			Gamestate.switch(require "menustate")
		end
	end
end

function PlayState:stateDraw()
	-- moonshine shader
	-- effect(function()
		-- PlayState.super.draw(self)
	-- end)

	-- palette switcher
	-- PaletteSwitcher.set();
	-- love.graphics.setShader(bloomShader)

	PlayState.super.stateDraw(self)

	-- player 1 UI
	if player1 then
		love.graphics.draw(assets.p1, 0, 0, 0, 1, 1)
		for i=1,player1.hp,1 do
			love.graphics.draw(assets.head1, 0 + (16*i), 0)
		end
	end

	if player2 then
		love.graphics.draw(assets.p2, G.width - 16, G.height - 16)
		for i=player2.hp,1,-1 do
			love.graphics.draw(assets.head2, G.width - (16 * (G.maxHp + 2)) + (16*i), G.height - 16)
		end
	end

	if player3 then
		love.graphics.draw(assets.p3, G.width - 16, 0)
		for i=player3.hp,1,-1 do
			love.graphics.draw(assets.head3, G.width - (16 * (G.maxHp + 2)) + (16*i), 0)
		end
	end

	if player4 then
		love.graphics.draw(assets.p4, 0, G.height-16)
		for i=player4.hp,1,-1 do
			love.graphics.draw(assets.head4, 0 + (16*i), G.height - 16)
		end
	end

	-- PaletteSwitcher.unset()
	-- love.graphics.setShader()
end

function PlayState:playerKilled(playerNo, killer)
	if self.isGameOver then return end

	kills[killer] = kills[killer] + 1
end

function PlayState:playerDead(playerNo, killer)
	_.remove(remainingPlayers, playerNo)

	if #remainingPlayers <= 1 then
		self:gameOver()
	end
end

function PlayState:gameOver()
	self.isGameOver = true

	timer.after(1, function()
		local winnerPlayerNo = remainingPlayers[1]

		local y = 65
		local y1,y2 = y,y+30
		local headImg = Sprite(assets.pAvatars[winnerPlayerNo], G.width/2, y1-16, nil, nil, 2,2)
		local winText = UIText(0, y2-16, "PLAYER " .. winnerPlayerNo .. " WINS!", nil, nil, 24, assets.font2_md)

		self:addEntity(headImg)
		flux.to(headImg.pos, 1, { y = y1 }):ease("elasticout")
		assets.explode3_sfx:clone():play()
		
		timer.after(0.5, function()
			self:addEntity(winText)
			assets.explode3_sfx:clone():play()
			flux.to(winText.pos, 1, { y = y2 }):ease("elasticout")
		end)


		scene.camera:shake(5)

		for i,r in ipairs(kills) do
			table.insert(ranking, {playerNo=i,kills=r})
		end

		local bg = Square(0,0,{0,0,0,150},G.width,G.height)
		bg.isSolid = false
		bg.collider = nil
		self:addEntity(bg)


		ranking = _.sort(ranking, function(a,b) return a.kills > b.kills end)

		timer.after(0.5, function()
			for i,r in ipairs(ranking) do
				local yPos = y+20+(20*(i+1))
				local xPos = G.width/2 - 40
				local w = UIText(xPos, yPos, " X " .. r.kills .. " KILLS", 150, "left", 24, assets.font2_sm)
				local icon = Sprite(assets.pAvatars[r.playerNo], xPos - 10, yPos-16, nil, nil)

				timer.after(0.2*i, function()
					assets.explode3_sfx:clone():play()
					flux.to(w.pos, 1, {y=yPos}):ease("elasticout")
					flux.to(icon.pos, 1, {y=yPos}):ease("elasticout")
					self:addEntity(w)
					self:addEntity(icon)
					scene.camera:shake(4)
				end)
			end

			canGoToMenu = true
		end)
	end)
end

return PlayState