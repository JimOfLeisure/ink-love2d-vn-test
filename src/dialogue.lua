local Dialogue = {}


local narrator = require('narrator.narrator')

-- For optimization
local love = love

local Game_component = require("generics.game-component")
local Vec2 = require("generics.vec2")

local paragraphs = {}
local paragraph_number
local font


local function load_paragraphs(in_paragraphs)
    paragraphs = in_paragraphs or {
        {
            text = "( END )",
            tags = {},
        },
    }
    -- setting to 0, should immediately advance before using
    paragraph_number = 0
end

function Dialogue:new(data, book_path)
    obj = Game_component:new()
    obj.data = data
    local book = require(book_path)
    obj.story = narrator.initStory(book)

    function obj:load()
        self.story:begin()
        if self.story:canContinue() then
            load_paragraphs(self.story:continue())
            self:next_paragraph()
        end
        font = love.graphics.newFont(28)
    end

    function obj:next_paragraph()
        if paragraph_number >= #paragraphs then
            load_paragraphs(nil)
        end
        paragraph_number = paragraph_number + 1
        self.data.vn.paragraph = paragraphs[paragraph_number]
    end
        
    function obj:draw()
        love.graphics.setFont(font)
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 10, 480, 780, 110, 15)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(paragraphs[paragraph_number].text, 10, 500, 790, "center")
    end

    function obj:keypressed(key)
        if love.keyboard.isDown("space") then
            self:next_paragraph()
        end
    end
    
    return obj
end


return Dialogue
