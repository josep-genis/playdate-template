Event = import("engine/tween")

TweenSystem = {
    activeTweens = {}
}
TweenSystem.__index = TweenSystem

function TweenSystem:addTween(tween)
    table.insert(self.activeTweens, tween)
end

function TweenSystem:update()
    for i = #self.activeTweens, 1, -1 do
        local tween = self.activeTweens[i]
        tween:update()
        if tween.elapsed >= tween.duration then
            if tween.loop then
                tween:reset()
            else
                table.remove(self.activeTweens, i)
            end
        end
    end
end

return TweenSystem