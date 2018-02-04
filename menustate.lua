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
	local pressStartY = G.height * 0.7
	local supernaughtY = G.height * 0.95
	local musicY = supernaughtY + 10

	local pressStart = UIText(0, pressStartY-16, "PRESS START TO PLAY", nil, nil, 24, assets.font2_sm)
	local supernaught = UIText(0, supernaughtY-16, "A GAME BY SUPERNAUGHT FOR #GGJ2018", nil, nil, 8, assets.font_sm)
	local music = UIText(0, musicY-16, "Music by NateA6 & NoodleSushi", nil, nil, 8, assets.font_sm)

	self.bgColor = G.colors.bg

	local spriteW = assets.logo1:getWidth()
	local spriteH = assets.logo1:getHeight()
	local centerX = G.width/2 - spriteW/2

	local logoPos = {x = centerX, y = 60}

	local logo1 = Sprite(assets.logo1, centerX, -spriteH)
	local logo2 = Sprite(assets.logo2, centerX, G.height)
	local logo3 = Sprite(assets.logo3, -spriteW, logoPos.y)

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

	flux.to(logo1.pos, 2, { x = logoPos.x, y = logoPos.y }):ease("elasticinout")
	flux.to(logo2.pos, 2, { x = logoPos.x, y = logoPos.y }):ease("elasticinout")
	flux.to(logo3.pos, 0.6, { x = logoPos.x, y = logoPos.y }):delay(1.4):ease("expoout")

	timer.after(2.5, function()
		flux.to(pressStart.pos, 1, { y = pressStartY }):ease("elasticout")

		self:addEntity(pressStart)
		self:addEntity(supernaught)
		self:addEntity(music)
	end)

	self.torchPos = {x = centerX+53, y = logoPos.y - 8}
	self.torchPs = Particles(self.torchPos.x, self.torchPos.y)
	local torch = require "entities.particles.torch"
	self.torchPs:load(torch)

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