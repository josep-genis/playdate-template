local ElevatorBehaviour = {}
ElevatorBehaviour.__index = ElevatorBehaviour
local crankListenerId <const> = "ElevatorBehaviour_CrankListener"

local function angleDelta(a, b)
    -- signed shortest difference in degrees (-180, 180]
    local diff = ((a - b + 180) % 360) - 180
    return diff
end

function ElevatorBehaviour:new(target, floors)
    local instance = setmetatable({}, self)
    instance.target = target
    instance.crankFramesIdle = 0
    instance.crankIdleThreshold = 12 -- frames before we consider crank stopped (~0.4s @ 30fps)
    instance.isCranking = false
    instance.floors = floors
    instance.minFloorY = instance.floors[1].sprite.y
    instance.maxFloorY = instance.floors[#instance.floors].sprite.y

    -- new fields for crank-based velocity
    instance.startCrankAngle = nil
    instance.prevCrankAngle = nil
    instance.direction = 0       -- +1 or -1 while cranking, 0 = not decided yet
    instance.maxSpeed = 6 -- pixels per update at maximum displacement (tweakable)

    return instance
end

function ElevatorBehaviour:initialize()
    -- subscribe to crank events
    Input.OnCrankValueChange:subscribe(crankListenerId, function(angle)
        -- first crank event after idle: mark start and wait for first movement to pick direction
        if not self.isCranking then
            self.isCranking = true
            self.startCrankAngle = angle
            self.prevCrankAngle = angle
            self.direction = 0
            self.crankFramesIdle = 0
            return
        end

        -- reset idle counter each crank update
        self.crankFramesIdle = 0

        -- compute small delta since previous event to detect instantaneous direction
        local deltaFromPrev = angleDelta(angle, self.prevCrankAngle)

        -- if direction not yet chosen, pick it from the sign of the first meaningful delta
        if self.direction == 0 and math.abs(deltaFromPrev) > 0.5 then
            self.direction = (deltaFromPrev > 0) and 1 or -1
        end

        -- if user reverses direction (delta sign opposite current direction) treat that as a direction change:
        -- reset start angle so velocity builds from the new direction movement
        if self.direction ~= 0 and (deltaFromPrev * self.direction) < 0 and math.abs(deltaFromPrev) > 0.5 then
            self.direction = (deltaFromPrev > 0) and 1 or -1
            self.startCrankAngle = angle
            -- keep prevCrankAngle in sync
            self.prevCrankAngle = angle
            return
        end

        -- update prev angle for next event
        self.prevCrankAngle = angle

        -- compute total displacement from start angle, use magnitude for speed but keep sign from chosen direction
        local totalDisp = angleDelta(angle, self.startCrankAngle) -- signed
        local magnitude = math.min(math.abs(totalDisp) / 180, 1) -- 0..1
        local dir = (self.direction == 0) and 1 or self.direction
        local velocity = magnitude * self.maxSpeed * dir

        -- apply movement but clamp to floor bounds
        local curX, curY = self.target.sprite.x, self.target.sprite.y
        local newY = curY + velocity
        if newY < self.minFloorY then newY = self.minFloorY end
        if newY > self.maxFloorY then newY = self.maxFloorY end

        self.target.sprite:moveTo(curX, newY)
    end)
end

function ElevatorBehaviour:update()
    -- crank idle detection (frame-based)
    if self.isCranking then
        self.crankFramesIdle = (self.crankFramesIdle or 0) + 1
        if self.crankFramesIdle >= (self.crankIdleThreshold or 12) then
            -- crank considered stopped: snap to nearest floor
            self.isCranking = false
            self:startSnapToNearestFloor()
            self.startCrankAngle = nil
            self.prevCrankAngle = nil
            self.direction = 0
        end
    end
end

function ElevatorBehaviour:dispose()
    Input.OnCrankValueChange:unsubscribe(crankListenerId)
end

function ElevatorBehaviour:startSnapToNearestFloor()
    if not self.target or not self.target.sprite then return end
    local currentY = self.target.sprite.y
    local closestY = nil
    local closestDist = math.huge
    for _, floor in ipairs(self.floors) do
        local fy = floor.sprite.y
        local d = math.abs(fy - currentY)
        if d < closestDist then
            closestDist = d
            closestY = fy
        end
    end

    -- immediate snap to nearest floor (can be replaced with a tween)
    if closestY then
        self.target.sprite:moveTo(self.target.sprite.x, closestY)
    end
end

return ElevatorBehaviour