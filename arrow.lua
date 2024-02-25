arrows = {}

function arrowUpdate(dt)
    for i, arrow in ipairs(arrows) do
        arrow.collider:setLinearVelocity(arrow.speed.x, arrow.speed.y)
        arrow.lifeTime = arrow.lifeTime - dt

        local directionalSettings = {

            up = { xOffset = -8, yOffset = -30 },
            down = { xOffset = -8, yOffset = -30  },
            right = { xOffset = -26, yOffset = -8 },
            left = { xOffset = -32, yOffset = -8 },
            
        }

         local hitEnemies = world:queryRectangleArea(
            arrow.collider:getX() + directionalSettings[arrow.direction].xOffset ,  
            arrow.collider:getY() + directionalSettings[arrow.direction].yOffset , 
            arrow.width, arrow.height, 
            {'Treant'} )

        for _, treant in ipairs(hitEnemies) do
            treant.health = treant.health - arrow.damage
            treant.isHit = true
            treant.hitTimer = treant.initialHitTimer
            love.graphics.setColor(1,1,1)
        end

        if arrow.collider:enter('Boundry') or #hitEnemies > 0 or arrow.lifeTime <= 0 then
            arrow.collider:destroy()
            table.remove(arrows, i)
        end



    end
end

function drawArrow()
    count = 0
    for i in pairs(arrows) do count = count + 1 end

    for index, arrow in ipairs(arrows) do
        love.graphics.draw(
            arrow.sprite,
            arrow.collider:getX(),
            arrow.collider:getY(),
            angleFromDirection(arrow.direction),
            3,
            nil,
            arrow.sprite:getWidth() / 2,
            arrow.sprite:getHeight() / 2)
            
         
    end
end

function spawnArrow(direction)
    local arrow = {}
    arrow.sprite = sprites.arrow.sprite
    arrow.damage = 10
    arrow.lifeTime = 0.8
    arrow.direction = direction
    arrow.speed = { x = 0, y = 0 }
    arrow.scale = 3

    -- Table to store directional settings
    local directionalSettings = {
        right = { xOffset = 24, yOffset = 4, speedX = 600, width = arrow.sprite:getHeight(), height = arrow.sprite:getWidth() },
        left = { xOffset = -80, yOffset = 4, speedX = -600, width = arrow.sprite:getHeight(), height = arrow.sprite:getWidth() },
        up = { xOffset = -4, yOffset = 88, speedY = -600, width = arrow.sprite:getWidth(), height = arrow.sprite:getHeight() },
        down = { xOffset = -4, yOffset = -40, speedY = 600, width = arrow.sprite:getWidth(), height = arrow.sprite:getHeight() },
    }

    -- Check if passed direction is a valid value
    local settings = directionalSettings[direction]
    if not settings then
        error("Invalid direction: " .. direction)
    end

    -- Apply directional settings
    arrow.speed.x = settings.speedX or 0
    arrow.speed.y = settings.speedY or 0
    arrow.playerXOffset = settings.xOffset
    arrow.playerYOffset = settings.yOffset

    -- Calculate arrow dimensions
    arrow.width = settings.width * arrow.scale
    arrow.height = settings.height * arrow.scale

    -- Create arrow collider
    arrow.collider = world:newRectangleCollider(
        player:getX() + arrow.playerXOffset,
        player:getY() - arrow.playerYOffset,
        arrow.width,
        arrow.height,
        { collision_class = 'Arrow' }
    )

    -- Collider Settings
    arrow.collider:setFixedRotation(true)

    -- Add to arrow list
    table.insert(arrows, arrow)
end
