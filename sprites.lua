sprites = {}

-- player graphics
sprites.player = {}
sprites.player.spriteSheet = love.graphics.newImage('tiny-RPG-forest-files/PNG/spritesheets/hero/hero-sprite-sheet.png')
sprites.player.grid = anim8.newGrid(32, 32, sprites.player.spriteSheet:getWidth(), sprites.player.spriteSheet:getHeight())
sprites.player.animations = {}

-- idle animations
sprites.player.animations.idle = {}
sprites.player.animations.idle.up = anim8.newAnimation(sprites.player.grid('1-1', 1), 100)
sprites.player.animations.idle.down = anim8.newAnimation(sprites.player.grid('1-1', 2), 100)
sprites.player.animations.idle.right = anim8.newAnimation(sprites.player.grid('1-1', 3), 100)
sprites.player.animations.idle.left = anim8.newAnimation(sprites.player.grid('1-1', 4), 100)

-- Bow animations
sprites.player.animations.bow = {}
sprites.player.animations.bow.up = anim8.newAnimation(sprites.player.grid('1-3', 9), 0.2)
sprites.player.animations.bow.down = anim8.newAnimation(sprites.player.grid('1-3', 10), 0.2)
sprites.player.animations.bow.right = anim8.newAnimation(sprites.player.grid('1-3', 11), 0.2)
sprites.player.animations.bow.left = anim8.newAnimation(sprites.player.grid('1-3', 12), 0.2)

-- walk animations
sprites.player.animations.walk = {}
sprites.player.animations.walk.up = anim8.newAnimation(sprites.player.grid('1-6', 5), 0.1)
sprites.player.animations.walk.down = anim8.newAnimation(sprites.player.grid('1-6', 6), 0.1)
sprites.player.animations.walk.right = anim8.newAnimation(sprites.player.grid('1-6', 7), 0.1)
sprites.player.animations.walk.left = anim8.newAnimation(sprites.player.grid('1-6', 8), 0.1)

-- Arrow graphics
sprites.arrow = {}
sprites.arrow.sprite = love.graphics.newImage('tiny-RPG-forest-files/PNG/sprites/misc/arrow.png')

-- Treant graphics
sprites.treant = {}
sprites.treant.spriteSheet = love.graphics.newImage('tiny-RPG-forest-files/PNG/spritesheets/treant/treant-sprite-sheet.png')
sprites.treant.grid = anim8.newGrid(31, 35, sprites.treant.spriteSheet:getWidth(), sprites.treant.spriteSheet:getHeight())
sprites.treant.animations = {}

-- Treant idle animations
sprites.treant.animations.idle = {}
sprites.treant.animations.idle.up = anim8.newAnimation(sprites.treant.grid('1-1', 1), 100)
sprites.treant.animations.idle.down = anim8.newAnimation(sprites.treant.grid('1-1', 2), 100)
sprites.treant.animations.idle.right = anim8.newAnimation(sprites.treant.grid('1-1', 3), 100)
sprites.treant.animations.idle.left = anim8.newAnimation(sprites.treant.grid('1-1', 4), 100)

-- Treant walk animations
sprites.treant.animations.walk = {}
sprites.treant.animations.walk.up = anim8.newAnimation(sprites.treant.grid('1-4', 5), 0.25)
sprites.treant.animations.walk.down = anim8.newAnimation(sprites.treant.grid('1-4', 6), 0.25)
sprites.treant.animations.walk.right = anim8.newAnimation(sprites.treant.grid('1-4', 7), 0.25)
sprites.treant.animations.walk.left = anim8.newAnimation(sprites.treant.grid('1-4', 8), 0.25)
