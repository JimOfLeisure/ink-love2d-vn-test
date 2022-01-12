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
local x_offset = graphics.getWidth() / 2 - 100
local y_offset = graphics.getHeight() / 2

function camera:set(angle)
    push()
    translate(x_offset,y_offset)
    rotate(-(angle - (math.pi / 2)))
    translate(-self.x, -self.y)
end

function camera:unset()
    pop()
end

return camera