function valveIndicator(Name, ClosedTerm, ClosedInput, OpenedTerm, OpenedInput, NormalClosedOperation)


    local ClosedValve_LS = get_channel_val(ClosedTerm, ClosedInput)
    local OpenValve_LS = get_channel_val(OpenedTerm, OpenedInput)

    if ClosedValve_LS == math.abs(0 - NormalClosedOperation) and OpenValve_LS == math.abs(1 - NormalClosedOperation) then
        set_sVirt(Name.."_Valve_Position", "OPEN(#FB2103)") end --Green
    if ClosedValve_LS == math.abs(0 - NormalClosedOperation) and OpenValve_LS == math.abs(0 - NormalClosedOperation) then
        set_sVirt(Name.."_Valve_Position", "MOVING(#E2F40A)") end --Yellow
    if ClosedValve_LS == math.abs(1 - NormalClosedOperation) and OpenValve_LS == math.abs(0 - NormalClosedOperation) then
        set_sVirt(Name.."_Valve_Position", "CLOSED(#58FF33)") end --Red
    if ClosedValve_LS == math.abs(1 - NormalClosedOperation) and OpenValve_LS == math.abs(1 - NormalClosedOperation) then 
        set_sVirt(Name.."_Valve_Position", "ERROR(#A105FA)") end --Purple
end


valveIndicator("Bypass", 2, 25, 2, 26, 1) --Name = "Bypass", ClosedTerm = 2, ClosedInput = 25, OpenedTerm = 2, OpenedInput = 26, NormalClosedOperation = 1