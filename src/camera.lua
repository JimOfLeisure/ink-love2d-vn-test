camera = {
    x = 0,
    y = 0
}

-- TODO: adjust this based on configurable screen size
local x_offset = 375
local graphics = love.graphics
local push = graphics.push
local pop = graphics.pop
local translate = graphics.translate
local rotate = graphics.rotate

function camera:set()
    push()
    -- rotate(-1.5)
    translate(-self.x + x_offset, -self.y)
end

function camera:unset()
    pop()
end

return camera