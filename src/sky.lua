local Sky = {}

local Game_component = require("generics.game-component")

-- optimization
local love = love

local shader_string = [[
    extern vec2 u_screen_size;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        float dist = distance(screen_coords, vec2(u_screen_size.x, 0)) / max(u_screen_size.x, u_screen_size.y);
        dist = dist * 1.5;
        dist = 1.0 - clamp(dist, 0.0, 0.4);
        return vec4(dist, dist, dist, 1.0) * color;
    }
]]

function Sky:new()
    local bg = Game_component:new()
    bg.shader = love.graphics.newShader(shader_string)
    function bg:load()
    end

    function bg:update(dt)
    end

    function bg:draw()
        love.graphics.setShader(self.shader)
        self.shader:send("u_screen_size", { love.graphics.getWidth(), love.graphics.getHeight()})
        love.graphics.setColor(0.529, 0.808, 0.922)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setShader()
    end

    return bg
end

return Sky
