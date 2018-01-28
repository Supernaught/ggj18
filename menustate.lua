local assets =  require "assets"
local _ = require "lib.lume"
local timer = require "lib.hump.timer"
local Scene = require "alphonsus.scene"
local Input = require "alphonsus.input"
local UIText = require "alphonsus.uitext"
local GameObject = require "alphonsus.gameobject"
local Particles = require "alphonsus.particles"
local Sprite = require "entities.sprite"

local Gamestate = require "lib.hump.gamestate"
local shack = require "lib.shack"
local flux = require "lib.flux"

local PlayState = require "playstate"
local MenuState = Scene:extend()

function MenuState:enter()
	MenuState.super.enter(self)
	-- local titleText = UIText(0, -20, "GGJ18 GAME", nil, nil, nil, assets.font_lg)
	local subtitleY = love.graphics.getHeight()/G.scale - 75
	local supernaughtY = love.graphics.getHeight()/G.scale - 15
	local musicY = love.graphics.getHeight()/G.scale - 5
	local subtitle = UIText(0, subtitleY-16, "PRESS START TO PLAY", nil, nil, 24, assets.font2_sm)
	local supernaught = UIText(0, supernaughtY-16, "A GAME BY SUPERNAUGHT 2018", nil, nil, 8, assets.font_sm)
	local music = UIText(0, musicY-16, "Music by NateA6 & NoodleSushi", nil, nil, 8, assets.font_sm)

	self.bgColor = G.colors.bg

	local spriteW = assets.logo1:getWidth()
	local spriteH = assets.logo1:getHeight()
	local centerX = G.width/2 - spriteW/2

	local pos = {x = centerX, y = 60}

	local logo1 = Sprite(assets.logo1, centerX, -spriteH)
	local logo2 = Sprite(assets.logo2, centerX, G.height)
	local logo3 = Sprite(assets.logo3, -spriteW, pos.y)

	logo3.layer = 700
	logo2.layer = 800
	logo1.layer = 999

	self:addEntity(logo3)
	self:addEntity(logo2)
	self:addEntity(logo1)

	timer.after(0.75, function()
		assets.sword_sfx:clone():play()
	end)
	timer.after(1, function()
		assets.explode3_sfx:clone():play()
	end)

	flux.to(logo1.pos, 2, { x = pos.x, y = pos.y }):ease("elasticinout")
	flux.to(logo2.pos, 2, { x = pos.x, y = pos.y }):ease("elasticinout")
	flux.to(logo3.pos, 0.6, { x = pos.x, y = pos.y }):delay(1.4):ease("expoout")

	timer.after(2.5, function()
		flux.to(subtitle.pos, 1, { y = subtitleY }):ease("elasticout")

		self:addEntity(subtitle)
		self:addEntity(supernaught)
		self:addEntity(music)
	end)

	-- flux.to(titleText, 1, {fontScale = 1}):ease("backout")

	self.torchPos = {x=131, y=52}
	self.torchPs = Particles(self.torchPos.x, self.torchPos.y)
	local torch = require "entities.particles.torch"
	self.torchPs:load(torch)
	-- self.torchPs.ps:setColors(G.colors[self.playerNo])
	timer.after(2, function()
		self:addEntity(self.torchPs)
	end)
end

function MenuState:stateUpdate(dt)
	MenuState.super.stateUpdate(self, dt)

	self.torchPs.pos.x = self.torchPos.x + _.random(-3,3)
	self.torchPs.pos.y = self.torchPos.y
	self.torchPs.ps:emit(10)

	if Input.wasKeyPressed('return') or Input.wasGamepadPressed('start', 1) or Input.wasGamepadPressed('start', 2) then
		Gamestate.switch(PlayState())
	end
end

return MenuState