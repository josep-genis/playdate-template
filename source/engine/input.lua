Event = import("engine/event")

Input = {
    OnCrankValueChange = Event:new(),
    OnUpArrowUp = Event:new(),
    OnUpArrowDown = Event:new(),
    OnUpArrowHold = Event:new(),
    OnDownArrowUp = Event:new(),
    OnDownArrowDown = Event:new(),
    OnDownArrowHold = Event:new(),
    OnLeftArrowUp = Event:new(),
    OnLeftArrowDown = Event:new(),
    OnLeftArrowHold = Event:new(),
    OnRightArrowUp = Event:new(),
    OnRightArrowDown = Event:new(),
    OnRightArrowHold = Event:new(),
    OnAButtonUp = Event:new(),
    OnAButtonDown = Event:new(),
    OnAButtonHold = Event:new(),
    OnBButtonUp = Event:new(),
    OnBButtonDown = Event:new(),
    OnBButtonHold = Event:new(),
}
Input.__index = Input

local lastCrankAngle = 0

-- hold configuration (frames)
local DEFAULT_HOLD_DELAY = 12 -- ~0.4s @ 30fps, adjust as desired

-- per-button state
local buttonState = {
    [playdate.kButtonA] = { pressed = false, timer = 0, holdFired = false, delay = DEFAULT_HOLD_DELAY },
    [playdate.kButtonB] = { pressed = false, timer = 0, holdFired = false, delay = DEFAULT_HOLD_DELAY },
    [playdate.kButtonUp] = { pressed = false, timer = 0, holdFired = false, delay = DEFAULT_HOLD_DELAY },
    [playdate.kButtonDown] = { pressed = false, timer = 0, holdFired = false, delay = DEFAULT_HOLD_DELAY },
    [playdate.kButtonLeft] = { pressed = false, timer = 0, holdFired = false, delay = DEFAULT_HOLD_DELAY },
    [playdate.kButtonRight] = { pressed = false, timer = 0, holdFired = false, delay = DEFAULT_HOLD_DELAY },
}

local function raiseEventForButton(id, downEv, holdEv, upEv)
    local st = buttonState[id]
    if playdate.buttonJustPressed(id) then
        st.pressed = true
        st.timer = 0
        st.holdFired = false
        if downEv then downEv:raise() end
    elseif playdate.buttonIsPressed(id) and st.pressed then
        st.timer = st.timer + 1
        if not st.holdFired and st.timer >= st.delay then
            st.holdFired = true
            if holdEv then holdEv:raise() end
        end
    elseif playdate.buttonJustReleased(id) and st.pressed then
        -- release
        st.pressed = false
        st.timer = 0
        st.holdFired = false
        if upEv then upEv:raise() end
    end
end

function Input:checkCrank()
    local currentCrankAngle = playdate.getCrankPosition()
    if currentCrankAngle ~= lastCrankAngle then
        self.OnCrankValueChange:raise(currentCrankAngle)
        lastCrankAngle = currentCrankAngle
    end
end

function Input:checkButtons()
    raiseEventForButton(playdate.kButtonA, self.OnAButtonDown, self.OnAButtonHold, self.OnAButtonUp)
    raiseEventForButton(playdate.kButtonB, self.OnBButtonDown, self.OnBButtonHold, self.OnBButtonUp)
end

function Input:checkArrows()
    raiseEventForButton(playdate.kButtonUp, self.OnUpArrowDown, self.OnUpArrowHold, self.OnUpArrowUp)
    raiseEventForButton(playdate.kButtonDown, self.OnDownArrowDown, self.OnDownArrowHold, self.OnDownArrowUp)
    raiseEventForButton(playdate.kButtonLeft, self.OnLeftArrowDown, self.OnLeftArrowHold, self.OnLeftArrowUp)
    raiseEventForButton(playdate.kButtonRight, self.OnRightArrowDown, self.OnRightArrowHold, self.OnRightArrowUp)
end

function Input:update()
    self:checkCrank()
    self:checkButtons()
    self:checkArrows()
end

return Input