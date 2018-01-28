local assets = {}

love.graphics.setDefaultFilter("nearest", "nearest")

-- Images
assets.whiteCircle = love.graphics.newImage("assets/img/white_circle.png")
assets.whiteSquare = love.graphics.newImage("assets/img/white_square.png")
assets.player = love.graphics.newImage("assets/img/anim.png")
assets.bg = love.graphics.newImage("assets/img/bg.png")
assets.spritesheet = love.graphics.newImage("assets/img/spritesheet.png")

assets.logo1 = love.graphics.newImage("assets/img/logo1.png")
assets.logo2 = love.graphics.newImage("assets/img/logo2.png")
assets.logo3 = love.graphics.newImage("assets/img/logo3.png")

assets.p1 = love.graphics.newImage("assets/img/player1_label.png")
assets.p2 = love.graphics.newImage("assets/img/player2_label.png")
assets.p3 = love.graphics.newImage("assets/img/player3_label.png")
assets.p4 = love.graphics.newImage("assets/img/player4_label.png")

assets.head1 = love.graphics.newImage("assets/img/player1_healthicon.png")
assets.head2 = love.graphics.newImage("assets/img/player2_healthicon.png")
assets.head3 = love.graphics.newImage("assets/img/player3_healthicon.png")
assets.head4 = love.graphics.newImage("assets/img/player4_healthicon.png")

-- Fonts
assets.font_lg = love.graphics.newFont("assets/fonts/04b03.ttf", 24)
assets.font_md = love.graphics.newFont("assets/fonts/04b03.ttf", 16)
assets.font_sm = love.graphics.newFont("assets/fonts/04b03.ttf", 8)

assets.font2_lg = love.graphics.newFont("assets/fonts/press_start.ttf", 24)
assets.font2_md = love.graphics.newFont("assets/fonts/press_start.ttf", 16)
assets.font2_sm = love.graphics.newFont("assets/fonts/press_start.ttf", 8)

-- Sfx
-- assets.music = love.audio.newSource(love.sound.newDecoder("assets/sfx/music.mp3"))

return assets
