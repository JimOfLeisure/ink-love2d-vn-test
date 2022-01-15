local Game_component = {}

function Game_component:new()
    local gc = {}

    -- callback for love.load()
    function gc:load()
    end

    -- callback for love.update()
    function gc:update(dt)
    end

    -- callback for love.draw()
    function gc:draw()
    end

    return gc
end

return Game_component
