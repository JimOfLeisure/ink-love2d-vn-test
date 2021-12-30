camera = {
    x = 0,
    y = 0
}

local graphics = love.graphics
local push = graphics.push
local pop = graphics.pop
local translate = graphics.translate
local rotate = graphics.rotate
local scale = graphics.scale
local x_offset = graphics.getWidth() / 2
local y_offset = graphics.getHeight() / 2

function camera:set(angle)
    push()
    translate(-self.x, -self.y)
    -- rotate(-(angle - (math.pi / 2)))
    -- pop()
    -- rotate(0)
    translate(x_offset,y_offset)
    -- scale(0.25,0.25)
    -- translate(50,50)
end

function camera:unset()
    pop()
end

return camera