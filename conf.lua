G = {
  title = "Game Title",
  width = 240,
  height = 180,
  scale = 3,
  tile_size = 16,
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
  }
}

function love.conf(t)
  t.window.title = G.title
  t.window.resizable = false
  t.window.width = G.width * G.scale
  t.window.height = G.height * G.scale
  -- t.window.vsync = false
end