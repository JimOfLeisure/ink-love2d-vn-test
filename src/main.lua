local graphics = love.graphics

local METER_SIZE = 64
local GRAVITY = 9.81 * METER_SIZE
local world
local ball = {}
local ground = require("ground")

function love.load()
    love.physics.setMeter(METER_SIZE)
    world = love.physics.newWorld(0, GRAVITY, true)
    ball.body = love.physics.newBody(world, 375, 30, "dynamic")
    ball.shape = love.physics.newCircleShape(25)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
    ball.fixture:setRestitution(0.6)
    ground:load(world)
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    graphics.setColor(0.75, 0, 0.75)
    graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
    ground:draw()
end
