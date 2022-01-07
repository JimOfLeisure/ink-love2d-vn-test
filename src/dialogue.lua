local Dialogue = {}

local narrator = require('narrator.narrator')
local book = require('stories.dialogue')
local story = narrator.initStory(book)

-- For optimization
local graphics = love.graphics

local paragraphs = {}
local paragraph_number

local function load_paragraphs(in_paragraphs)
    paragraphs = in_paragraphs
    paragraph_number = 1
end

function Dialogue:load()
    story:begin()
    if story:canContinue() then
        load_paragraphs(story:continue())
    end
    print(paragraphs[paragraph_number].text)
end

--[[
function Dialogue:update(dt)
end
]]

function Dialogue:draw()
end

return Dialogue
