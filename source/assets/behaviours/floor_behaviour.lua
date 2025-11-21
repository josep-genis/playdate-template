local FloorBehaviour = {}
FloorBehaviour.__index = FloorBehaviour


function FloorBehaviour:new(target, id)
    local instance = setmetatable({}, self)
    instance.target = target
    instance.id = id
    return instance
end

function FloorBehaviour:initialize()
    
end

function FloorBehaviour:update()
    
end

function FloorBehaviour:dispose()
    -- Cleanup logic if necessary
end

return FloorBehaviour