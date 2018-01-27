--
-- MovableSystem
-- by Alphonsus
--
-- movement physics
--
-- Required:
--
-- self.movable = {
-- 	velocity = { x = 0, y = 0 },
-- 	acceleration = { x = 0, y = 0 },
-- 	drag = { x = 0, y = 0 },
-- 	maxVelocity = { x = math.huge, y = math.huge },
-- 	speed = { x = 0, y = 0 } -- used to assign to acceleration
-- }
--
--

local _ = require "lib.lume"
local vector = require "lib.hump.vector-light"
local Vec = require "lib.hump.vector"
local System = require "lib.knife.system"

local movableSystem = System(
	{ "movable" },
	function(movable, e, dt)		
		local mov = movable
		local vel, accel, maxVel, drag = mov.velocity, mov.acceleration, mov.maxVelocity, mov.drag

		-- Update velocity
		vel.x = vel.x + accel.x * dt
		vel.y = vel.y + accel.y * dt

		-- Update max velocity
		if maxVel.x > 0 and math.abs(vel.x) > maxVel.x then
			vel.x = maxVel.x * _.sign(vel.x)
		end
		if maxVel.y > 0 and math.abs(vel.y) > maxVel.y then
			vel.y = maxVel.y * _.sign(vel.y)
		end
		-- Update position
		-- local v = Vec(vel.x, vel.y):normalized()
		e.pos.x = e.pos.x + vel.x * dt
		e.pos.y = e.pos.y + vel.y * dt
		-- Apply drag if not accelerating
		if accel.x == 0 and drag.x > 0 then
			local sign = _.sign(vel.x)
			vel.x = vel.x - drag.x * dt * sign
			if (vel.x < 0) ~= (sign < 0) then
				vel.x = 0
			end
		end
		if accel.y == 0 and drag.y ~= 0 then
			if e.platformer then
				-- platformer physics
				-- generally drag.y is negative (gravity)
				vel.y = vel.y - drag.y * dt
				if e.platformer.isGrounded then
					-- warning: hacky
					-- reset the velocity to near zero if grounded
					vel.y = vel.y * 0.01
				end
			else
				-- topdown physics
				local sign = _.sign(vel.y)
				vel.y = vel.y - drag.y * dt * sign
				if (vel.y < 0) ~= (sign < 0) then
					vel.y = 0
				end
			end
		end
	end
)

return movableSystem