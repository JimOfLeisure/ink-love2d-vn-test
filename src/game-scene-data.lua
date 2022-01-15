-- Game scene data store

--optimization
local love = love

-- Gravity & camera angle at game start and after ball respawn
local default_angle = math.pi / 2 - 0.2
local default_y = 30
local meter_size = 64
local Vec2 = require("generics.vec2")

Data = {
    -- ball and camera center
    pos = Vec2:new(0, default_y),
    -- gravity & camera angle
    angle = default_angle,
    parachute_deployed = true,
    parachute_drag = 2.0,
    instructions = true,
    min_angle = 0.2,
    max_angle = 2.0,
    stats = {
        parachute_deploys = 0,
    },
    conf = {
        meter_size = meter_size,
        gravity = 9.81 * meter_size
    },
    world = love.physics.newWorld(),
}

function Data.conf:x_offset()
    return love.graphics.getWidth() / 2 - 100
end
function Data.conf:y_offset()
    return love.graphics.getHeight() / 2
end

function Data:reset_angle()
    self.angle = default_angle
end

function Data:set_gravity()
    self.world:setGravity(math.cos(self.angle) * self.conf.gravity, math.sin(self.angle) * self.conf.gravity)
end

return Data