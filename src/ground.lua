local Ground = {}

-- optimization
local love = love

local Game_component = require("generics.game-component")
local Vec2 = require("generics.vec2")

-- add to noise parameter to randomize the noise results between games
local NOISE_ORIGIN = (love.math.random() -0.5) * 3000
local NOISE_SCALE = 0.005
local BUMP_SCALE = 30
local ground_sections = {}

function Ground:new(data, pos)
    local obj = Game_component:new()
    obj.data = data
    function obj:respawn(pos)
        self.pos = pos
        self.body = love.physics.newBody(self.data.world, self.pos.x, self.pos.y, "static")

        local coords = {}
        for i=-50,50,20 do
            table.insert(coords, i)
            table.insert(coords, -25 - (love.math.noise(NOISE_ORIGIN + ((self.pos.x + i) * NOISE_SCALE)) * BUMP_SCALE))
        end
        for _, e in ipairs({ 50, 450, -50, 450 }) do
            table.insert(coords, e)
        end
        
        obj.shape = love.physics.newPolygonShape(coords)
        obj.fixture = love.physics.newFixture(obj.body, obj.shape)
    end
    function obj:draw()
        love.graphics.setColor(0.28, 0.63, 0.05)
        love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    end
    obj:respawn(pos)

    function obj:update()
        local x = math.floor(self.data.pos.x)
        if x - self.pos.x > 500 then
            -- hopefully releasing the memory this way; release() left the physics objects in place
            self.fixture:destroy()
            -- self.shape:destroy()
            self.body:destroy()
            self:respawn(Vec2:new((math.floor(x / 100) * 100) + 700, 500))
        end
    end
    
    return obj
end


return Ground
