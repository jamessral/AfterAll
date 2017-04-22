-- GLOBALS
SCALE_FACTOR = 2

love.graphics.setDefaultFilter("nearest", "nearest")

function drawImage(image, x, y)
  love.graphics.draw(image, x, y, 0, SCALE_FACTOR, SCALE_FACTOR, 0, 0, 0, 0)
end

-- World
world = {}
world.WIDTH = 640
world.HEIGHT = 360
world.x = 0
world.scroll = function (speed, dt)
  world.x = world.x - speed * dt
end

-- Enemies
enemy1 = {}

-- Player
player = {}
player.x = 300
player.xDirection = 1
player.y = 300
player.speed = 200
player.SHOOT_TIME = 50
player.shootCooldown = 0
player.bullets = {}
player.isMoving = false
player.isShooting = false
player.currentWalkingIndex = 1
player.currentShootingIndex = 1
player.walkingImages = {}
player.shootingImages = {}
player.drawPlayer = function (image, x, y)
  love.graphics.draw(image, x, y, 0, SCALE_FACTOR * player.xDirection, SCALE_FACTOR, 0, 0, 0, 0)
end
player.animate = function (dt)
  if player.isMoving then
    player.currentImage = player.walkingImages[player.currentWalkingIndex]
    if dt >= (1/60) then
      if player.currentWalkingIndex < 4 then
        player.currentWalkingIndex = player.currentWalkingIndex + 1
      else
        player.currentWalkingIndex = 1
      end
    end
  else
    player.currentImage = player.baseImage
  end

  if player.isShooting then
    player.currentImage = player.shootingImages[player.currentShootingIndex]
    if dt >= (1/60) then
      if player.currentShootingIndex < 5 then
        player.currentShootingIndex = player.currentShootingIndex + 1
      else
        player.currentShootingIndex = 1
      end
    end
  end
end

player.shoot = function (dt)
  local xButton = love.keyboard.isDown("x")
  if xButton and player.shootCooldown == player.SHOOT_TIME then
    player.isShooting = true
  else
    if player.shootCooldown < player.SHOOT_TIME then
      player.shootCooldown = player.shootCooldown + dt
    end
    if player.shootCooldown >= player.SHOOT_TIME then
      player.shootCooldown = player.SHOOT_TIME
    end

    player.isShooting = false
  end
end

player.move = function (dt)
    local up = false
    local down = false
    local left = false
    local right = false

    local speed = player.speed

    player.isMoving = false

    if love.keyboard.isDown("up") then up = true end
    if love.keyboard.isDown("down") then down = true end
    if love.keyboard.isDown("left") then left = true end
    if love.keyboard.isDown("right") then right = true end

    if up and down then up, down = false end
    if left and right then left, right = false end

    -- correct speed for diagonals
    if (up and left) or (up and right) or (down and left) or (down and right) then
      speed = speed / math.sqrt(2)
    end

    -- make sure player doesn't go off screen
    local isScrolling = false

    if (player.x >= world.WIDTH - world.WIDTH * 0.2) and right then
      world.scroll(speed, dt)
      right = false
      isScrolling = true
    end

    if (player.x <= 20) and left then
      world.scroll(-speed, dt)
      left = false
      isScrolling = true
    end

    if (player.y <= 250) and up then
      up = false
    end

    if (player.y >= world.HEIGHT - 16 - 20) and down then
      down = false
    end

    if up then player.y = player.y - speed * dt end
    if down then player.y = player.y + speed * dt end
    if left then
      player.x = player.x - speed * dt
      player.xDirection = -1
    end
    if right then
      player.x = player.x + speed * dt
      player.xDirection = 1
    end

    if up or down or left or right or isScrolling then
      player.isMoving = true
    else
      player.isMoving = false
    end
  end

-- Enemy1
enemy1 = {}

-- Enemy2
enemy2 = {}

function love.load()
  world.backgroundImage = love.graphics.newImage("assets/background.png")
  player.baseImage = love.graphics.newImage("assets/nuclearMan1.png")
  -- player walking images
  table.insert( player.walkingImages, player.baseImage)
  table.insert( player.walkingImages, love.graphics.newImage("assets/nuclearMan2.png"))
  table.insert( player.walkingImages, love.graphics.newImage("assets/nuclearMan3.png"))
  table.insert( player.walkingImages, love.graphics.newImage("assets/nuclearMan4.png"))
  table.insert( player.walkingImages, love.graphics.newImage("assets/nuclearMan5.png"))
  table.insert( player.walkingImages, love.graphics.newImage("assets/nuclearMan6.png"))

  -- player shooting images
  table.insert( player.shootingImages, love.graphics.newImage("assets/nuclearManShooting1.png"))
  table.insert( player.shootingImages, love.graphics.newImage("assets/nuclearManShooting2.png"))
  table.insert( player.shootingImages, love.graphics.newImage("assets/nuclearManShooting3.png"))
  table.insert( player.shootingImages, love.graphics.newImage("assets/nuclearManShooting4.png"))
  enemy1.baseImage = love.graphics.newImage("assets/enemy1.png")
end

function love.update(dt)
  player.move(dt)
  player.animate(dt)
  player.shoot(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(190, 235, 190)
  love.graphics.draw(world.backgroundImage, world.x, 0, 0, 1, 1.2, 0, 0, 0, 0)
  player.drawPlayer(player.currentImage, player.x, player.y)
end
