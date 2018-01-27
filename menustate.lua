local assets =  require "assets"

local Scene = require "alphonsus.scene"
local Input = require "alphonsus.input"
local UIText = require "alphonsus.uitext"
local GameObject = require "alphonsus.gameobject"

local Gamestate = require "lib.hump.gamestate"
local shack = require "lib.shack"
local flux = require "lib.flux"

local PlayState = require "playstate"
local MenuState = Scene:extend()

function MenuState:enter()
	MenuState.super.enter(self)
	local titleText = UIText(0, -20, "GGJ18 GAME", nil, nil, nil, assets.font_lg)
	local subtitle = UIText(0, love.graphics.getHeight()/G.scale - 50, "PRESS START TO PLAY", nil, nil, 24, assets.font_sm)

	self:addEntity(subtitle)
	self:addEntity(titleText)

	flux.to(titleText.pos, 1, {y = 50})
	-- flux.to(titleText, 1, {fontScale = 1}):ease("backout")
end

function MenuState:stateUpdate(dt)
	MenuState.super.stateUpdate(self, dt)
	flux.update(dt)

	if Input.wasKeyPressed('return') then
		Gamestate.switch(PlayState())
	end
end

return MenuState