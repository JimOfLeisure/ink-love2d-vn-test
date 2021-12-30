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
    rotate(-(angle - (math.pi / 2)))
    translate(-self.x, -self.y)
    translate(x_offset,y_offset)
end

function camera:unset()
end

return camera