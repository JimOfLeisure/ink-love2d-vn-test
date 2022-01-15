local Ball = {}

local Game_component = require("generics.game-component")
local Vec2 = require("generics.vec2")

-- optimizations
local love = love

local shader_string = [[
    extern vec2 u_texture_size;
    extern vec2 u_highlight_pos;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        float dist = distance(screen_coords, u_highlight_pos) / max(u_texture_size.x, u_texture_size.y);
        dist = dist * 0.8 - 0.2;
        dist = 1.0 - clamp(dist, 0.0, 0.8);
        vec4 pixel = Texel(texture, texture_coords);
        pixel = pixel * vec4(dist, dist, dist, 1.0);
        return pixel * color;
    }
]]

-- requires a love.physics.world reference from shared data table
function Ball:new(data)
    local obj = Game_component:new()
    obj.pos = Vec2:new()
    obj.data = data

    function obj:respawn()
        self.body:setY(30)
        self.body:setX(self.body:getX() + 100)
        self.body:setLinearVelocity(0, 0)
        self.body:setAngularVelocity(0)
end;
    function obj:load()
        -- TODO: parameterize values
        self.body = love.physics.newBody(self.data.world, METER_ORIGIN or 30, 30, "dynamic")
        self.shape = love.physics.newCircleShape(25)
        self.fixture = love.physics.newFixture(self.body, self.shape, 1)
        self.fixture:setRestitution(0.6)
        self.image = love.graphics.newImage("SoccerBall.png")
        self.shader = love.graphics.newShader(shader_string)
    end

    function obj:update(dt)
        self.data.pos.x = self.body:getX()
        self.data.pos.y = self.body:getY()
    end

    function obj:draw()
        love.graphics.setShader(self.shader)
        self.shader:send("u_texture_size", { self.image:getWidth(), self.image:getHeight()})
        -- TODO: don't hard-code the highlight position here
        self.shader:send("u_highlight_pos", { love.graphics.getWidth() / 2 - 60 , love.graphics.getHeight() / 2 - 50 })
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.image,data.pos.x, data.pos.y, self.body:getAngle(), 0.55, nil, 50, 50 )
        love.graphics.setShader()
    end

    return obj
end

return Ball
