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
local y_offset = graphics.getHeight() / 2 - 100

function camera:set(angle)
    push()
    rotate(-(angle - (math.pi / 2)))
    translate(-self.x, -self.y)
    translate(x_offset,y_offset)
end

function camera:unset()
    pop()
end

return camera