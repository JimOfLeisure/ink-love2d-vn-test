local Character = {}

local Game_component = require("generics.game-component")
local Vec2 = require("generics.vec2")

-- For optimization
local love = love

function Character:new(data, image_path, pos, scale)
    obj = Game_component:new()
    obj.image = love.graphics.newImage(image_path)
    obj.pos = pos
    obj.scale = scale or 1
    
    function obj:draw()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, self.scale, nil)
    end

    return obj
end


return Character
