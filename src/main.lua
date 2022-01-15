local Game_scene = require("game-scene")
local game_scene = Game_scene:new()

function love.load()
    game_scene:load()
end

function love.update(dt)
    game_scene:update(dt)
end

function love.draw()
    game_scene:draw()
end


function love.mousepressed(x, y, button)
    game_scene:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    game_scene:mousereleased(x, y, button)
end
