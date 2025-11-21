local Tween = {}
Tween.__index = Tween

function Tween:new(target, duration, properties, easingFunction, loop)
    local instance = setmetatable({}, self)
    instance.target = target
    instance.duration = duration
    instance.properties = properties
    instance.easingFunction = easingFunction or function(t) return t end
    instance.startTime = playdate.getCurrentTimeMilliseconds()
    instance.startValues = {}
    instance.isComplete = false
    instance.loop = loop or false

    for key, value in pairs(properties) do
        instance.startValues[key] = target[key]
    end

    return instance
end

function Tween:play()
    TweenSystem:addTween(self)
end

function Tween:update()
    if self.isComplete then return end

    local currentTime = playdate.getCurrentTimeMilliseconds()
    local elapsedTime = currentTime - self.startTime
    local t = elapsedTime / self.duration

    if t >= 1 then
        t = 1
        self.isComplete = true
    else
        t = self.easingFunction(t)
    end

    for key, value in pairs(self.properties) do
        self.target[key] = self.startValues[key] + (value - self.startValues[key]) * t
    end
end

function Tween:isFinished()
    return self.isComplete
end

function Tween:reset()
    self.isComplete = false
    self.startTime = playdate.getCurrentTimeMilliseconds()
    for key, value in pairs(self.properties) do
        self.target[key] = self.startValues[key]
    end
end

return Tween