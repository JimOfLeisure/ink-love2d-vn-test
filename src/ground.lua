local Ground = {}

local graphics = love.graphics

local body
local shape
local fixture

-- add to noise parameter to randomize the noise results between games
local origin = (love.math.random() -0.5) * 3000
local NOISE_SCALE = 1
local BUMP_SCALE = 10

function Ground:load(world)
    self.body = love.physics.newBody(world, 400, 500, "static")
    -- self.shape = love.physics.newRectangleShape(700, 50)
    -- local coords = { -350, 50, 350, 60, 350, 100 }
    local coords = {}
    local i
    for i=-50,50,20 do
        table.insert(coords, i)
        table.insert(coords, -25 - (love.math.noise(origin + i) * NOISE_SCALE) * BUMP_SCALE)
    end
    for _, e in ipairs({ 50, 25, -50, 25 }) do
        table.insert(coords, e)
    end
    
    self.shape = love.physics.newPolygonShape(coords)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Ground:update(dt)

end

function Ground:draw()
    graphics.setColor(0.28, 0.63, 0.05)
    graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

return Ground
