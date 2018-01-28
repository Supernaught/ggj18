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

assets.pHeads = {
	[1] = assets.head1,
	[2] = assets.head2,
	[3] = assets.head3,
	[4] = assets.head4,
}

assets.pAvatars = {
	[1] = love.graphics.newImage("assets/img/player1_avatar.png"),
	[2] = love.graphics.newImage("assets/img/player2_avatar.png"),
	[3] = love.graphics.newImage("assets/img/player3_avatar.png"),
	[4] = love.graphics.newImage("assets/img/player4_avatar.png"),
}

-- Fonts
assets.font_lg = love.graphics.newFont("assets/fonts/04b03.ttf", 24)
assets.font_md = love.graphics.newFont("assets/fonts/04b03.ttf", 16)
assets.font_sm = love.graphics.newFont("assets/fonts/04b03.ttf", 8)

assets.font2_lg = love.graphics.newFont("assets/fonts/press_start.ttf", 24)
assets.font2_md = love.graphics.newFont("assets/fonts/press_start.ttf", 16)
assets.font2_sm = love.graphics.newFont("assets/fonts/press_start.ttf", 8)

-- Sfx

-- SFX
assets.music1 = love.audio.newSource("assets/sfx/music1.ogg")
assets.music2 = love.audio.newSource("assets/sfx/music2.ogg")

assets.bullet_sfx_decoder = love.sound.newDecoder("assets/sfx/bullet_sfx.wav")
assets.bullet_sfx = love.audio.newSource(assets.bullet_sfx_decoder)

assets.boost_sfx_decoder = love.sound.newDecoder("assets/sfx/boost_sfx.wav")
assets.boost_sfx = love.audio.newSource(assets.boost_sfx_decoder)

-- new
assets.explode1_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/explode1.wav"))
assets.explode2_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/explode2.wav"))
assets.explode3_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/explode3.wav"))
assets.death = love.audio.newSource(love.sound.newDecoder("assets/sfx/death.wav"))

assets.hit1_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/enemyhit.wav"))

assets.shoot1_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/shoot1.wav"))
assets.shoot2_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/shoot2.wav"))
assets.shoot3_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/shoot3.wav"))

assets.dash1_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/dash1.wav"))
assets.dash2_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/dash2.wav"))

assets.powerup_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/powerup.wav"))
assets.pickdisc_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/pickdisc.wav"))

assets.sword_sfx = love.audio.newSource(love.sound.newDecoder("assets/sfx/sword.mp3"))

return assets
