









  -- Analog Debounce Timer
function AnalogDebounce(Name, InputValue, DebounceTime, TriggerPoint, HighLow)
    -- ensure global tracker table exists
    _G.EpochTracker = _G.EpochTracker or {}

    -- initialize tracker for this channel if missing
    if _G.EpochTracker[Name] == nil then
        _G.EpochTracker[Name] = { last_change_time = os.clock(), last_state = 0 }
    end
    local tracker = _G.EpochTracker[Name]

    -- reset timer if signal moves opposite of desired direction
    if HighLow == "High" then
        -- trigger on HIGH
        if InputValue < TriggerPoint then
            tracker.last_change_time = os.clock()
            tracker.last_state = 0
        end
    else
        -- trigger on LOW
        if InputValue > TriggerPoint then
            tracker.last_change_time = os.clock()
            tracker.last_state = 0
        end
    end

    -- elapsed time in seconds
    local elapsed = os.clock() - tracker.last_change_time
    set_sVirt("elapsed", elapsed)

    -- check if debounce time exceeded
    if elapsed >= DebounceTime then
        tracker.last_state = 1
    end

    return tracker.last_state
end

if not firstscan then
  firstscan = 1
  set_sVirt("Input",31)
  set_sVirt("DebounceTime",10)
  set_sVirt("Triggerpoint",30)
  set_sVirt("Highlow",1)

end

local Input = get_sVirt("Input",20)
local DebounceTime = get_sVirt("DebounceTime",10)
local Triggerpoint = get_sVirt("Triggerpoint",30)
local Highlow = get_sVirt("Highlow",1)

local Debug = AnalogDebounce("Debug1", Input, DebounceTime, Triggerpoint, "High")
set_sVirt("Debug",Debug)