--***********************-----------------------------***********************
-- Process Secondary control signals
--***********************-----------------------------***********************
  -- Analog Debounce Timer
function AnalogDebounce(Name, InputValue, DebounceTime, TriggerPoint, HighLow)
    -- ensure global tracker table exists
    _G.EpochTracker = _G.EpochTracker or {}

    -- initialize tracker for this channel if missing
    if _G.EpochTracker[Name] == nil then
        _G.EpochTracker[Name] = { last_change_time = get_time(), last_state = 0 }
    end
    local tracker = _G.EpochTracker[Name]

    -- reset timer if signal moves opposite of desired direction
    if HighLow == "High" then
        -- trigger on HIGH
        if InputValue < TriggerPoint then
            tracker.last_change_time = get_time()
            tracker.last_state = 0
        end
    else
        -- trigger on LOW
        if InputValue > TriggerPoint then
            tracker.last_change_time = get_time()
            tracker.last_state = 0
        end
    end

    -- elapsed time in seconds
    local elapsed = get_time() - tracker.last_change_time
    set_sVirt("elapsed", elapsed)

    -- check if debounce time exceeded
    if elapsed >= DebounceTime then
        tracker.last_state = 1
    end

    return tracker.last_state
end

local TE101_Process_Line_Temp_Rdy = AnalogDebounce("Name1", TE101_Process_Line_Temp, 5, 140, "High")
local AT101_Oxygen_Concentration_Rdy = AnalogDebounce("Name2", AT101_Oxygen_Concentration, 30, 4, "High")
local PIT103_Combustion_Chamber_Prs_Rdy = AnalogDebounce("Name3", PIT103_Combustion_Chamber_Prs, 1, -1, "Low")
local AT301_Scrubber_Liquid_PH_Low_Rdy = AnalogDebounce("Name4", AT301_Scrubber_Liquid_PH, 10, 7.5, "Low")
local AT302_Scrubber_Liquid_PH_Low_Rdy = AnalogDebounce("Name5", AT302_Scrubber_Liquid_PH, 10, 7.5, "Low")
local AT301_Scrubber_Liquid_PH_High_Rdy = AnalogDebounce("Name6", AT301_Scrubber_Liquid_PH, 10, 10.5, "High")
local AT302_Scrubber_Liquid_PH_High_Rdy = AnalogDebounce("Name7", AT302_Scrubber_Liquid_PH, 10, 10.5, "High")
local AT301_Scrubber_Liquid_Conductivity_Rdy = AnalogDebounce("Name8", AT301_Scrubber_Liquid_Conductivity, 1, 200, "High")
local AT303_Scrubber_Liquid_Conductivity_Rdy = AnalogDebounce("Name9", AT302_Scrubber_Liquid_Conductivity, 1, 200, "High")

local Inputs_Ready_1 = (TE101_Process_Line_Temp_Rdy == 0 and AT101_Oxygen_Concentration_Rdy == 0 and PIT103_Combustion_Chamber_Prs_Rdy == 0) and 1 or 0
local Inputs_Ready_2 = (AT301_Scrubber_Liquid_PH_Low_Rdy == 0 and AT302_Scrubber_Liquid_PH_Low_Rdy == 0 and AT301_Scrubber_Liquid_PH_High_Rdy == 0) and 1 or 0
local Inputs_Ready_3 = (AT302_Scrubber_Liquid_PH_High_Rdy == 0 and AT301_Scrubber_Liquid_Conductivity_Rdy == 0 and AT303_Scrubber_Liquid_Conductivity_Rdy == 0) and 1 or 0

local Secondary_Process_Ready = (Inputs_Ready_1 == 1 and Inputs_Ready_2 == 1 and Inputs_Ready_3 == 1) and 1 or 0