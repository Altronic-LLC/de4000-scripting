----------------------------
-- Rev 1.0 - Initial Release
----------------------------

function PB_Momentary(Name,Terminal_Board,Output_Number)
    if not get_sVirt(Name.." PB") then
        set_sVirt(Name.." PB","Off")
    end

    local Terminal = Terminal_Board
    local Output = Output_Number
    local Time = .5
    local active,remaining = get_timer(Name.."TMR")
    checkToggle(Name.." PB","Off","On")

    if get_sVirt(Name.." PB") == "On" and get_do_val(Terminal,Output) == 1 then
        if remaining == 0 then 
            set_do_val(Terminal,Output,0)
            set_sVirt(Name.." PB","Off")
        end
    end

    if get_sVirt(Name.." PB") == "On" and get_do_val(Terminal,Output) == 0 then
        if not get_timer(Name.."TMR") then
            set_timer(Name.."TMR",Time)
            set_do_val(Terminal,Output,1)
        end
    end
end

PB_Momentary("VFD Reet",1,2) -- This example "VFD RESET" = Name (User Enterable), 1 = Terminal_Board, 2 = Output_Number








