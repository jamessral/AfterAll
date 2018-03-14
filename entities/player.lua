-- Player
local Player = { __type = 'Player' }
Player.__index = Player

-- Get constructor function by name
setmetatable(Player, {
  __call = function(cls, ...)
    return cls.new(...)
  end
})

function Player:new(x, y)
  local player = {}

  player.x = x or 300
  player.xDirection = 1
  player.y = y or 300
  player.speed = 200
  player.SHOOT_TIME = 1
  player.shootCooldown = 0
  player.bullets = {}
  player.isMoving = false
  player.isShooting = false
  player.currentWalkingIndex = 1
  player.currentShootingIndex = 1
  player.walkingImages = {}
  player.shootingImages = {}

  return setmetatable(player, Player)
end

function Player:load()
  self.baseImage = love.graphics.newImage("assets/nuclearMan1.png")
  -- self walking images
  table.insert( self.walkingImages, self.baseImage)
  table.insert( self.walkingImages, love.graphics.newImage("assets/nuclearMan2.png"))
  table.insert( self.walkingImages, love.graphics.newImage("assets/nuclearMan3.png"))
  table.insert( self.walkingImages, love.graphics.newImage("assets/nuclearMan4.png"))
  table.insert( self.walkingImages, love.graphics.newImage("assets/nuclearMan5.png"))
  table.insert( self.walkingImages, love.graphics.newImage("assets/nuclearMan6.png"))

  -- self shooting images
  table.insert( self.shootingImages, love.graphics.newImage("assets/nuclearManShooting1.png"))
  table.insert( self.shootingImages, love.graphics.newImage("assets/nuclearManShooting2.png"))
  table.insert( self.shootingImages, love.graphics.newImage("assets/nuclearManShooting3.png"))
  table.insert( self.shootingImages, love.graphics.newImage("assets/nuclearManShooting4.png"))
end

function Player:draw()
  love.graphics.draw(
  self.currentImage,
  self.x,
  self.y,
  0,
  SCALE_FACTOR * self.xDirection,
  SCALE_FACTOR,
  0, 0, 0, 0)
end

function Player:animate(dt)
  if self.isMoving then
    self.currentImage = self.walkingImages[self.currentWalkingIndex]
    if dt >= (1/60) then
      if self.currentWalkingIndex < 4 then
        self.currentWalkingIndex = self.currentWalkingIndex + 1
      else
        self.currentWalkingIndex = 1
      end
    end
  else
    self.currentImage = self.baseImage
  end

  if self.isShooting then
    self.currentImage = self.shootingImages[self.currentShootingIndex]
    if dt >= (1/60) then
      if self.currentShootingIndex < 4 then
        self.currentShootingIndex = self.currentShootingIndex + 1
      else
        self.currentShootingIndex = 1
      end
    end
  end
end

function Player:shoot(dt)
  local xButton = love.keyboard.isDown("x")
  if xButton and self.shootCooldown == 0 then
    self.isShooting = true
    self.shootCooldown = self.SHOOT_TIME
  else
    self.isShooting = false
    if self.shootCooldown < self.SHOOT_TIME then
      self.shootCooldown = self.shootCooldown + dt
    end
    if self.shootCooldown >= self.SHOOT_TIME then
      self.shootCooldown = 0
    end
  end
end

function Player:move(dt)
  local up = false
  local down = false
  local left = false
  local right = false

  local speed = self.speed

  self.isMoving = false

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

  -- make sure self doesn't go off screen
  local isScrolling = false

  if (self.x >= world.WIDTH - world.WIDTH * 0.2) and right then
    if world.x <= 0 and world.x >= -world.WIDTH + 10 then
      world:scroll(speed, dt)
      right = false
      isScrolling = true
    else
      right = false
      isScrolling = false
    end
  end

  if (self.x <= 20) and left then
    if world.x >= -world.WIDTH and world.x <= -10 then
      world:scroll(-speed, dt)
      left = false
      isScrolling = true
    else
      left = false
      isScrolling = false
    end
  end

  if (self.y <= 250) and up then
    up = false
  end

  if (self.y >= world.HEIGHT + 6) and down then
    down = false
  end

  if up then self.y = self.y - speed * dt end
  if down then self.y = self.y + speed * dt end
  if left then
    self.x = self.x - speed * dt
    self.xDirection = -1
  end
  if right then
    self.x = self.x + speed * dt
    self.xDirection = 1
  end

  if up or down or left or right or isScrolling then
    self.isMoving = true
  else
    self.isMoving = false
  end
end

return Player
