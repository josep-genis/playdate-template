-------------------------------------------------
-- EVENT IMPLEMENTATION
-------------------------------------------------

Event = {}
Event.__index = Event

function Event:new()
    local e = setmetatable({ listeners = {} }, self)
    return e
end

-- Subscribe a listener function. Returns an unsubscribe function.
function Event:subscribe(id, fn)
    if type(fn) ~= "function" then
        error("Event:subscribe expects a function")
    end
    self.listeners[id] = fn
end

-- Unsubscribe a listener by function reference
function Event:unsubscribe(id)
    self.listeners[id] = nil
end

-- Emit the event to all listeners. Errors in listeners are caught and logged.
function Event:raise(...)
    for id, listener in pairs(self.listeners) do
        local success, err = pcall(listener, ...)
        if not success then
            print("Error in event listener '" .. tostring(id) .. "': " .. tostring(err))
        end
    end
end

-- Remove all listeners
function Event:clear()
    self.listeners = {}
end

return Event