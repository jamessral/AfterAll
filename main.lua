-- GLOBALS
local anim8 = require("anim8")
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
  world.x = world.x + speed * dt
end

-- Player
player = {}
player.x = 300
player.y = 300
player.speed = 300
player.shootCooldown = 5
player.bullets = {}
player.move = function (dt)
    local up = false
    local down = false
    local left = false
    local right = false

    local speed = player.speed

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

    if (player.x >= world.WIDTH - world.WIDTH * 0.2) and right then
      world.scroll(speed, dt)
      right = false
    end

    if (player.x <= 20) and left then
      world.scroll(-speed, dt)
      left = false
    end

    if (player.y <= 250) and up then
      up = false
    end

    if (player.y >= world.HEIGHT - 16 - 20) and down then
      down = false
    end

    if up then player.y = player.y - speed * dt end
    if down then player.y = player.y + speed * dt end
    if left then player.x = player.x - speed * dt end
    if right then player.x = player.x + speed * dt end
  end

-- Enemy1
enemy1 = {}

-- Enemy2
enemy2 = {}

function love.load()
  world.backgroundImage = love.graphics.newImage("assets/background.png")
  player.baseImage = love.graphics.newImage("assets/nuclearMan1.png")
end

function love.update(dt)
  player.move(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(190, 235, 190)
  drawImage(world.backgroundImage, world.x, 0, 0, 0.2, 0.2, 0, 0, 0, 0)
  drawImage(player.baseImage, player.x, player.y)
end
