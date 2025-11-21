local Scene = import("engine/scene")
local Entity = import("engine/entity")
local ElevatorBehaviour = import("assets/behaviours/elevator_behaviour")
local graphics <const> = playdate.graphics
local crankListenerId <const> = "OnGameplayCrankActivity"
local elevatorIndicator = nil
local GameScene = {}
GameScene.__index = GameScene

setmetatable(GameScene, {
    __index = Scene,
})

function GameScene:new(floorAmount)
    local instance = setmetatable(Scene:new(), GameScene)
    instance.floorAmount = floorAmount or 5

    return instance
end

function GameScene:enter()

    self.floors = {}
    for i = 1, self.floorAmount, 1 do
        local x = 160 / 2
        local y = ((i - 1) * 48) + (48 / 2)
        local floor = Entity:new("assets/textures/floor_background", x, y, "Floor_" .. tostring(i))
        self:addEntity(floor)
        self.floors[i] = floor
    end

    local firstFloor = self.floors[1]
    elevatorIndicator = Entity:new("assets/textures/elevator_indicator", firstFloor.sprite.x, firstFloor.sprite.y, "ElevatorIndicator");
    elevatorIndicator:addBehaviour(ElevatorBehaviour:new(elevatorIndicator, self.floors));
    self:addEntity(elevatorIndicator)

end

function GameScene:exit()
end

function GameScene:update()
    
end

function GameScene:draw()
    graphics.clear()
    Scene.draw(self)
end

function GameScene:addTween(tween)
    table.insert(self.tweens, tween)
end

return GameScene