-- GLOBALS
SCALE_FACTOR = 2

function drawImage(image, x, y)
  love.graphics.draw(image, x, y, 0, SCALE_FACTOR, SCALE_FACTOR, 0, 0, 0, 0)
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

    if love.keyboard.isDown("up") then up = true end
    if love.keyboard.isDown("down") then down = true end
    if love.keyboard.isDown("left") then left = true end
    if love.keyboard.isDown("right") then right = true end

    if up and down then up, down = false end
    if left and right then left, right = false end

    if up then player.y = player.y - player.speed * dt end
    if down then player.y = player.y + player.speed * dt end
    if left then player.x = player.x - player.speed * dt end
    if right then player.x = player.x + player.speed * dt end
  end

-- Enemy1
enemy1 = {}

-- Enemy2
enemy2 = {}

function love.load()
  player.baseImage = love.graphics.newImage("assets/nuclearMan1.png")
end

function love.update(dt)
  player.move(dt)
end

function love.draw()
  drawImage(player.baseImage, player.x, player.y)
end
