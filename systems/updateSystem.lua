--
-- UpdateSystem
-- by Alphonsus
--
-- calls entity's update() function, which is usually required for most objects
--
--

local System = require "lib.knife.system"

local updateSystem = System(
	{ "update" },
	function(update, entity, dt)
		if entity.animation then
			entity.animation:update(dt)
		end
		entity:update(dt)
	end
)

return updateSystem