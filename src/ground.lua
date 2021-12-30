local Ground = {}

local graphics = love.graphics

local body
local shape
local fixture

-- add to noise parameter to randomize the noise results between games
local origin = (love.math.random() -0.5) * 3000
local NOISE_SCALE = 1
local BUMP_SCALE = 10
local ground_sections = {}

local function new_ground_section(world, x, y)
    local section = {}
    section.body = love.physics.newBody(world, x, t, "static")

    local coords = {}
    for i=x-50,x+50,20 do
        table.insert(coords, i)
        table.insert(coords, y-25 - (love.math.noise(origin + i) * NOISE_SCALE) * BUMP_SCALE)
    end
    for _, e in ipairs({ x+50, y+25, x-50, y+25 }) do
        table.insert(coords, e)
    end
    
    section.shape = love.physics.newPolygonShape(coords)
    section.fixture = love.physics.newFixture(section.body, section.shape)

    return section
end

function Ground:load(world)
    table.insert(ground_sections, new_ground_section(world, 400, 500))
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
    for _, section in ipairs(ground_sections) do
        graphics.polygon("fill", section.body:getWorldPoints(section.shape:getPoints()))
    end
end

return Ground
