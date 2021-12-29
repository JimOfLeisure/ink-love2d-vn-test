local Ground = {}

local graphics = love.graphics

local body
local shape
local fixture

function Ground:load(world)
    self.body = love.physics.newBody(world, 400, 500)
    self.shape = love.physics.newRectangleShape(700, 50)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    -- self.body:setAngle(0.2)
end

function Ground:normal_draw()
    graphics.setColor(0.28, 0.63, 0.05)
    graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

function Ground:init_draw()
    self.body:setAngularVelocity(0.2)
    print("hi")
    self.draw = self.normal_draw
    self:normal_draw()
end

Ground.draw = Ground.init_draw

return Ground
