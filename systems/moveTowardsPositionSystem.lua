--
-- MoveTowardsPositionSystem
-- by Alphonsus
--
-- entity will move towards position {x, y}
--

local System = require "lib.knife.system"

local moveTowardsPositionSystem = System(
	{ "isMoveTowardsPosition", "targetPosition", "movable" },
	function(isMoveTowardsPosition, targetPosition, movable, entity, dt)
		if isMoveTowardsPosition then
			entity.movable.velocity.x = (targetPosition.x - entity.pos.x) * movable.speed.x
			entity.movable.velocity.y = (targetPosition.y - entity.pos.y) * movable.speed.y
		end
	end
)

return moveTowardsPositionSystem