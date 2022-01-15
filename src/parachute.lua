local Parachute = {}

local Game_component = require("generics.game-component")
local Vec2 = require("generics.vec2")

-- optimizations
local love = love

-- requires a love.physics.world reference from shared data table
-- expects target to have a .body which is a love.physics.Body, and have a custom :reset() method
function Parachute:new(data, target)
    local obj = Game_component:new()
    obj.data = data
    obj.target = target
    obj.image = love.graphics.newImage("Parachute-icon.png")
    function obj:load()
    end

    function obj:update(dt)
        if data.pos.y > 750 then
            self.target:respawn()
            data:reset_angle()
            data:set_gravity()
        end

        if not data.parachute_deployed and data.pos.y <  200 then
            data.parachute_deployed = true
            data.stats.parachute_deploys = data.stats.parachute_deploys + 1
            self.target.body:setAngularDamping(0.9)
        end
    
        if data.parachute_deployed and data.pos.y > 400 then
            data.parachute_deployed = false
            self.target.body:setAngularDamping(0)
            if data.game_start then
                data.game_start = false
            end
        end

        if data.parachute_deployed then
            local sx, sy = self.target.body:getLinearVelocity()
            self.target.body:applyForce(-sx * data.parachute_drag, -sy * data.parachute_drag)
            -- 1.37 is a quarter turn because 0 is to the right; 0.8 is because parachute image is diagonal
            data.parachute_angle = math.atan(sy / sx) -1.37 - 0.8
            if sx < 0 then
                data.parachute_angle = data.parachute_angle + math.pi
            end
        end
    end

    function obj:draw()
        if self.data.parachute_deployed then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(self.image, data.pos.x, data.pos.y, data.parachute_angle, 0.8, nil, 20, 125)
        end
    end

    return obj
end

return Parachute
