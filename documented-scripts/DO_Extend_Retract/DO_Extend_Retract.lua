----------------------------
-- Rev 1.0 - Initial Release
----------------------------

-- Extend / Retract Function
function DO_Ext_Ret(Name,Extend_Time,Retract_Time,Enable,Override)
    local Enable_Input = Enable
    local Extend_Timer = Name.."Extend"
    local Retract_Timer = Name.."Retract"
    local Override_OS = Override
    local Active_Extend,Remaining_Extend = get_timer(Extend_Timer)
    local Active_Retract,Remaining_Retract = get_timer(Retract_Timer)

	if not get_sVirt("_"..Name.."_FS") then
        set_sVirt("_"..Name.."_FS",1)
		set_sVirt(Name.."State",0)
		set_timer(Extend_Timer,Extend_Time)
		set_timer(Retract_Timer,Retract_Time)
    end

  	local State = get_sVirt(Name.."State",0)

  	if Enable_Input == 1 then  
		if State == 0 then 
			set_timer(Retract_Timer,Retract_Time) 
			if Remaining_Extend == 0 or Override_OS == 1 then set_sVirt(Name.."State",2) end
			return "Extend"
		elseif State == 2 then 
			set_timer(Extend_Timer,Extend_Time) 
			if Remaining_Retract == 0 or Override_OS == 1 then set_sVirt(Name.."State",0) end
			return "Retract"
		end
	else
		set_timer(Retract_Timer,Retract_Time) 
		set_timer(Extend_Timer,Extend_Time) 
		if State == 0 then
			return "Extend"
		else
			return "Retract"
		end
	end
end


local Poppet_1_Valve = DO_Ext_Ret("Poppet_1",10,13,Enable_Function,Override_Output)  -- Example 1: "Poppet_1" = Name "User Enterable",  10 = Amount Of Time For Valve To Stay Extended, 13 = Amount Of Time For Valve To Stay Retracted, Enable_Function = Variable That Starts The Automatic Extend/Retract, Override_Output = Variable used to force switch before time has expired for switching (NEEDS TO BE ONESHOT OR ELSE WILL OUTPUT WILL CONSTANTLY SWITCH)

local Poppet_2_Valve = DO_Ext_Ret("Poppet_2",5,5,Enable_Function,Override_Output)  -- Example 2: "Poppet_2" = Name "User Enterable",  5 = Amount Of Time For Valve To Stay Extended, 5 = Amount Of Time For Valve To Stay Retracted, Enable_Function = Variable That Starts The Automatic Extend/Retract, Override_Output = Variable used to force switch before time has expired for switching (NEEDS TO BE ONESHOT OR ELSE WILL OUTPUT WILL CONSTANTLY SWITCH)





