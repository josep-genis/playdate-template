-- TitleScene class definition
TitleScene = {}
TitleScene.__index = TitleScene
local graphics <const> = playdate.graphics
local enterButtonListenerId = "OnEnterGameplayButtonPressed"

function TitleScene:new()
    local instance = setmetatable({}, self)
    return instance
end

function TitleScene:enter()
    Input.OnAButtonDown:subscribe(enterButtonListenerId, function()
        -- Switch to the game scene when the A button is pressed
        SceneSystem:switchScene("game")
    end)
end

function TitleScene:exit()
    Input.OnAButtonDown:unsubscribe(enterButtonListenerId)
    graphics.clear(graphics.kColorWhite)
end

function TitleScene:update()
    -- Update logic for the title scene, such as handling input or animations
end

function TitleScene:draw()
    -- Draw the title scene, including any text or graphics
    graphics.clear(graphics.kColorWhite)
    graphics.drawText("Welcome to the Game!", 100, 100)
end

-- Return the TitleScene class
return TitleScene