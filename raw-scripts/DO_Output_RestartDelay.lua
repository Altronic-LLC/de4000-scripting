





	-- Do Timed Output
function DO_Output_RestartDelay(Output_Terminal, Output_Number, DelayTime, Output_Cmd, Override)
    local Name = tostring(Output_Terminal) .. tostring(Output_Number)
    local timerName = Name .. "_RestartDelay"

    local active, remaining = get_timer(timerName)

    -- Handle override: force output OFF immediately
    if Override == 0 then
        set_do_val(Output_Terminal, Output_Number, 0)
        return
    end

    if Output_Cmd == 0 then
        -- Turn output OFF immediately and start timer if not already running
        set_do_val(Output_Terminal, Output_Number, 0)
        if not active then
            set_timer(timerName, DelayTime)
        end
    elseif Output_Cmd == 1 then
        -- Only allow ON if timer expired or not active
        if (not active) or (remaining <= 0) then
            set_do_val(Output_Terminal, Output_Number, 1)
        else
            set_do_val(Output_Terminal, Output_Number, 0)
        end
    end
end











