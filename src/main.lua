require("camera")

local graphics = love.graphics

local METER_SIZE = 64
local GRAVITY = 9.81 * METER_SIZE
local PARACHUTE_DRAG = 2.0
local METER_ORIGIN = 375
local world
local ball = {}
local ground = require("ground")
local default_angle = math.pi / 2 - 0.2
local gravity_angle = default_angle
local parachute_deployed = true
local parachute_image
local parachute_angle = 0
local ball_image
local dragging = false
local drag_x = 0.0
local drag_y = 0.0
local instructions = true
local parachute_deploys = 0
-- local fastest_meter = 0
local fastest_100m = 99999
local fastest_1km = 99999
local history_100m = {}
local history_1km = {}
local current_meter = 0
local game_start = true
local ready_100m = false
local ready_1km = false
local font
local min_angle = 0.2
local max_angle = 2.0

local sky_shader = graphics.newShader([[
    extern vec2 u_screen_size;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        float dist = distance(screen_coords, vec2(u_screen_size.x, 0)) / max(u_screen_size.x, u_screen_size.y);
        dist = dist * 1.5;
        dist = 1.0 - clamp(dist, 0.0, 0.4);
        return vec4(dist, dist, dist, 1.0) * color;
    }
]])

local ball_shader = graphics.newShader([[
    extern vec2 u_texture_size;
    extern vec2 u_highlight_pos;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        float dist = distance(screen_coords, u_highlight_pos) / max(u_texture_size.x, u_texture_size.y);
        dist = dist * 0.8 - 0.2;
        dist = 1.0 - clamp(dist, 0.0, 0.8);
        vec4 pixel = Texel(texture, texture_coords);
        pixel = pixel * vec4(dist, dist, dist, 1.0);
        return pixel * color;
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
    parachute_image = graphics.newImage("Parachute-icon.png")
    ball_image = graphics.newImage("SoccerBall.png")
    font = graphics.newFont(20)
end

function love.update(dt)
    world:update(dt)
    ground:update(ball.body:getX())
    if dragging then
        local x = love.mouse.getX()
        local y = love.mouse.getY()

        gravity_angle = gravity_angle + (drag_y - y) * 0.01
        if gravity_angle < min_angle then
            gravity_angle = min_angle
        else
            if gravity_angle > max_angle then
                gravity_angle = max_angle
            end
        end

        drag_x = x
        drag_y = y
    end
    if ball.body:getY() > 750 then
        ball.body:setY(30)
        ball.body:setX(ball.body:getX() + 100)
        ball.body:setLinearVelocity(0, 0)
        ball.body:setAngularVelocity(0)
        camera.y = 0;
        gravity_angle = default_angle
    end
    world:setGravity(gravity_x(), gravity_y())
    local ball_x = ball.body:getX()
    camera.x = ball_x
    local ball_y = ball.body:getY()
    camera.y = ball_y
    if not parachute_deployed and ball_y <  200 then
        parachute_deployed = true
        parachute_deploys = parachute_deploys + 1
        ball.body:setAngularDamping(0.9)
    end
    local timer = love.timer.getTime()
    if parachute_deployed and ball_y > 400 then
        parachute_deployed = false
        ball.body:setAngularDamping(0)
        if game_start then
            game_start = false
            history_100m[0] = timer
            history_1km[0] = timer
        end
    end
    if parachute_deployed then
        local sx, sy = ball.body:getLinearVelocity()
        ball.body:applyForce(-sx * PARACHUTE_DRAG, -sy * PARACHUTE_DRAG)
        -- 1.37 is a quarter turn because 0 is to the right; 0.8 is because parachute image is diagonal
        parachute_angle = math.atan(sy / sx) -1.37 - 0.8
        if sx < 0 then
            parachute_angle = parachute_angle + math.pi
        end
    end
    if math.floor((ball_x - METER_ORIGIN) / METER_SIZE) ~= current_meter then
        if ready_100m or current_meter > 100 then
            ready_100m = true
            local dtime = timer - history_100m[current_meter % 100]
            if dtime < fastest_100m then
                fastest_100m = dtime
            end
            if ready_1km or current_meter > 1000 then
                ready_1km = true
                local dtime = timer - history_1km[current_meter % 1000]
                if dtime < fastest_1km then
                    fastest_1km = dtime
                end
            end
    
        end
        history_100m[current_meter % 100] = timer
        history_1km[current_meter % 1000] = timer
        current_meter = current_meter + 1
    end
end

function love.draw()
    graphics.setShader(sky_shader)
    sky_shader:send("u_screen_size", { graphics.getWidth(), graphics.getHeight()})

    graphics.setColor(0.529, 0.808, 0.922)
    graphics.rectangle("fill", 0, 0, graphics.getWidth(), graphics.getHeight())
    graphics.setShader()

    camera:set(gravity_angle)
    if parachute_deployed then
        graphics.setColor(1, 1, 1)
        graphics.draw(parachute_image, ball.body:getX(), ball.body:getY(), parachute_angle, 0.8, nil, 20, 125)
    end

    graphics.setShader(ball_shader)
    ball_shader:send("u_texture_size", { ball_image:getWidth(), ball_image:getHeight()})
    ball_shader:send("u_highlight_pos", { graphics.getWidth() / 2 - 60 , graphics.getHeight() / 2 - 50 })

    graphics.setColor(1, 1, 1)
    graphics.draw(ball_image,ball.body:getX(), ball.body:getY(), ball.body:getAngle(), 0.55, nil, 50, 50 )

    graphics.setShader()

    ground:draw()
    camera:unset()
    graphics.setFont(font)

    if instructions then
        graphics.setColor(0.8, 0.1, 0.1)
        graphics.print("Drag up/down to change angle", 100, 100)
    end
    graphics.setColor(0.2, 0.2, 0.2)
    graphics.print(tostring(math.floor(-math.deg(gravity_angle - (math.pi / 2))* 100) /  100) .. "°", 580, 25)
    graphics.print("Parachutes  : " .. tostring(parachute_deploys), 580, 50)
    graphics.print("Distance (m): " .. tostring( math.floor((ball.body:getX() - METER_ORIGIN) / METER_SIZE)), 580, 75)
    if ready_100m then
        graphics.print("Fastest 100m: " .. tostring( math.floor(fastest_100m * 100) / 100), 580, 100)
    end
    if ready_1km then
        graphics.print("Fastest 1km : " .. tostring( math.floor(fastest_1km * 100) / 100), 580, 125)
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        dragging = true
        instructions = false
        drag_x = x
        drag_y = y
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        dragging = false
    end
end
