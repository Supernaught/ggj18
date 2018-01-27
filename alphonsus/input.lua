local _ = require "lib.lume"
local Input = {}

Input.map = {}
Input.pressed = {}
Input.gamepads = {}
Input.gamepadPressed = {}

-- gamepads structure:
-- Input.gamepads = {
-- 	[1] = {
-- 		leftx = 0.5,
-- 		lefty = 0.2,
-- 		a = true
-- 	},
-- 	[2] = {
-- 		leftx = 0.5,
-- 		lefty = 0.2,
-- 		x = false
-- 	},
-- 	pressed = {
-- 		[1] = { a = true },
-- 		[2] = { x = true }
-- 	}
-- }

function Input.register(id, keys)
	if type(id) == "table" then
		for k, v in pairs(id) do
			Input.register(k, v)
		end
		return
	end
	Input.map[id] = _.clone(keys)
end

---------------------
-- GAMEPAD
---------------------

-- operator is > or <
function Input.isAxisDown(joystickId, axis, operator, threshold)
	local gamepad = Input.gamepads[joystickId]
	if not gamepad then return false end

	local val = Input.gamepads[joystickId][axis] or 0
	if math.abs(val) < (threshold or 0.3) then return end

	if operator == '>' then
		return val > 0
	elseif operator == '<' then
		return val < 0
	end
end

function Input.isGamepadButtonDown(button, joystickId)
	local j = love.joystick.getJoysticks()[joystickId]
	if j then
		return j:isGamepadDown(button)
	end

	return false
end

function Input.wasGamepadPressed(button, joystickId)
	if joystickId then
		if Input.gamepadPressed[joystickId] then return Input.gamepadPressed[joystickId][button] end
	else
		for i, joystickPressed in ipairs(Input.gamepadPressed) do
			if joystickPressed[button] then return true end
		end
	end

	return false
end


---------------------
-- KEYBOARD
---------------------
function Input.onKeyPress(k)
	Input.pressed[k] = true
end

function Input.isKeyDown(k)
	return love.keyboard.isDown(k)
end

-- using mapped Input keys
function Input.isDown(id)
	local keys = Input.map[id]
	assert(keys, "Input ID not mapped: " .. id)
	return love.keyboard.isDown(unpack(keys))
end

-- check if key was pressed once
function Input.wasKeyPressed(k)
	return Input.pressed[k]
end

-- check if Input key was just pressed once
function Input.wasPressed(id)
	local keys = Input.map[id]
	assert(keys, "Input ID not mapped: " .. id)
	return _.any(keys, function(k) return Input.pressed[k] end)
end

function Input.clear()
	_.clear(Input.pressed)
	for i, gp in ipairs(Input.gamepadPressed) do
		_.clear(gp)
	end
end

return Input