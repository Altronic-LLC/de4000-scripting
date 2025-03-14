----------------------------
-- Rev 1.0 - Initial Release
----------------------------

function DO_Manual_ON_OFF(Name,Output_Terminal,Output_Number,Normally_Closed)
    local Normally_Closed_Input = Normally_Closed
    if not get_sVirt("_"..Name.."_FS") then
        set_sVirt("_"..Name.."_FS",1)
        if Normally_Closed_Input == 1 then set_sVirt(Name.." Command","Close") else set_sVirt(Name.." Command","Open") end
        set_sVirt(Name.." Control",0)
    end

    -- Opened/Closed Control 
    checkToggle(Name.." Command","Close","Open")

    if Normally_Closed_Input == 1 then 
        if get_sVirt(Name.." Command") == "Close" then 
            set_sVirt(Name.." Control",0)
        else
            set_sVirt(Name.." Control",1)
        end
    else
        if get_sVirt(Name.." Command") == "Open" then 
            set_sVirt(Name.." Control",0)
        else
            set_sVirt(Name.." Control",1)
        end
    end

    local Digital_Output = get_sVirt(Name.." Control",0)
    set_do_val(Output_Terminal,Output_Number,Digital_Output)
end

DO_Manual_ON_OFF("Blowdown",1,6,0) -- Example "Blowdown" = NAME, 1 = Output Terminal, 6 = Output Number, 0 = Normally_Open
DO_Manual_ON_OFF("Bypass",1,3,1) -- Example "Bypass" = NAME, 1 = Output Terminal, 3 = Output Number, 1 = Normally_Closed