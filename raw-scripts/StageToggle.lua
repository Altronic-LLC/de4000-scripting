function StageToggle(stageNumber)
    local engineState = get_state()
    local stageToggle = get_sVirt("State " .. stageNumber .. " Hold", "Advance")
    local stageActual = get_sVirt("Stage" .. stageNumber .. "Actual", 0)

    if engineState == 0 and stageToggle == "Not Available" and stageActual == 0 then
        set_sVirt("Stage" .. stageNumber .. "Actual", 0)
        set_sVirt("State " .. stageNumber .. " Hold", "Advance")
        checkToggle("State " .. stageNumber .. " Hold", "Advance", "Hold")
    end

    checkToggle("State " .. stageNumber .. " Hold", "Advance", "Hold")
    stageToggle = get_sVirt("State " .. stageNumber .. " Hold", "Advance")
    stageActual = get_sVirt("Stage" .. stageNumber .. "Actual", 0)

    if stageToggle == "Advance" then
        set_sVirt("Stage" .. stageNumber .. "Actual", "0")
        set_sVirt("State " .. stageNumber .. " Hold", "Advance")
    end

    if stageToggle == "Hold" then
        set_sVirt("Stage" .. stageNumber .. "Actual", "1")
        set_sVirt("State " .. stageNumber .. " Hold", "Hold")
    end

    if engineState >= stageNumber and stageActual == 0 then
        set_sVirt("State " .. stageNumber .. " Hold", "Not Available")
    end
end

StageToggle(7) -- 7 = Stage Number