----------------------------
-- Digital Output Function --
-- Name = Enter The Name Of The Output In Parenthesis 
-- Output_Terminal = Terminal Board Number For Digital Output
-- Output_Number = Output Number For The Digital Output
-- Normally_Closed = 0 = Normally Open, 1 = Normally Closed
-- Enable_Manual = If this is a 0 can not change to manual mode, if 1 then toggle button active
-- Input = Variable Name Used In Master Script Logic
----------------------------
-- Auto / Manual Dual Valve DO
function DO_OneShot_AutoMan_Dual_Valve(Name,Open_Output_Terminal,Open_Output_Number,Close_Output_Terminal,Close_Output_Number,Enable_Manual,Open_LS,Close_LS,Input)
    local Name = Name
    if not get_sVirt("_"..Name.."_FS") then
        set_sVirt("_"..Name.."_FS",1)
        set_sVirt(Name.." Command","Open")
        set_sVirt(Name.." Mode","Auto")
    end
  
    local Open_Terminal = Open_Output_Terminal
    local Open_Output = Open_Output_Number
    local Close_Terminal = Close_Output_Terminal
    local Close_Output = Close_Output_Number
    local DO_Cmd = Input
    local Manual_Enabled = Enable_Manual
    local Valve_Open_LS = Open_LS
    local Valve_Close_LS = Close_LS
    
    -- Opened/Closed Control 
    checkToggle(Name.." Mode","Auto","Manual")
    checkToggle(Name.." Command","Close","Open")
    
    if Manual_Enabled == 0 then set_sVirt(Name.." Mode","Auto") end
  
    if get_sVirt(Name.." Mode","Manual") == "Manual" then 
      if get_sVirt(Name.." Command") == "Open" then 
        if Valve_Close_LS == 0 then Close_Cmd = 1 else Close_Cmd = 0 end
        Open_Cmd = 0
      else
        if Valve_Open_LS == 0 then Open_Cmd = 1 else Open_Cmd = 0 end
        Close_Cmd = 0
      end 
    else
      if DO_Cmd == 1 then -- DO_CMD = 1 IS CLOSED CMD
        set_sVirt(Name.." Command","Open")
        if Valve_Close_LS == 0 then Close_Cmd = 1 else Close_Cmd = 0 end
        Open_Cmd = 0
      else
        set_sVirt(Name.." Command","Close")
        if Valve_Open_LS == 0 then Open_Cmd = 1 else Open_Cmd = 0 end
        Close_Cmd = 0
      end
    end
    
    set_do_val(Open_Terminal,Open_Output,Open_Cmd)
    set_do_val(Close_Terminal,Close_Output,Close_Cmd)
  end
  
  if not FirstScan then
    FirstScan = 1
    set_sVirt("Valve_Cmd",0)
    set_sVirt("Open LS",0)
    set_sVirt("Close LS",1)
  end
  
  local Valve_Cmd = get_sVirt("Valve_Cmd",0)
  local Suction_Valve_Open_LS = get_sVirt("Open LS",0)
  local Suction_Valve_Close_LS = get_sVirt("Close LS",0)
  
  DO_OneShot_AutoMan_Dual_Valve("Suction Valve Gov111",1,1,1,4,1,Suction_Valve_Open_LS,Suction_Valve_Close_LS,Valve_Cmd)
  
  
  if Suction_Valve_Close_LS == 0 and Suction_Valve_Open_LS == 1 then set_sVirt("Suction_Stg1_GOV311_Valve_Position","OPEN(#58FF33)") end --Green  
  if Suction_Valve_Close_LS == 0 and Suction_Valve_Open_LS == 0 then set_sVirt("Suction_Stg1_GOV311_Valve_Position","MOVING(#E2F40A)") end --Yellow
  if Suction_Valve_Close_LS == 1 and Suction_Valve_Open_LS == 0 then set_sVirt("Suction_Stg1_GOV311_Valve_Position","CLOSED(#FB2103)") end --Red
  if Suction_Valve_Close_LS == 1 and Suction_Valve_Open_LS == 1 then set_sVirt("Suction_Stg1_GOV311_Valve_Position","ERROR(#A105FA)") end --Purple
  