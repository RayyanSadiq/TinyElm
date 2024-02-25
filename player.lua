player = world:newRectangleCollider(0, 0, 48, 82, { collision_class = "Player" })
player:setFixedRotation(true)
player:setX(2700)
player:setY(2000)
player.speed = 250
player.direction = 'down'
player.isDrawingBow = false
player.isFullyDrawn = false
player.currentAnimation = sprites.player.animations.idle.down
player.bowTween = false
player.bowTweenTimer = 0.2

 
function playerUpdate(dt)
    local vectorX, vectorY = 0, 0
    local isMoving = false

    if player.isDrawingBow == false then
        if love.keyboard.isDown("w") then
            vectorY = -1
            player.direction = 'up'
            player.currentAnimation = sprites.player.animations.walk.up
            isMoving = true
        end

        if love.keyboard.isDown("s") then
            vectorY = 1
            player.direction = 'down'
            player.currentAnimation = sprites.player.animations.walk.down
            isMoving = true
        end

        if love.keyboard.isDown("d") then
            vectorX = 1
            player.direction = 'right'
            player.currentAnimation = sprites.player.animations.walk.right
            isMoving = true
        end

        if love.keyboard.isDown("a") then
            vectorX = -1
            player.direction = 'left'
            player.currentAnimation = sprites.player.animations.walk.left
            isMoving = true
        end
    end

    if isMoving == false then
        player.currentAnimation = sprites.player.animations.idle[player.direction]
    end

    local length = math.sqrt(vectorX ^ 2 + vectorY ^ 2)

    if length ~= 0 then
        vectorX = vectorX / length
        vectorY = vectorY / length
    end

    player:setLinearVelocity(vectorX * player.speed, vectorY * player.speed)


    if love.mouse.isDown(1) then
        player.isDrawingBow = true
        player.currentAnimation = sprites.player.animations.bow[player.direction]

        if player.bowTweenTimer > 0 then
            player.bowTweenTimer = player.bowTweenTimer - dt
        end

        if player.bowTweenTimer <= 0 then
            flux.to(camera, 0.4, {scale = 1.2})
            
        end
        

        if player.currentAnimation.position == 3 then
            player.isFullyDrawn = true
            player.currentAnimation:pause()
        end
    end

    player.currentAnimation:update(dt)
    
end

function playerDraw ()
    player.currentAnimation:draw(sprites.player.spriteSheet, player:getX(), player:getY(), nil, 4 , nil, 15, 20)

end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
         
        if player.isFullyDrawn then
            spawnArrow(player.direction)
        end
     
        flux.to(camera, 0.2, {scale = 1})
        player.bowTweenTimer = 0.2
        player.currentAnimation:gotoFrame(1)
        player.currentAnimation:resume()
        player.isDrawingBow = false
        player.isFullyDrawn = false
    end
end
