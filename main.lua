function love.load()
    love.window.setMode(1920, 1080)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(161 / 255, 113 / 255, 49 / 255, 1)

    -- Loading and Requiring Libararies and Additional Frameworks

    anim8 = require 'libraries/anim8/anim8'
    windField = require 'libraries/windfield/windfield'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'
    flux = require 'libraries/flux'

    camera = cameraFile(nil, nil)

    world = windField.newWorld()
    world:setQueryDebugDrawing(true)
    world:addCollisionClass('Player')
    world:addCollisionClass('Boundry')
    world:addCollisionClass('Arrow')
    world:addCollisionClass('Treant')
   
    require("require")  -- requires for other .lua files must be in parathensis
    requireAll()

    boundries = {}

    loadMap("TutorialMap")

end

function love.update(dt)
    world:update(dt)
    playerUpdate(dt)
    arrowUpdate(dt) 
    treantUpdate(dt)
    flux.update(dt)
    gameMap:update(dt)
    camera:lookAt(player:getX(), player:getY())
end 

function love.draw()

    love.graphics.print(camera.scale)

    camera:attach()

    -- gameMap:drawLayer(gameMap.layers['BaseLayer'])
    
    gameMap:drawLayer(gameMap.layers['DecorLayer'])
    gameMap:drawLayer(gameMap.layers['TreeLayer'])
    world:draw()
    playerDraw()
    drawArrow()
    treantDraw()

    camera:detach()
  
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end



function loadMap(mapName)
    gameMap = sti("maps/" .. mapName .. ".lua")

    for index, object in pairs(gameMap.layers["Boundries"].objects) do
        makeBoundry(object.x, object.y, object.width, object.height)
    end

    for index, object in pairs(gameMap.layers["TreantLayer"].objects) do
        spawnTreant(object.x, object.y)
    end

end

function makeBoundry(x, y, width, height)
    if width > 0 and height > 0 then
        local boundry = world:newRectangleCollider(x, y, width, height, { collision_class = "Boundry" })
        boundry:setType("static")
        table.insert(boundries, boundry)
    
    end
end


function angleFromDirection(direction)
    local angles = {
        up = 0,
        down = math.pi,
        right = math.pi / 2,
        left = -math.pi / 2
    }
    return angles[direction] or error("Invalid direction: " .. direction)
end
