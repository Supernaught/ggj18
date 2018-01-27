G = {
  title = "Game Title",
  scale = 3,
  tile_size = 16,
  width = 16 * 18,
  height = 16 * 14,
  fullscreen = true,
  fullscreen = false,
  debug = false,

  platformer = false, -- used for gravity logic in movableSystem
  gravity = -1500,

  layers = {
    bg         = 100,
    default    = 200,
    tiles      = 300,
    player     = 400,
    enemy      = 500,
    particles  = 510,
    explosion  = 600,
    bullet     = 700,
    ui         = 999,
  },

  colors = {
    red = {255,100,100},
    green = {100,255,100},
  },

  direction = {
    left = 'left',
    right = 'right',
    up = 'up',
    down = 'down',
    upleft = 'upleft',
    upright = 'upright',
    downleft = 'downleft',
    downright = 'downright',
  }
}

function love.conf(t)
  t.window.title = G.title
  t.window.resizable = false
  t.window.width = G.width * G.scale
  t.window.height = G.height * G.scale
  -- t.window.vsync = false
end