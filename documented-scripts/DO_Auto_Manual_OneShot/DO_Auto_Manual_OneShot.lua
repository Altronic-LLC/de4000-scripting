----------------------------
-- Rev 1.0 - Initial Release
----------------------------

function DigitalOutput_OneShot_AutoMan(Name,Output_Terminal,Output_Number,Normally_Closed,Enable_Manual,Input)
    local Name = Name
    if not get_sVirt("_"..Name.."_FS") then
        set_sVirt("_"..Name.."_FS",1)
        set_sVirt(Name.." Command","Open")
        set_sVirt(Name.." Mode","Auto")
    end
  
    local Terminal = Output_Terminal
    local Output = Output_Number
    local DO_Cmd = Input
    local Normally_Closed_Input = Normally_Closed
    local Manual_Enabled = Enable_Manual
    
    -- Opened/Closed Control 
    checkToggle(Name.." Mode","Auto","Manual")
    checkToggle(Name.." Command","Close","Open")
    
    if Manual_Enabled == 0 then set_sVirt(Name.." Mode","Auto") end
  
    if get_sVirt(Name.." Mode","Manual") == "Manual" then 
        if Normally_Closed_Input == 1 then 
            if get_sVirt(Name.." Command") == "Close" then 
                DO_Cmd = 0
            else
                DO_Cmd = 1
            end
        else
            if get_sVirt(Name.." Command") == "Open" then 
                DO_Cmd = 0
            else
                DO_Cmd = 1
            end
        end
    else
        if DO_Cmd == 1 then
            if Normally_Closed_Input == 1 then
                set_sVirt(Name.." Command","Open")
            else
                set_sVirt(Name.." Command","Close")
            end
        else
            if Normally_Closed_Input == 1 then
                set_sVirt(Name.." Command","Close")
            else
                set_sVirt(Name.." Command","Open")
            end
        end
    end
  
    -- Opened/Closed Control 
    if DO_Cmd ~= get_sVirt("_"..Name.."_Cmd_Last") then 
        set_sVirt("_"..Name.."_Output",DO_Cmd)
        set_sVirt("_"..Name.."_Cmd_Last",DO_Cmd)
    end
  
    set_do_val(Output_Terminal,Output_Number,DO_Cmd)
  end


DigitalOutput_OneShot_AutoMan("Blowdown",1,3,0,Enable_Manual_Switch,Blowdown_Output_Cmd) -- Example "Blowdown" = NAME  1 = Output Terminal, 3 = Output Number, 0 = Normally_Open, 1 = Manual Mode Change Enabled, Blowdown_Output_Cmd = Variable Name Used In Master Script Logic
DigitalOutput_OneShot_AutoMan("Bypass",1,6,1,Enable_Manual_Switch,Bypass_Output_Cmd) -- Example "Bypass" = NAME  1 = Output Terminal, 1 = Output Number, 1 = Normally_Closed, 1 = Manual Mode Change Enabled, Bypass_Output_Cmd = Variable Name Used In Master Script Logic

if not FirstScan then
    FirstScan = 1
    set_sVirt("Enable_Manual",1)
end

Enable_Manual_Switch = get_sVirt("Enable_Manual",0)
