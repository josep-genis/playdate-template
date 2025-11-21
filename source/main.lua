local playdate <const> = playdate
local graphics <const> = playdate.graphics

-- Import the engine and tween modules
local SceneSystem = import("engine/scene_system")
local TweenSystem = import("engine/tween_system")

-- Set up scenes
local titleScene = import("assets/scenes/title_scene")
local gameScene = import("assets/scenes/game_scene")

-- Register scenes
SceneSystem:addScene("title", titleScene:new())
SceneSystem:addScene("game", gameScene:new())

-- Start with the title scene
SceneSystem:switchScene("title")

-- Main game loop
function playdate.update()
    TweenSystem:update()
    SceneSystem:update()
    Input:update()
    
    SceneSystem:draw()
end