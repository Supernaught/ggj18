G = {
  title = "Game Title",
  scale = 3,
  tile_size = 16,
  width = 16 * 18,
  height = 16 * 14,
  fullscreen = true,
  fullscreen = false,
  debug = false,

  platformer = true, -- used for gravity logic in movableSystem
  gravity = -1000,

  layers = {
    bg              = 100,
    default         = 200,
    tiles           = 300,
    enemy           = 500,
    particles       = 510,
    bulletTrail     = 690,
    bullet          = 700,
    player          = 800,
    explosion       = 810,
    ui              = 999,
  },

  colors = {
    bg = {14,17,21,255},
    red = {255,100,100},
    green = {100,255,100},

    p_red = {190,38,51,255},
    p_blue = {0,139,214,255},
    p_green = {83,171,32,255},
    p_orange = {235,137,49,255},

    [1] = {190,38,51,255},
    [2] = {0,139,214,255},
    [3] = {83,171,32,255},
    [4] = {235,137,49,255},
  },

  powerups = {
    dual = "dual",
    speed = "speed",
    bounce = "bounce",
    size = "size"
  },
  powerups_array = {
    "dual", "speed", "bounce", "size"
  },

  maxBounces = 3,
  maxHp = 5,

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