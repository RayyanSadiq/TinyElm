treants = {}

function spawnTreant(x, y)
    local treant = world:newRectangleCollider(x, y, 53, 90, { collision_class = 'Treant' })
    treant.direction = "down"
    treant.currentAnimation = sprites.treant.animations.idle.down
    treant.health = 40
    treant.speed = 120
    treant.scale = 4
    treant.aggroRange = 400
    treant.isMoving = false
    treant.isHit = false
    treant.initialHitTimer = 0.2
    treant.hitTimer = 0

    -- Treant graphics
    treant.spriteSheet = love.graphics.newImage('tiny-RPG-forest-files/PNG/spritesheets/treant/treant-sprite-sheet.png')
    treant.grid = anim8.newGrid(31, 35, sprites.treant.spriteSheet:getWidth(),sprites.treant.spriteSheet:getHeight())
    treant.animations = {}

    -- Treant idle animations
    treant.animations.idle = {}
    treant.animations.idle.up = anim8.newAnimation(sprites.treant.grid('1-1', 1), 100)
    treant.animations.idle.down = anim8.newAnimation(sprites.treant.grid('1-1', 2), 100)
    treant.animations.idle.right = anim8.newAnimation(sprites.treant.grid('1-1', 3), 100)
    treant.animations.idle.left = anim8.newAnimation(sprites.treant.grid('1-1', 4), 100)

    -- Treant walk animations
    treant.animations.walk = {}
    treant.animations.walk.up = anim8.newAnimation(sprites.treant.grid('1-4', 5), 0.25)
    treant.animations.walk.down = anim8.newAnimation(sprites.treant.grid('1-4', 6), 0.25)
    treant.animations.walk.right = anim8.newAnimation(sprites.treant.grid('1-4', 7), 0.25)
    treant.animations.walk.left = anim8.newAnimation(sprites.treant.grid('1-4', 8), 0.25)

    treant:setFixedRotation(true)

    table.insert(treants, treant)
end


function treantUpdate(dt)
    for index, treant in ipairs(treants) do
        local xSpeed = 0
        local ySpeed = 0
        treant.isMoving = false

        if distanceBetween(treant:getX(), treant:getY(), player:getX(), player:getY()) <= treant.aggroRange then
            local angle = angleBetween(player:getX(), player:getY(), treant:getX(), treant:getY())

            xSpeed = math.cos(angle) * treant.speed
            ySpeed = math.sin(angle) * treant.speed

            angle = angle % (2 * math.pi)

            -- Define directional thresholds
            local thresholds = {
                { name = "down",  min = math.pi / 4,     max = 3 * math.pi / 4 },
                { name = "up",    min = 5 * math.pi / 4, max = 7 * math.pi / 4 },
                { name = "right", min = -math.pi / 4,    max = math.pi / 4 },
                { name = "left",  min = 3 * math.pi / 4, max = 5 * math.pi / 4 }
            }


            -- Determine direction based on angle
            for _, threshold in ipairs(thresholds) do
                if angle >= threshold.min and angle <= threshold.max then
                    treant.direction = threshold.name
                    break
                end
            end

            treant.isMoving = true
        end

        if treant.isMoving then
            treant.currentAnimation = treant.animations.walk[treant.direction]
        elseif treant.isMoving == false then
            treant.currentAnimation = treant.animations.idle[treant.direction]
        end

        if treant.isHit then
            if treant.hitTimer > 0 then
                treant.hitTimer = treant.hitTimer - dt
            elseif treant.hitTimer <= 0 then
                treant.isHit = false
            end
        end

        treant:setLinearVelocity(xSpeed, ySpeed)
        treant.currentAnimation:update(dt)

        if treant.health <= 0 then
            treant:destroy()
            table.remove(treants, index)
        end


    end
end

function treantDraw()
    for index, treant in ipairs(treants) do
        if treant.isHit then
            love.graphics.setColor(1,0.5,0.5)
        else
            love.graphics.setColor(1,1,1)
        end


        treant.currentAnimation:draw(sprites.treant.spriteSheet, treant:getX(), treant:getY(), nil,
            treant.scale, nil, 15.5, 21)
    end
    love.graphics.setColor(1,1,1)
end


function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function angleBetween(x1, y1, x2, y2)
    return math.atan2(y1 - y2, x1 - x2)
end
