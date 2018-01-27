--
-- FollowSystem
-- by Alphonsus
--
--

local System = require "lib.knife.system"

local drawSystem = System(
	{ "isFollow", "follow" },
	function(isFollow, follow, e)
		e.pos.x = follow.pos.x
		e.pos.y = follow.pos.y
	end
)

return drawSystem