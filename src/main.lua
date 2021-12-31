require("camera")

local graphics = love.graphics

local METER_SIZE = 64
local GRAVITY = 9.81 * METER_SIZE
local PARACHUTE_DRAG = 2.0
local world
local ball = {}
local ground = require("ground")
local gravity_angle = math.pi / 2 - 0.2
local parachute_deployed = true
local parachute_image
local parachute_angle = 0

function love.load()
    love.physics.setMeter(METER_SIZE)
    world = love.physics.newWorld(math.cos(gravity_angle) * GRAVITY, math.sin(gravity_angle) * GRAVITY, true)
    ball.body = love.physics.newBody(world, 375, 30, "dynamic")
    ball.shape = love.physics.newCircleShape(25)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
    ball.fixture:setRestitution(0.6)
    ground:load(world)
    parachute_image = graphics.newImage("parachute-icon.png")
end

function love.update(dt)
    world:update(dt)
    ground:update(ball.body:getX())
    if ball.body:getY() > 750 then
        ball.body:setY(30)
        ball.body:setX(375)
        ball.body:setLinearVelocity(0, 0)
        ball.body:setAngularVelocity(0)
        camera.y = 0;
    end
    camera.x = ball.body:getX()
    local ball_y = ball.body:getY()
    camera.y = ball_y
    if not parachute_deployed and ball_y <  200 then
        parachute_deployed = true
        ball.body:setAngularVelocity(0)
    end
    if parachute_deployed and ball_y > 400 then
        parachute_deployed = false
    end
    if parachute_deployed then
        local sx, sy = ball.body:getLinearVelocity()
        ball.body:applyForce(-sx * PARACHUTE_DRAG, -sy * PARACHUTE_DRAG)
        parachute_angle = math.atan(sy / sx) -1.37 - 0.8
        print(parachute_angle)
    end
end

function love.draw()
    camera:set(gravity_angle)
    if parachute_deployed then
        graphics.setColor(1, 0.5, 0.5)
        -- graphics.print("Parachute deployed", 100, 100, 0, 4)
        graphics.draw(parachute_image, ball.body:getX() - 60, ball.body:getY() - 100, parachute_angle, 0.8)
    end
    graphics.setColor(0.75, 0, 0.75)
    graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
    ground:draw()
    camera:unset()
end
