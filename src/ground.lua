local Ground = {}

local graphics = love.graphics

-- add to noise parameter to randomize the noise results between games
local origin = (love.math.random() -0.5) * 3000
local NOISE_SCALE = 1
local BUMP_SCALE = 20
local ground_sections = {}
local world

local function new_ground_section(x, y)
    local section = {}
    section.body = love.physics.newBody(world, x, y, "static")

    local coords = {}
    for i=-50,50,20 do
        table.insert(coords, i)
        table.insert(coords, -25 - (love.math.noise(origin + x + i) * NOISE_SCALE) * BUMP_SCALE)
    end
    for _, e in ipairs({ 50, 25, -50, 25 }) do
        table.insert(coords, e)
    end
    
    section.shape = love.physics.newPolygonShape(coords)
    section.fixture = love.physics.newFixture(section.body, section.shape)

    return section
end

function Ground:load(physics_world)
    world = physics_world
    for i=0,800,100 do
        table.insert(ground_sections, new_ground_section(i, 500))
    end
end

function Ground:update(float_x)
    local x = math.floor(float_x)
    for i, section in ipairs(ground_sections) do
        if x - section.body:getX() > 400 then
            -- hopefully releasing the memory this way; release() left the physics objects in place
            section.fixture:destroy()
            -- section.shape:destroy()
            section.body:destroy()
            ground_sections[i] = new_ground_section((math.floor(x / 100) * 100) + 400, 500)
        end
    end
end

function Ground:draw()
    graphics.setColor(0.28, 0.63, 0.05)
    for _, section in ipairs(ground_sections) do
        graphics.polygon("fill", section.body:getWorldPoints(section.shape:getPoints()))
    end
end

return Ground
