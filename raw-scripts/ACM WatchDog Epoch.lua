












  -- ACM Watchdog for Epoch
function Check_Epoch_Timeout(Epoch_Value, Fault_Delay, Fault_Name)
    -- Create tables to track multiple epoch sources
    _G.EpochTracker = _G.EpochTracker or {}
    local tracker = _G.EpochTracker[Fault_Name] or { last_value = nil, last_change_time = os.time() }

    -- First run or value changed
    if tracker.last_value ~= Epoch_Value then
        tracker.last_value = Epoch_Value
        tracker.last_change_time = os.time()
        _G.EpochTracker[Fault_Name] = tracker
        return 0
    end

    -- Calculate elapsed time since last change
    local elapsed = os.time() - tracker.last_change_time

    -- If time exceeds threshold → fault
    if elapsed >= Fault_Delay then
        set_fault(Fault_Name, 1, "Epoch '" .. TagName .. "' not updating for " .. Fault_Delay .. "s")
        customFault(" Watchdog Fault "..Fault_Name)
    end
end