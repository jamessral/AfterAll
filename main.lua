-- GLOBALS
SCALE_FACTOR = 2
local World  = require("entities.world")
local Player = require("entities.player")

local anim8  = require("anim8")

love.graphics.setDefaultFilter("nearest", "nearest")

function drawImage(image, x, y)
    love.graphics.draw(image, x, y, 0, SCALE_FACTOR, SCALE_FACTOR, 0, 0, 0, 0)
end

-- World
local world = World.new()

-- Enemies
enemy1 = {}

-- Player
local player = Player.new()

-- Enemy1
enemy1 = {}

-- Enemy2
enemy2 = {}

function love.load()
    world:load()
    enemy1.baseImage = love.graphics.newImage("assets/enemy1.png")
    player:load()
end

function love.update(dt)
    player:move(world, dt)
    player:animate(dt)
    player:shoot(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(190, 235, 190)
    love.graphics.draw(world.backgroundImage, world.x, 0, 0, 1, 1.2, 0, 0, 0, 0)
    player:draw()

    -- use this for printf debugging!
    love.graphics.print(player.shootCooldown, 50, 50)
end
