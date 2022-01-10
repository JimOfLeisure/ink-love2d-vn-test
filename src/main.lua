require("camera")
local dialogue = require("dialogue")
local character = require("character")

local graphics = love.graphics

local METER_SIZE = 64
local GRAVITY = 9.81 * METER_SIZE
local PARACHUTE_DRAG = 2.0
local METER_ORIGIN = 375
local world
local ball = {}
local ground = require("ground")
local gravity_angle = math.pi / 2 - 0.2
local parachute_deployed = true
local parachute_image
local parachute_angle = 0
local ball_image
local one
local two

local sky_shader = graphics.newShader([[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        vec4 pixel = Texel(texture, texture_coords);
        //return vec4(pixel.r, pixel.g, pixel.b, pixel.a < 0.1? pixel.a : 0.5);
        // return vec4(color.r, color.g, color.b, color.a < 0.1? color.a : 0.5);
        return vec4(color.r, color.g, color.b, color.a);
        //return pixel;
        return color;
    }
]])
function gravity_x()
    return math.cos(gravity_angle) * GRAVITY
end

function gravity_y()
    return math.sin(gravity_angle) * GRAVITY
end

function love.load()
    love.physics.setMeter(METER_SIZE)
    world = love.physics.newWorld(gravity_x(), gravity_y(), true)
    ball.body = love.physics.newBody(world, METER_ORIGIN, 30, "dynamic")
    ball.shape = love.physics.newCircleShape(25)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
    ball.fixture:setRestitution(0.6)
    ground:load(world)
    parachute_image = graphics.newImage("assets/Parachute-icon.png")
    ball_image = graphics.newImage("assets/SoccerBall.png")
    dialogue:load()
    one = character:new_character("assets/FreeSpriteChan.png", 400, 0)
    two = character:new_character("assets/FreeSpriteKun2.png", 0, 0)
end

function love.update(dt)
    world:update(dt)
    ground:update(ball.body:getX())
    if ball.body:getY() > 750 then
        ball.body:setY(30)
        ball.body:setX(ball.body:getX() + 100)
        ball.body:setLinearVelocity(0, 0)
        ball.body:setAngularVelocity(0)
        camera.y = 0;
    end
    local ball_x = ball.body:getX()
    camera.x = ball_x
    local ball_y = ball.body:getY()
    camera.y = ball_y
    if not parachute_deployed and ball_y <  200 then
        parachute_deployed = true
        ball.body:setAngularDamping(0.9)
    end
    local timer = love.timer.getTime()
    if parachute_deployed and ball_y > 400 then
        parachute_deployed = false
        ball.body:setAngularDamping(0)
    end
    if parachute_deployed then
        local sx, sy = ball.body:getLinearVelocity()
        ball.body:applyForce(-sx * PARACHUTE_DRAG, -sy * PARACHUTE_DRAG)
        -- 1.37 is a quarter turn because 0 is to the right; 0.8 is because parachute image is diagonal
        parachute_angle = math.atan(sy / sx) -1.37 - 0.8
    end
end

function love.draw()
    graphics.setShader(sky_shader)
    -- graphics.setBackgroundColor(0.529, 0.808, 0.922)
    graphics.setColor(0.529, 0.808, 0.922)
    graphics.rectangle("fill", 0, 0, graphics.getWidth(), graphics.getHeight())
    graphics.setShader()
    graphics.push()
    graphics.translate(0, 80 - (ball.body:getY() / 5))
    one:draw()
    two:draw()
    graphics.pop()
    camera:set(gravity_angle)
    if parachute_deployed then
        graphics.setColor(1, 1, 1)
        graphics.draw(parachute_image, ball.body:getX(), ball.body:getY(), parachute_angle, 0.8, nil, 20, 125)
    end
    graphics.setColor(1, 1, 1)
    graphics.draw(ball_image,ball.body:getX(), ball.body:getY(), ball.body:getAngle(), 0.55, nil, 50, 50 )
    ground:draw()
    camera:unset()
    dialogue.draw()
end

function love.keypressed(key)
    dialogue:keypressed(key)
end
