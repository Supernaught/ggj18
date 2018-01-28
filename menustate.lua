local assets =  require "assets"
local timer = require "lib.hump.timer"
local Scene = require "alphonsus.scene"
local Input = require "alphonsus.input"
local UIText = require "alphonsus.uitext"
local GameObject = require "alphonsus.gameobject"
local Sprite = require "entities.sprite"

local Gamestate = require "lib.hump.gamestate"
local shack = require "lib.shack"
local flux = require "lib.flux"

local PlayState = require "playstate"
local MenuState = Scene:extend()

function MenuState:enter()
	MenuState.super.enter(self)
	-- local titleText = UIText(0, -20, "GGJ18 GAME", nil, nil, nil, assets.font_lg)
	local subtitle = UIText(0, love.graphics.getHeight()/G.scale - 50, "PRESS START TO PLAY", nil, nil, 24, assets.font_sm)
	local supernaught = UIText(0, love.graphics.getHeight()/G.scale - 24, "A GAME BY SUPERNAUGHT 2018", nil, nil, 8, assets.font_sm)

	self.bgColor = G.colors.bg

	local spriteW = assets.logo1:getWidth()
	local spriteH = assets.logo1:getHeight()
	local centerX = G.width/2 - spriteW/2

	local pos = {x = centerX, y = 60}

	local logo1 = Sprite(assets.logo1, centerX, -spriteH)
	local logo2 = Sprite(assets.logo2, centerX, G.height)
	local logo3 = Sprite(assets.logo3, -spriteW, pos.y)

	logo1.scale.x = 1
	logo2.scale.x = 1
	logo3.scale.x = 1
	logo1.scale.y = 1
	logo2.scale.y = 1
	logo3.scale.y = 1

	logo3.layer = 700
	logo2.layer = 800
	logo1.layer = 999

	self:addEntity(logo3)
	self:addEntity(logo2)
	self:addEntity(logo1)

	flux.to(logo1.pos, 2, { x = pos.x, y = pos.y }):ease("elasticinout")
	flux.to(logo2.pos, 2, { x = pos.x, y = pos.y }):ease("elasticinout")
	flux.to(logo3.pos, 2, { x = pos.x, y = pos.y }):delay(0.6):ease("elasticinout")

	timer.after(2.5, function()
		self:addEntity(subtitle)
		self:addEntity(supernaught)
	end)
	-- flux.to(titleText, 1, {fontScale = 1}):ease("backout")
end

function MenuState:stateUpdate(dt)
	MenuState.super.stateUpdate(self, dt)

	if Input.wasKeyPressed('return') or Input.wasGamepadPressed('start', 1) or Input.wasGamepadPressed('start', 2) then
		Gamestate.switch(PlayState())
	end
end

return MenuState