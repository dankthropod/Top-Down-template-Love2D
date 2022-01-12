function love.load()
    wf = require 'libraries/windfield'
    world = wf.newWorld(0,0)

    camera = require 'libraries/camera'
    cam = camera()

    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require 'libraries/sti'
    gameMap = sti('maps/testMap.lua')

    player = {}
    player.collider = world:newBSGRectangleCollider(400, 250, 40, 80, 10)
    player.collider:setFixedRotation(true)
    player.x = 400
    player.y = 200
    player.speed = 300
    player.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    player.grid = anim8.newGrid( 12, 18,player.spriteSheet:getWidth(), player.spriteSheet:getHeight() )

    player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    player.animations.left = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
    player.animations.right = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
    player.animations.up = anim8.newAnimation( player.grid('1-4', 4), 0.2 )

    player.anim = player.animations.left

    font = love.graphics.setNewFont('sprites/fonts/VT323-Regular.ttf',30)

    dialogueBox = love.graphics.newImage('sprites/dialogue_box.png')

    dialogue = {}
    dialogue.demo = {}
    dialogue.demo.1 = 'Hello World!'
    dialogue.demo.2 = 'Did you hear about lua?''
    dialogue.demo.3 = 'They say its pretty cool...'
    dialogue.hasSkipped = false

    walls = {}
    if gameMap.layers["Walls"] then
      for i, obj in pairs(gameMap.layers["Walls"].objects) do
        local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
        wall:setType('static')
        table.insert(walls, wall)
      end
    end
end

function love.update(dt)
    local isMoving = false

    local vx = 0
    local vy = 0

    if love.keyboard.isDown("d") then
        vx = player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("a") then
        vx = player.speed * -1
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("s") then
        vy = player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("w") then
        vy = player.speed * -1
        player.anim = player.animations.up
        isMoving = true
    end

    if vy == (player.speed) or (player.speed * -1) then
      -- vx = 0
    end

    player.collider:setLinearVelocity(vx, vy)

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Left border
    if cam.x < w/2 then
      cam.x = w/2
    end

    -- Upper border
    if cam.y < h/2 then
      cam.y = h/2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- Right border
    if cam.x > (mapW - w/2) then
      cam.x = (mapW - w/2)
    end

    -- Bottom border
    if cam.y > (mapH - h/2) then
      cam.y = (mapH - h/2)
    end

end

function love.draw()
    -- game objects
    cam:attach()
      gameMap:drawLayer(gameMap.layers["Ground"])
      gameMap:drawLayer(gameMap.layers["Buildings"])
      gameMap:drawLayer(gameMap.layers["Detail"])
      gameMap:drawLayer(gameMap.layers["Trees"])
      player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5, nil, 6, 9)
      -- world:draw()
    cam:detach()
    -- ui
    love.graphics.draw(dialogueBox, 225, 350, nil, 10, 10)
    love.graphics.print('Hello World!', 241, 358)
end
