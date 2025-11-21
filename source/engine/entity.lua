-- Entity class definition
Entity = {}
Entity.__index = Entity

local graphics <const> = playdate.graphics
local isActive = true
local name = "Entity"

function Entity:new(textureSource, positionX, positionY, name)
    local instance = setmetatable({}, Entity)
    instance.name = name or "Entity"
    -- create image and validate
    local img = graphics.image.new(textureSource)
    if not img then
        error("Entity:new - failed to load image: " .. tostring(textureSource))
    end
    instance.image = img

    -- create sprite and validate
    instance.sprite = graphics.sprite.new(instance.image)
    if not instance.sprite then
        error("Entity:new - failed to create sprite for: " .. tostring(textureSource))
    end

    local width, height = instance.image:getSize()
    instance.sprite:setCollideRect(0, 0, width, height)
    instance.sprite:add()
    instance.sprite:moveTo(positionX or 0, positionY or 0)

    instance.behaviours = {}
    instance.isActive = true
    return instance
end

function Entity:initialize()
    for _, behaviour in ipairs(self.behaviours) do
        if behaviour.initialize then behaviour:initialize(self) end
    end
end

function Entity:update()
    for _, behaviour in ipairs(self.behaviours) do
        if behaviour.update then behaviour:update(self) end
    end
end

function Entity:draw()
    if not self.isActive then return end
    if not self.sprite then return end

    local ok, err = pcall(function() self.sprite:update() end)
    if not ok then
        print("Entity:draw - sprite draw error: " .. tostring(err) .. " for entity: " .. tostring(self.name))
    end
end

function Entity:setActive(active)
    isActive = active
end

function Entity:dispose()
    for _, behaviour in ipairs(self.behaviours) do
        if behaviour.dispose then behaviour:dispose(self) end
    end
    if self.sprite then
        -- remove from sprite system to avoid further draws/collisions
        self.sprite:remove()
        self.sprite = nil
    end
    self.image = nil
end

function Entity:addBehaviour(behaviour)
    table.insert(self.behaviours, behaviour)
    if behaviour.initialize then behaviour:initialize(self) end
end

return Entity