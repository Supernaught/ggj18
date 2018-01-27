--
-- DrawSystem
-- by Alphonsus
--
-- calls the entity's draw() function
--

local System = require "lib.knife.system"

local drawSystem = System(
	{ "draw" },
	function(draw, e)
		if not e.isAlive then return end
		
		local x, y = e.pos.x, e.pos.y
		local sx, sy = e.scale.x or 1, e.scale.y or 1
		local angle = e.angle or 0

		local ox, oy = e.offset.x, e.offset.y

		if e.animation then
			e.animation.flippedH = e.flippedH or false
			e.animation:draw(e.sprite, x, y, angle, sx, sy, ox, oy)
		elseif e.sprite then
			love.graphics.draw(e.sprite, x, y, angle, sx, sy, ox, oy)
		end

		if e.draw then e:draw() end

		if e.isLayerYPos then
			e.layer = e.pos.y
		end

		if e.collider and G.debug then
			love.graphics.setColor(255, 0, 0)
			love.graphics.rectangle("line", e.collider.x, e.collider.y, e.collider.w, e.collider.h)
			love.graphics.setColor(255, 255, 255)
		end
		-- local an = e.animation

		--    local alpha = e.alpha or 1
		--    local pos, sprite, scale, rot, offset = e.pos, e.sprite, e.scale, e.angle, e.offset
		--    local sx, sy, r, ox, oy = scale and scale.x or 1, scale and scale.y or 1, rot or 0, offset and offset.x or 0, offset and offset.y or 0
		--    love.graphics.setColor(255, 255, 255, math.max(0, math.min(1, alpha)) * 255)

		--    if e.spark then
		--        -- love.graphics.setShader(assets.spark_shader)
		--        timer.after(0.02, function() e.spark = false end)
		--    end

		--    if an then
		--        love.graphics.setColor(254,254,254,254)
		--        an.flippedH = e.flippedH or false
		--        an:update(dt)
		--        an:draw(sprite, pos.x, pos.y, r, sx, sy, ox, oy)

		--    elseif sprite then
		--        love.graphics.draw(sprite, pos.x, pos.y, r, sx, sy, ox, oy)
		--    end
	end
)

return drawSystem