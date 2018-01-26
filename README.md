# loveplate

Yet another love2d boilerplate.

Docs to follow.

### Notes

Sample platformer component for player:

```lua
-- gravity
G.gravity = -1500

local maxVelocity = 275
local speed = maxVelocity * 10
local drag = maxVelocity * 4

-- movable component
self.movable = {
  velocity = { x = 0, y = 0 },
  acceleration = { x = 0, y = 0 },
  drag = { x = drag*1000, y = G.gravity },
  maxVelocity = { x = maxVelocity*0.6, y = maxVelocity },
  speed = { x = speed*1000, y = speed } -- used to assign to acceleration
}

-- platformer component
self.platformer = {
  isGrounded = false,
  jumpForce = -maxVelocity,
}

-- for variable jump, reduce the drag if jump button is held, for example:
local jump = love.keyboard.isDown('space')
if jump then
  self.movable.drag.y = G.gravity/2
else
  self.movable.drag.y = G.gravity
end
```