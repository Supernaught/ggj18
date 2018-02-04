local assets =  require "assets"
local _ = require "lib.lume"
local anim8 = require "lib.anim8"
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
local CharacterSelectState = Scene:extend()

function CharacterSelectState:enter()
	CharacterSelectState.super.enter(self)
	self.bgColor = G.colors.bg

	self.players = {}
	self.sprites = {}

	-- setup ui
	self.title = UIText(0, 30, "CHARACTER SELECT", nil, nil, 24, assets.font2_md)
	self:addEntity(self.title)

	self.subtitle = UIText(0, 55, "PRESS [SHOOT] TO JOIN", nil, nil, 24, assets.font2_sm)
	self.subtitle:flicker(-1, 0.5)
	self:addEntity(self.subtitle)

	for i=1,4 do
		local p = Sprite(assets.spritesheet, 50, 80 + (i * 24), nil, nil, 1, 1)
		p.animation = assets.animations.player[i].idle
		p.ui = UIText(16, p.pos.y, "--", nil, nil, nil, assets.font2_sm)

		self.sprites[i] = p

		self:addEntity(p)
		self:addEntity(p.ui)
	end
end

function CharacterSelectState:stateUpdate(dt)
	CharacterSelectState.super.stateUpdate(self, dt)

	if Input.wasKeyPressed('return') or Input.wasGamepadButtonPressed('start', 1) or Input.wasGamepadButtonPressed('start', 2) then
		if #self.players > 1 then
			Gamestate.switch(PlayState(self.players))
		end
	end

	for i=1,4 do
		if Input.wasPressedByPlayer('shoot', i) and _.find(self.players, i) == nil then
			-- player i has joined
			assets.dash2_sfx:clone():play()

			table.insert(self.players, i)
			self.players = _.set(self.players)

			local sprite = self.sprites[i]
			sprite.ui.toRemove = true
			sprite.animation = assets.animations.player[i].run
			local currentY = sprite.pos.y
			sprite.pos.y = currentY-16
			flux.to(sprite.pos, 0.7, { y = currentY }):ease("elasticout")

			local joinedText = UIText(16, currentY-16, "PLAYER " .. i .. " HAS JOINED!!", nil, nil, nil, assets.font2_sm)
			flux.to(joinedText.pos, 0.7, { y = currentY }):ease("elasticout")
			self:addEntity(joinedText)

			if #self.players > 1 then
				self.subtitle.text = "PRESS [START] TO PLAY"
			end
		end
	end
end

return CharacterSelectState