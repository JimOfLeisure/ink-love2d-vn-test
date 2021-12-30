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
    -- rotate(angle)
    -- translate((-x_offset) * math.cos(angle) + x_offset, x_offset * math.sin(angle))
    translate(x_offset,y_offset)
    -- translate(-self.x + x_offset, -self.y)
    -- translate(-self.x, -self.y)
end

function camera:unset()
    pop()
end

return camera