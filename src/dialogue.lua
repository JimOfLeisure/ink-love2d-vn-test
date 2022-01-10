local Dialogue = {}

local narrator = require('narrator.narrator')
local book = require('stories.main')
local story = narrator.initStory(book)

-- For optimization
local graphics = love.graphics

local paragraphs = {}
local paragraph_number
local font


local function load_paragraphs(in_paragraphs)
    paragraphs = in_paragraphs or {
        {
            text = "( END )",
            tag = "",
        },
    }
    paragraph_number = 1
end

function Dialogue:load()
    story:begin()
    if story:canContinue() then
        load_paragraphs(story:continue())
    end
    -- print(paragraphs[paragraph_number].text)
    font = graphics.newFont(28)
end

--[[
function Dialogue:update(dt)
end
]]

function Dialogue:next_paragraph()
    if paragraph_number >= #paragraphs then
        load_paragraphs(nil)
        return
    end
    paragraph_number = paragraph_number + 1
    -- print(paragraphs[paragraph_number].text)
end

function Dialogue:draw()
    graphics.setFont(font)
    graphics.setColor(0, 0, 0, 0.7)
    graphics.rectangle("fill", 10, 480, 780, 110)
    graphics.setColor(1, 1, 1, 1)
    graphics.printf(paragraphs[paragraph_number].text, 10, 500, 790, "center")
end

function Dialogue:keypressed(key)
    if love.keyboard.isDown("space") then
        self:next_paragraph()
    end

end

return Dialogue
