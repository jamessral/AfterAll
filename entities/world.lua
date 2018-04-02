-- World
local World = { __type = "World"}
World.__index = World

function World.new(width, height)
  local world = {}

  world.WIDTH = width or 640
  world.HEIGHT = height or 320
  world.x = 0
  world.y = 0

  return setmetatable(world, World)
end

function World:load()
  self.backgroundImage = love.graphics.newImage("assets/background.png")
end

function World:scroll(speed, dt)
  self.x = self.x - speed * dt
end

return World
