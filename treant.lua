treants = {}

function treantUpdate(dt)
    for index, treant in ipairs(treants) do

        local xSpeed = 0
        local ySpeed = 0
        treant.isMoving = false

        if distanceBetween(treant:getX(), treant:getY(), player.collider:getX(), player.collider:getY()) <= treant.aggroRange then

            local angle = angleBetween(player.collider:getX(), player.collider:getY(), treant:getX(),treant:getY())

            xSpeed = math.cos(angle) * treant.speed
            ySpeed = math.sin(angle) * treant.speed

            angle = angle % (2 * math.pi)
            
            -- Define directional thresholds
            local thresholds = {
                { name = "down",  min = math.pi / 4,     max = 3 * math.pi / 4 },
                { name = "up",    min = 5 * math.pi / 4, max = 7 * math.pi / 4  },
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
            treant.currentAnimation = sprites.treant.animations.walk[treant.direction]
        else
            treant.currentAnimation = sprites.treant.animations.idle[treant.direction]
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
        treant.currentAnimation:draw(sprites.treant.spriteSheet, treant:getX(), treant:getY(), nil,
            treant.scale, nil, 15.5, 21)
    end
end

function spawnTreant(x, y)
    local treant = world:newRectangleCollider(x, y, 62, 100, {collision_class = 'Treant'})
    treant.direction = "down"
    treant.currentAnimation = sprites.treant.animations.idle.down
    treant.health = 40
    treant.speed = 120
    treant.scale = 4
    treant.aggroRange = 400
    treant.isMoving = false
    treant:setFixedRotation(true)

    table.insert(treants, treant)
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function angleBetween(x1, y1, x2, y2)
    return math.atan2(y1 - y2, x1 - x2)
end
