







log_event(0,0,0,0,12,0,"State changed to "..get_gbl("state"..state.."label",state),5,0)
--[[
1st = flag 0 or 1 NO IDEA WHAT IT DOES, maybe fault or not
2nd = terminal
3rd = Channel
4th = Channel Type - integer
5th = Fault type - integer
6th = Value it faulted on, can be a float or integer
7th = Fault Test, so first fault string
8th = Event type, ineteger
9th = Setpoint, float or integer
]]

--509 for custom fault type



  -- Suction SDV Faults
if Solenoid_Suction_SDV_Cmd == 1 then
	if Solenoid_Suction_SDV_Open_LS == 0 then
	  	if get_time() - Suction_SDV_Open_Fault_Tmr > 10 then customFault(" Suction SDV-4001 Open") end
	else
		Suction_SDV_Open_Fault_Tmr = get_time()
	end
else
	Suction_SDV_Open_Fault_Tmr = get_time()
end



customFault("Script ".."Thomasn") -- Script can be lower or upper case on the "S", adding word script before the actual fault is what triggers Thomas 
-- code to work.


set_sVirt("ERCMCustomAlarm","hahahhah")


