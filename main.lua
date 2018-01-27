io.stdout:setvbuf("no")
tlog = require "alphonsus.tlog"

local Input = require "alphonsus.input"

local Gamestate = require "lib.hump.gamestate"
local gamera = require "lib.gamera"
local push = require "lib.push"
local shack = require "lib.shack"
local flux = require "lib.flux"
local timer = require "lib.hump.timer"

local assets = require "assets"

local PlayState = require "playstate"
local MenuState = require "menustate"

function love.load()
	love.mouse.setVisible(false)

	-- setup push screen
	local windowWidth, windowHeight
	local gameWidth, gameHeight
	if G.fullscreen then
		windowWidth, windowHeight = love.window.getDesktopDimensions()
		gameWidth, gameHeight = love.window.getDesktopDimensions()
	else
		gameWidth, gameHeight = G.width, G.height
		windowWidth, windowHeight = G.width * G.scale, G.height * G.scale
	end
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = G.fullscreen, pixelperfect = true})

	-- setup screenshake
	shack:setDimensions(push:getDimensions())

	-- register controls
	Input.register({
		["zoomIn"] = {"1"},
		["zoomOut"] = {"2"},
		["rotate"] = {"3"},

		["3_left"] = {"a"},
		["3_right"] = {"d"},
		["3_down"] = {"s"},
		["3_up"] = {"w"},
		["3_shoot"]  = { "space", gamepad = { "a" }},

		["4_left"] = {"left"},
		["4_right"] = {"right"},
		["4_down"] = {"down"},
		["4_up"] = {"up"},
		["4_shoot"]  = { "]", gamepad = { "a" } },

		["1_left"] = {""},
		["1_right"] = {""},
		["1_down"] = {""},
		["1_up"] = {""},
		["1_shoot"]  = {""},

		["2_left"] = {""},
		["2_right"] = {""},
		["2_down"] = {""},
		["2_up"] = {""},
		["2_shoot"]  = {""},
	})

	-- setup Gamestate
	Gamestate.registerEvents()
	playState = PlayState()
	menuState = MenuState()
	-- Gamestate.switch(menuState)
	Gamestate.switch(playState)
end

function love.update(dt)
	shack:update(dt)
	timer.update(dt)
	flux.update(dt)
end

function love.draw()
end

function setupBgMusic()
	-- assets.music:setVolume(0.8)
	-- assets.music:setLooping(true)
	-- assets.music:play()
end