----------------------------
-- Rev 1.0 - Initial Release
----------------------------

----------------------------
-- Debounce Input Timer --
----------------------------
function DI_Debounce(Name,Channel,On_Time,Off_Time)
	local On_Timer = Name.."On"
	local Off_Timer = Name.."Off"
	local Active_On,Remaining_On = get_timer(On_Timer)
	local Active_Off,Remaining_Off = get_timer(Off_Timer)
	if Channel == 0 then 
		set_timer(On_Timer,On_Time)
		if not get_timer(Off_Timer) then set_timer(Off_Timer,Off_Time) end
		if Remaining_Off == 0 then 
			set_sVirt(Name,0)
		end
	elseif Channel == 1 then
		set_timer(Off_Timer,Off_Time)
		if not get_timer(On_Timer) then set_timer(On_Timer,On_Time) end
		if Remaining_On == 0 then 
			set_sVirt(Name,1)
		end
	end
	if get_sVirt(Name,0) == 0 then return 0 end
	if get_sVirt(Name,0) == 1 then return 1 end

end

local Input1_Debounce = DI_Debounce("Input1_Debounce",get_channel_val(1,1),10,10) -- Example 1: "Input1_Debounce" = Name "User Enterable",  Channel = Input Channel, 10 = When Channel Is HIGH, Debounce Time, 10 = When Channel Is LOW, Debounce Time

local Input2_Debounce = DI_Debounce("Input2_Debounce",get_channel_val(1,2),2,4) -- Example 1: "Input2_Debounce" = Name "User Enterable",  Channel = Input Channel, 2 = When Channel Is HIGH, Debounce Time, 4 = When Channel Is LOW, Debounce Time
