----------------------------
-- Debounce Input Timer --
----------------------------

if not firstcan then
	firstcan = 1
	set_sVirt("Channel1",0)
	set_sVirt("Channel2",1)
end

set_channel_val(1,1,get_sVirt("Channel1",0))
set_channel_val(1,2,get_sVirt("Channel2",1))

function DI_Debounce(Channel,On_Time,Off_Time,Var_Name)
	local On_Timer = Var_Name.."On"
	local Off_Timer = Var_Name.."Off"
	local Active_On,Remaining_On = get_timer(On_Timer)
	local Active_Off,Remaining_Off = get_timer(Off_Timer)
	if Channel == 0 then 
		set_timer(On_Timer,On_Time)
		if not get_timer(Off_Timer) then set_timer(Off_Timer,Off_Time) end
		if Remaining_Off == 0 then 
			set_sVirt(Var_Name,0)
		end
	elseif Channel == 1 then
		set_timer(Off_Timer,Off_Time)
		if not get_timer(On_Timer) then set_timer(On_Timer,On_Time) end
		if Remaining_On == 0 then 
			set_sVirt(Var_Name,1)
		end
	end
end



DI_Debounce(get_channel_val(1,1),10,10,"Input1_Debounce")
local Input1_Debounce = get_sVirt("Input1_Debounce")

DI_Debounce(get_channel_val(1,2),2,2,"Input2_Debounce")
local Input2 = get_sVirt("Input2_Debounce")
