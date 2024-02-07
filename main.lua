function love.load()

    anim8 = require 'libraries/anim8/anim8'
    windField = require 'libraries/windfield/windfield'

    love.window.setMode(1024,768)
    love.graphics.setDefaultFilter( "nearest", "nearest" )
     

    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'

    camera = cameraFile(nil,nil)

    world = windField.newWorld()
   

    
    player = {}
    player.collider = world:newCircleCollider(0,0,40)
    player.collider:setX(2700)
    player.collider:setY(2000)
    player.speed = 300
    player.spriteSheet = love.graphics.newImage('tiny-RPG-forest-files/PNG/spritesheets/hero/walk/hero-walk-sheet.png')
    player.grid = anim8.newGrid(32,32, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.direction = 'down'

    player.animations = {}

    -- idle animations
    player.animations.idle = {}
    player.animations.idle.up = anim8.newAnimation(player.grid('1-1', 1), 100)
    player.animations.idle.down = anim8.newAnimation(player.grid('1-1', 2), 100)
    player.animations.idle.right = anim8.newAnimation(player.grid('1-1', 3), 100)
    player.animations.idle.left = anim8.newAnimation(player.grid('1-1',4),100)

    -- walk animations
    player.animations.walk = {}
    player.animations.walk.up = anim8.newAnimation(player.grid('1-6', 5), 0.1)
    player.animations.walk.down = anim8.newAnimation(player.grid('1-6', 6), 0.1)
    player.animations.walk.right = anim8.newAnimation(player.grid('1-6', 7), 0.1)
    player.animations.walk.left = anim8.newAnimation(player.grid('1-6', 8), 0.1)

    player.currentAnimation = player.animations.idle.down

    loadMap("TutorialMap")
end

function love.update(dt)

    local vectorX, vectorY = 0, 0
    local isMoving = false

    if love.keyboard.isDown("w") then
        vectorY = -1
        player.direction = 'up'
        player.currentAnimation = player.animations.walk.up
        isMoving = true
    end

    if love.keyboard.isDown("s") then
        vectorY = 1
        player.direction = 'down'
        player.currentAnimation = player.animations.walk.down
        isMoving = true
    end

    if love.keyboard.isDown("d") then
        vectorX = 1
        player.direction = 'right'
        player.currentAnimation = player.animations.walk.right
        isMoving = true
    end

    if love.keyboard.isDown("a") then
        vectorX = -1
        player.direction = 'left'
        player.currentAnimation = player.animations.walk.left
        isMoving = true
    end

    if isMoving == false then
        if player.direction == 'up' then
            player.currentAnimation = player.animations.idle.up

        elseif player.direction == 'down' then
            player.currentAnimation = player.animations.idle.down

        elseif player.direction == 'right' then
            player.currentAnimation = player.animations.idle.right

        elseif player.direction == 'left' then
            player.currentAnimation = player.animations.idle.left
        end
    end


    local length = math.sqrt(vectorX^2 + vectorY^2)

    if length ~= 0 then
        vectorX = vectorX/length
        vectorY = vectorY/length
    end

    player.collider:setLinearVelocity(vectorX * player.speed, vectorY * player.speed)

    player.currentAnimation:update(dt)
    world:update(dt)
    gameMap:update(dt)
    camera:lookAt(player.collider:getX(), player.collider:getY())
end

function love.draw()
    --world:draw()
    camera:attach()
         
        gameMap:drawLayer(gameMap.layers['BaseLayer'])
        gameMap:drawLayer(gameMap.layers['DecorLayer'])
        gameMap:drawLayer(gameMap.layers['TreeLayer'])
        
        player.currentAnimation:draw(player.spriteSheet, player.collider:getX(), player.collider:getY(), nil, 4 , nil, 16, 20)
    camera:detach()
    
    
end

function loadMap(mapName)
    gameMap = sti("maps/" .. mapName .. ".lua")
    
end
