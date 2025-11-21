
Scene = {}
Scene.__index = Scene

function Scene:new()
    local s = setmetatable({}, self)
    s.entities = {}
    return s
end

function Scene:addEntity(entity)
    table.insert(self.entities, entity)
end

function Scene:enter()
    for _, entity in ipairs(self.entities) do
        if entity.initialize then
            entity:initialize()
        end
    end
end

function Scene:update()
    for _, entity in ipairs(self.entities) do
        if entity.update then
            entity:update()
        end
    end
end

function Scene:draw()
    for _, entity in ipairs(self.entities) do
        if entity.draw then
            entity:draw()
        end
    end
end

function Scene:dispose()
    for _, entity in ipairs(self.entities) do
        if entity.dispose then
            entity:dispose()
        end
    end
end

return Scene