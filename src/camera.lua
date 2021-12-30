camera = {
    x = 0,
    y = 0
}

-- TODO: adjust this based on configurable screen size
local x_offset = 375
local y_offset = 375
local graphics = love.graphics
local push = graphics.push
local pop = graphics.pop
local translate = graphics.translate
local rotate = graphics.rotate
local scale = graphics.scale

function camera:set(angle)
    push()
    translate(-self.x, -self.y - y_offset)
    rotate(angle)
    -- translate(-self.x + x_offset, -self.y)
    translate(-self.x, -self.y)
end

function camera:unset()
    pop()
end

return camera