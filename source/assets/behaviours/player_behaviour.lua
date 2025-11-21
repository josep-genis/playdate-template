local PlayerBehaviour = {}
PlayerBehaviour.__index = PlayerBehaviour

function PlayerBehaviour:new(target)
    local instance = setmetatable({}, self)
    instance.target = target
    return instance
end

function PlayerBehaviour:initialize()
    
end

function PlayerBehaviour:update()
    
end

function PlayerBehaviour:dispose()
    -- Cleanup logic if necessary
end

return PlayerBehaviour