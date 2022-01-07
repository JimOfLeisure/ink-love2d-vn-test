local Character = {}

-- For optimization
local graphics = love.graphics

function Character:new_character(image_path, x, y, scale)
    character = {}
    character.image = graphics.newImage(image_path)
    character.x = x
    character.y = y
    character.scale = scale    

    function character:load()
    end
    
    function character:draw()
        graphics.setColor(1, 1, 1, 1)
        graphics.draw(self.image, self.x, self.y, 0, self.scale, nil)
    end

    return character
end


return Character
