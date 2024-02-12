player = {}
player.collider = world:newRectangleCollider(0, 0, 48, 82, { collision_class = "Player" })
player.collider:setFixedRotation(true)
player.collider:setX(2700)
player.collider:setY(2000)
player.speed = 250
player.direction = 'down'
player.perfromingAction = false
player.isFullyDrawn = false
player.currentAnimation = sprites.player.animations.idle.down


function playerUpdate(dt)
    local vectorX, vectorY = 0, 0
    local isMoving = false

    if player.perfromingAction == false then
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

    player.collider:setLinearVelocity(vectorX * player.speed, vectorY * player.speed)


    if love.mouse.isDown(1) then
        player.perfromingAction = true

        player.currentAnimation = sprites.player.animations.bow[player.direction]

        if player.currentAnimation.position == 3 then
            player.isFullyDrawn = true
            player.currentAnimation:pause()
        end
    end

    player.currentAnimation:update(dt)
end

function playerDraw ()
    player.currentAnimation:draw(sprites.player.spriteSheet, player.collider:getX(), player.collider:getY(), nil, 4 , nil, 15, 20)
end
