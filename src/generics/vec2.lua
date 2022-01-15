local Vec2 = {}

function Vec2:new(x, y)
    local vec2 = {
        x = x or 0,
        y = y or 0,
    }
    return vec2
end

return Vec2
