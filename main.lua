function love.load()

    anim8 = require 'libraries/anim8/anim8'
    windField = require 'libraries/windfield/windfield'

    love.window.setMode(1920,1080)
    love.graphics.setDefaultFilter( "nearest", "nearest" )
    love.graphics.setBackgroundColor(161/255, 113/255, 49/255, 1)
     

    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'

    camera = cameraFile(nil,nil)

    world = windField.newWorld()
    world:addCollisionClass('Player')
    world:addCollisionClass('Boundry')

    
    player = {}
    player.collider = world:newRectangleCollider(0,0,44,64, {collision_class = "Player" })
    player.collider:setFixedRotation(true)
    player.collider:setX(2700)
    player.collider:setY(2000)
    player.speed = 300
    player.spriteSheet = love.graphics.newImage('tiny-RPG-forest-files/PNG/spritesheets/hero/hero-sprite-sheet.png')
    player.grid = anim8.newGrid(32,32, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.direction = 'down'
    player.perfromingAction = false
    player.isFullyDrawn = false

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

    -- Bow animations
    player.animations.bow = {}
    player.animations.bow.up= anim8.newAnimation(player.grid('1-3', 9), 0.2)
    player.animations.bow.down= anim8.newAnimation(player.grid('1-3', 10), 0.2)
    player.animations.bow.right= anim8.newAnimation(player.grid('1-3',11), 0.2)
    player.animations.bow.left= anim8.newAnimation(player.grid('1-3', 12), 0.2)

    player.currentAnimation = player.animations.idle.down

    boundries = {}

    loadMap("TutorialMap")
end

function love.update(dt)

    local vectorX, vectorY = 0, 0
    local isMoving = false

    if player.perfromingAction == false then
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


    if love.mouse.isDown(1) then
        player.perfromingAction = true

            player.currentAnimation = player.animations.bow.down
            player.currentAnimation.status = "playing"

            if player.currentAnimation.position == 3 then
                player.isFullyDrawn = true  
                player.currentAnimation:pause()    
            end

        
      
        
    end

     
   

    player.currentAnimation:update(dt)
    world:update(dt)
    gameMap:update(dt)
    camera:lookAt(player.collider:getX(), player.collider:getY())

end

function love.draw()
    love.graphics.print(player.currentAnimation.position)
    
    camera:attach()
      
        
        -- gameMap:drawLayer(gameMap.layers['BaseLayer'])
        gameMap:drawLayer(gameMap.layers['DecorLayer'])
        gameMap:drawLayer(gameMap.layers['TreeLayer'])
        world:draw()

        player.currentAnimation:draw(player.spriteSheet, player.collider:getX(), player.collider:getY(), nil, 4 , nil, 16, 20)

    camera:detach()
    
    
end

function loadMap(mapName)
    gameMap = sti("maps/" .. mapName .. ".lua")
    
    for index, object in pairs(gameMap.layers["Boundries"].objects) do
        makeBoundry(object.x, object.y, object.width, object.height )
    end
end

function love.keypressed(key)

	if key == "escape" then
		love.event.quit()
	end

end

function love.mousereleased( x, y, button, istouch, presses )
    if button == 1 then
        
        player.currentAnimation:gotoFrame(1)
        player.currentAnimation:resume()
        player.perfromingAction = false
        player.isFullyDrawn = false
        
         
    end
end

function makeBoundry(x, y, width, height) 
    if width > 0 and height > 0 then
        local boundry = world:newRectangleCollider(x, y, width, height, {collision_class = "Boundry"})
        boundry:setType("static")
        table.insert(boundries, boundry)
    end
end
