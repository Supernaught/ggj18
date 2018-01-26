--
-- RemoveSystem
-- by Alphonsus
--
-- used for removing entities from ECS world
--
--

local System = require "lib.knife.system"

local removeSystem = System(
	{ "toRemove" },
	function(toRemove, i, entities, bumpWorld)
		if toRemove then
			local e = entities[i]
			if e.onRemove then
				e.onRemove()
			end
			table.remove(entities, i)

			if e.collider then bumpWorld:remove(e) end
		end
	end
)

return removeSystem