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
local tileMap = {}

local registeredPlayers = {}
local players = {}
local remainingPlayers = {}
local canGoToMenu = false
local ranking = {}
local kills = {}

-- positions
local positions = {
	[1] = {
		x = G.tile_size * 5,
		y = G.tile_size * 5,
		disc = {
			x = G.tile_size * 5 - G.tile_size,
			y = G.tile_size * 5 - G.tile_size
		},
		ui = {
			x = 0,
			y = 0,
		}
	},
	[2] = {
		x = G.width - G.tile_size * 5,
		y = G.height - G.tile_size * 5,
		disc = {
			x = G.width - G.tile_size * 5 + G.tile_size,
			y = G.height - G.tile_size * 5 + G.tile_size
		},
		ui = {
			x = G.width - G.tile_size,
			y = G.height - G.tile_size,
		}
	},
	[3] = {
		x = G.width - G.tile_size * 5,
		y = G.tile_size * 5,
		disc = {
			x = G.width - G.tile_size * 5 + G.tile_size,
			y = G.tile_size * 5 - G.tile_size
		},
		ui = {
			x = G.width - G.tile_size,
			y = 0,
		}
	},
	[4] = {
		x = G.tile_size * 5,
		y = G.height - G.tile_size * 5,
		disc = {
			x = G.tile_size * 5 - G.tile_size,
			y = G.height - G.tile_size * 5 + G.tile_size
		},
		ui = {
			x = 0,
			y = G.height - G.tile_size,
		}
	},
}


-- helper function

function PlayState:new(players)
	PlayState.super.new(self)
	registeredPlayers = players or {}
end

function PlayState:enter()
	PlayState.super.enter(self)
	scene = self

	tileMap = {}

	remainingPlayers = {}
	canGoToMenu = false
	ranking = {}

	-- setup tile map
	tileMap = TileMap("assets/maps/level.lua", nil, nil, self.bumpWorld)
	self:addEntity(tileMap)

	-- setup players
	for i,playerNo in ipairs(registeredPlayers) do
		local pos = positions[playerNo]
		p = Player(pos.x, pos.y, playerNo)
		table.insert(players, p)
		table.insert(remainingPlayers, playerNo)
		kills[playerNo] = 0
		self:addEntity(p)
		self:addEntity(Disc(pos.disc.x, pos.disc.y))
	end

	timer.after(8, function()
		self:spawnPowerup()
	end)

	self.isGameOver = false
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
end

function PlayState:stateUpdate(dt)
	PlayState.super.stateUpdate(self, dt)

	if Input.wasKeyPressed('`') then
		G.debug = not G.debug
 	end

 	if Input.wasKeyPressed('r') then
		Gamestate.switch(PlayState(registeredPlayers))
	end

	if self.isGameOver and canGoToMenu then
		if Input.wasKeyPressed('return') or Input.isGamepadButtonDown('start', 1) or Input.isGamepadButtonDown('start', 2) then
			Gamestate.switch(require "menustate")
		end
	end
end

function PlayState:stateDraw()
	PlayState.super.stateDraw(self)

	if not self.isGameOver then
		for i,p in ipairs(players) do
			local uiPos = positions[p.playerNo].ui
			love.graphics.draw(assets.pLabels[p.playerNo], uiPos.x, uiPos.y)
			for i=1,p.hp do
				local headStartPos = uiPos.x == 0 and uiPos.x or uiPos.x - (G.tile_size * (G.maxHp+1))
				love.graphics.draw(assets.pHeads[p.playerNo], headStartPos + (16*i), uiPos.y)
			end
		end
	end
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

		for i,r in pairs(kills) do
			table.insert(ranking, {playerNo=i,kills=r})
		end

		local bg = Square(0,0,{0,0,0,150},G.width,G.height)
		bg.isSolid = false
		bg.collider = nil
		bg.layer = G.layers.ui-10
		self:addEntity(bg)

		ranking = _.sort(ranking, function(a,b) return a.kills > b.kills end)

		timer.after(0.5, function()
			for i,r in ipairs(ranking) do
				local yPos = y+20+(20*(i+1))
				local xPos = G.width/2 - 40
				local killsText = UIText(xPos, yPos, " X " .. r.kills .. " KILLS", 150, "left", 24, assets.font2_sm)
				local icon = Sprite(assets.pAvatars[r.playerNo], xPos - 10, yPos-16, nil, nil)

				timer.after(0.2*i, function()
					assets.explode3_sfx:clone():play()
					flux.to(killsText.pos, 1, {y=yPos}):ease("elasticout")
					flux.to(icon.pos, 1, {y=yPos}):ease("elasticout")
					self:addEntity(killsText)
					self:addEntity(icon)
					scene.camera:shake(4)
				end)
			end

			canGoToMenu = true
		end)
	end)
end

return PlayState