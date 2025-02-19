-- Analog Output Auto / Manual Control 
function AO_ManAutoButton(Name,Output_Terminal,Output_Number,Increment,Enable_Manual,Analog_Cmd)
    if not get_sVirt(Name.."_FS") then
      set_sVirt(Name.."_FS",1)
      set_sVirt(Name.."_Mode","Auto")
    end
  
    local Valve_Increment = Increment
      
    -- Manual Control 
    checkToggle(Name.."_Mode","Auto","Manual")
    if Enable_Manual == 0 then set_sVirt(Name.."_Mode","Auto") end
    set_sVirt("Enable_Manual",Enable_Manual)
    
    if get_sVirt(Name.."_Mode") == "Manual" then
      if get_sVirt(Name.."_Manual_POSBump",0) ~= 0 then
        local Position = get_sVirt(Name.."_Manual_POS",0)
        Position = Position + (Valve_Increment * get_sVirt(Name.."_Manual_POSBump",0))
        set_sVirt(Name.."_Manual_POS",tostring(math.floor(Position)))
        set_sVirt(Name.."_Manual_POSBump",0)
      end
    else 
      set_sVirt(Name.."_Manual_POSBump",0)
    end
    
    if get_sVirt(Name.."_Manual_POS",0) >= 100 then set_sVirt(Name.."_Manual_POS",100) end
    if get_sVirt(Name.."_Manual_POS",0) <= 0 then set_sVirt(Name.."_Manual_POS",0) end

    if get_sVirt(Name.."_Mode") == "Manual" then
        set_ao_val(Output_Terminal,Output_Number,get_sVirt(Name.."_Manual_POS",0))
    else
        set_ao_val(Output_Terminal,Output_Number,Analog_Cmd)
        set_sVirt(Name.."_Manual_POS",Analog_Cmd)
    end
end

if not Andrew_FS then
    Andrew_FS = 1
    set_sVirt("Manual_Enalble",0)
    set_sVirt("Andrew_CMD",0)
end

local Manual_Enable_Andrew = get_sVirt("Manual_Enalble",0)
local Andrew_CMD = get_sVirt("Andrew_CMD",0)


AO_ManAutoButton("Andrew_Analog_OUTPUT",1,1,10,Manual_Enable_Andrew,Andrew_CMD)
