local Character = {}

local Game_component = require("generics.game-component")
local Vec2 = require("generics.vec2")

-- For optimization
local love = love

function has_value(table, value)
    if not table then
        return false
    end
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function Character:new(data, image_path, pos, tag, scale)
    obj = Game_component:new()
    obj.data = data
    obj.image = love.graphics.newImage(image_path)
    obj.pos = pos
    obj.tag = tag
    obj.scale = scale or 1
    
    function obj:draw()
        local focus_scale = (has_value(self.data.vn.paragraph.tags, self.tag) and 1.25) or 1
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, self.scale * focus_scale, nil)
    end

    return obj
end


return Character
