----------------------------
-- Momentary Button Function --
-- Name = Enter The Name Of The Output In Parenthesis 
-- Output_Terminal = Terminal Board Number For Digital Output
-- Output_Number = Output Number For The Digital Output
-- On_Time = Enter Time To Keep Output On, Once Energized
----------------------------
function MomentaryPB(Name,Output_Terminal,Output_Number,Time,Normally_Closed)
    if not get_sVirt("_"..Name.."_FS") then
        set_sVirt("_"..Name.."_FS",1)
        if Normally_Closed == 1 then 
            set_sVirt(Name.." PB","OFF") 
            set_do_val(Output_Terminal,Output_Number,1)
        else 
            set_sVirt(Name.." PB","ON") 
            set_do_val(Output_Terminal,Output_Number,0)
        end
    end

    local Terminal = Output_Terminal
    local Output = Output_Number
    local On_Off_Time = Time
    local Active,Remaining = get_timer(Name.."TMR")
    local Reverse_Act = Normally_Closed

    if Reverse_Act == 1 then 
        if get_sVirt(Name.." PB") == "OFF" then
            checkToggle(Name.." PB","OFF","ON")
        end
    else
        if get_sVirt(Name.." PB") == "ON" then
            checkToggle(Name.." PB","ON","OFF")
        end
    end


    if Reverse_Act == 1 then 
        if get_do_val(Terminal,Output) == 0 then
            if Remaining == 0 then 
                set_do_val(Terminal,Output,1)
                set_sVirt(Name.." PB","OFF")
            else
                set_sVirt(Name.." PB",Remaining)
            end
        end

        if get_sVirt(Name.." PB") == "ON" and get_do_val(Terminal,Output) == 1 then
            if not get_timer(Name.."TMR") then
                set_timer(Name.."TMR",On_Off_Time)
                set_do_val(Terminal,Output,0)
            end
        end
    else
        if get_do_val(Terminal,Output) == 1 then
            if Remaining == 0 then 
                set_do_val(Terminal,Output,0)
                set_sVirt(Name.." PB","ON")
            else
                set_sVirt(Name.." PB",Remaining)
            end
        end

        if get_sVirt(Name.." PB") == "OFF" and get_do_val(Terminal,Output) == 0 then
            if not get_timer(Name.."TMR") then
                set_timer(Name.."TMR",On_Off_Time)
                set_do_val(Terminal,Output,1)
            end
        end
    end
end

MomentaryPB("VFD Reset",1,2,3,1) -- This example "VFD RESET" = Name, 1 = Terminal Board, 2 = Output #, 3 = ON/OFF_Time, Normally_Closed

MomentaryPB("Reset",1,5,5,0) -- This example "Reset" = Name, 1 = Terminal Board, 5 = Output #, 5 = ON/OFF_Time


