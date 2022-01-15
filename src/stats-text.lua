local Screen_text = {}

local Game_component = require("generics.game-component")
local Vec2 = require("generics.vec2")

-- optimizations
local love = love

local stats = {
    fastest_100m = 99999,
    fastest_1km = 99999,
    history_100m = {},
    history_1km = {},
    current_meter = 0,
    ready_100m = false,
    ready_1km = false,
}

function Screen_text:new(data)
    local obj = Game_component:new()
    obj.data = data
    obj.font = love.graphics.newFont(20)

    function obj:load()
        local timer = love.timer.getTime()
        stats.history_100m[0] = timer
        stats.history_1km[0] = timer
    end

    function obj:update(dt)
        if math.floor((data.pos.x) / data.conf.meter_size) ~= stats.current_meter then
            local timer = love.timer.getTime()
            if stats.ready_100m or stats.current_meter > 100 then
                stats.ready_100m = true
                local dtime = timer - stats.history_100m[stats.current_meter % 100]
                if dtime < stats.fastest_100m then
                    stats.fastest_100m = dtime
                end
                if stats.ready_1km or stats.current_meter > 1000 then
                    stats.ready_1km = true
                    local dtime = timer - stats.history_1km[stats.current_meter % 1000]
                    if dtime < stats.fastest_1km then
                        stats.fastest_1km = dtime
                    end
                end
        
            end
            stats.history_100m[stats.current_meter % 100] = timer
            stats.history_1km[stats.current_meter % 1000] = timer
            stats.current_meter = stats.current_meter + 1
        end
    end

    function obj:draw()
        love.graphics.setFont(self.font)
        if data.instructions then
            love.graphics.setColor(0.8, 0.1, 0.1)
            love.graphics.print("Drag up/down to change angle", 100, 100)
        end
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.print(tostring(math.floor(-math.deg(data.angle - (math.pi / 2))* 100) /  100) .. "°", 580, 25)
        love.graphics.print("Parachutes  : " .. tostring(data.stats.parachute_deploys), 580, 50)
        love.graphics.print("Distance (m): " .. tostring( math.floor((data.pos.x) / data.conf.meter_size)), 580, 75)
        if stats.ready_100m then
            love.graphics.print("Fastest 100m: " .. tostring( math.floor(stats.fastest_100m * 100) / 100), 580, 100)
        end
        if stats.ready_1km then
            love.graphics.print("Fastest 1km : " .. tostring( math.floor(stats.fastest_1km * 100) / 100), 580, 125)
        end
    end

    return obj
end

return Screen_text
