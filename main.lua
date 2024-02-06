function love.load()

    love.window.setMode(1024,768)
    love.graphics.setDefaultFilter( "nearest" )

    sprites = {}
    sprites.player = love.graphics.newImage('tiny-RPG-forest-files/PNG/sprites/hero/idle/hero-idle-front/hero-idle-front.png')

    
    player = {}
    player.x = 100
    player.y = 100
    player.speed = 180

end

function love.update(dt)

    local moveX, moveY = 0, 0

    if love.keyboard.isDown("w") then
        moveY = moveY - 1
    end

    if love.keyboard.isDown("s") then
        moveY = moveY +  1
    end

    if love.keyboard.isDown("a") then
        moveX = moveX - 1
    end

    if love.keyboard.isDown("d") then
        moveX = moveX + 1
    end

    local length = math.sqrt(moveX^2 + moveY^2)

    if length ~= 0 then
        moveX = moveX/length
        moveY = moveY/length
    end

    player.x = player.x + moveX * player.speed * dt
    player.y = player.y + moveY * player.speed * dt

end

function love.draw()
    love.graphics.draw(sprites.player, player.x, player.y, nil, 4 , nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2 )
    
end
