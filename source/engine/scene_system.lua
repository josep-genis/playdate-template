--------------------------------------------
---- Scene Management
--------------------------------------------

import "CoreLibs/timer"

Input = import("engine/input")
local playdate <const> = playdate

-- Engine definition
SceneSystem = {
    scenes = {},
    currentScene = Scene,
}

-- Register a scene
function SceneSystem:addScene(name, scene)
    self.scenes[name] = scene
end

-- Switch scenes
function SceneSystem:switchScene(name)
    if self.currentScene then self.currentScene:exit() end
    
    self.currentScene = self.scenes[name]
    if self.currentScene then
        if self.currentScene.enter then self.currentScene:enter() end
    end
end

-- Update engine each frame
function SceneSystem:update()
    if self.currentScene and self.currentScene.update then
        self.currentScene:update()
    end
    playdate.timer.updateTimers()
end

-- Draw engine
function SceneSystem:draw()
    if self.currentScene and self.currentScene.draw then
        self.currentScene:draw()
    end
end

return SceneSystem