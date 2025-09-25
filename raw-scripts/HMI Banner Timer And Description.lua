-- Function to update countdown status
function Countdown(Description, Time_Ref, stabilizationTime)
    local Elapsed = get_time() - Time_Ref
    local Remaining = stabilizationTime - Elapsed
    local Text = Description

    if Remaining < 0 then Remaining = 0 end  -- prevent negative countdown

    -- Calculate Minutes and Seconds Remaining
    local Minutes = math.floor(Remaining / 60)
    local Seconds = math.floor(Remaining % 60)

    -- Show formatted countdown
    set_sVirt("statusString",string.format("%s - : %02d:%02d", Text, Minutes, Seconds))
end

if get_state() == 0 then timer = get_time() end

if get_state() > 0 then Countdown("Tewsting Andrwe Test",timer,120) end