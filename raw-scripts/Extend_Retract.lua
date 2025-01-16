

-- Extend / Retract Function
function Ext_Ret(Name,Extend_Time,Retract_Time,Enable,Override)
    local Enable_Input = Enable
    local Extend_Timer = Name.."Extend"
    local Retract_Timer = Name.."Retract"
    local Override_OS = Override
    local Active_Extend,Remaining_Extend = get_timer(Extend_Timer)
    local Active_Retract,Remaining_Retract = get_timer(Retract_Timer)
	if not Fs then 
		Fs = 1
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


-- This Section Is Only for Testing Purposes, DO NOT PUT IN REAL CODE
if not FirstScan then
    FirstScan = 1
    set_sVirt("Enable",1)
    set_sVirt("Override",0)
end

local Enable_Function = get_sVirt("Enable",1)
local Override_Output = get_sVirt("Override",0)


local Poppet_1_Valve = Ext_Ret("Poppet_1",10,13,Enable_Function,Override_Output)

if Poppet_1_Valve == "Extend" then
    set_do_val(1,1,1)
else
    set_do_val(1,1,0)
end


local Poppet_2_Valve = Ext_Ret("Poppet_2",5,5,Enable_Function,Override_Output)

if Poppet_2_Valve == "Retract" then
    set_do_val(1,2,1)
else
    set_do_val(1,2,0)
end


