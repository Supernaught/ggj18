--
-- MoveTowardsAngleSystem
-- by Alphonsus
--
-- entity will move towards angle (via velocity)
--
-- Required:
--   - isMoveTowardsAngle = true
--   - angle
--   - movable
--

local System = require "lib.knife.system"

local moveTowardsAngleSystem = System(
	{ "isMoveTowardsAngle", "angle", "movable" },
	function(isMoveTowardsAngle, angle, movable, entity, dt)
		if isMoveTowardsAngle then
			entity.movable.velocity.x = math.cos(angle) * movable.speed.x
			entity.movable.velocity.y = math.sin(angle) * movable.speed.y
		end
	end
)

return moveTowardsAngleSystem