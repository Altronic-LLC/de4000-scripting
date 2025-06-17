  -- PID Auto / Manual Control 
function ManAutoButton(Name,PID_Number,Increment,Enable_Manual)
    if not get_sVirt(Name.."_FS") then
      set_sVirt(Name.."_FS",1)
      set_sVirt(Name.."_Mode","Auto")
    end
  
    local Valve_Increment = Increment
  
    if get_sVirt(Name.."_Mode") == "Manual" then 
      set_sGbl("PID"..PID_Number.."Override",get_sVirt(Name.."_Manual_POS") )
    else
      set_sGbl("PID"..PID_Number.."Override",-1)
      set_sVirt(Name.."_Manual_POS",get_sVirt("PID"..PID_Number.."Op",0))
    end
    
    -- Manual Control 
    checkToggle(Name.."_Mode","Auto","Manual")
    if Enable_Manual == 0 then set_sVirt(Name.."_Mode","Auto") end
    
    if get_sVirt(Name.."_Mode") == "Manual" then
      if get_sVirt(Name.."_Manual_POSBump",0) ~= 0 then
        local si = 10 -- Default SpeedIncrement if no parameter has been created
        local sip = Valve_Increment
        if sip ~= 0 then si = sip end
        local Position = get_sVirt(Name.."_Manual_POS",0)
        Position = Position + (si * get_sVirt(Name.."_Manual_POSBump",0))
        set_sVirt(Name.."_Manual_POS",tostring(math.floor(Position)))
        set_sVirt(Name.."_Manual_POSBump",0)
      end
    else 
      set_sVirt(Name.."_Manual_POSBump",0)
    end
    
    if get_sVirt(Name.."_Manual_POS",0) >= 100 then set_sVirt(Name.."_Manual_POS",100) end
    if get_sVirt(Name.."_Manual_POS",0) <= 0 then set_sVirt(Name.."_Manual_POS",0) end
end

if State == 0 then
	ManAutoButton("XC102 Process Valve",2,5,Maintenance_Active)
end

if get_sVirt("XC102 Process Valve","Auto") == "Auto" then
	
	set_gbl("PID4Min",XC102_Process_Valve_Min_Pos)

	if Master_State < 100 then 
		set_sGbl("PID2Override",0)
	end

	if Master_State >= 800 then
		set_sGbl("PID2Override",-1)
	end
end