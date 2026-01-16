--5900-FLX30-008 Program -- REFERENCE JOB

if not Auto_Restart_FS then
  Auto_Restart_FS = 1
  Timer_Restart = get_time()

  set_sVirt("Auto Restart Permissive",0)
    
	create_param("Auto_Restart_Attemps",4,"Auto Restart","Enter The Number Of Restart Attemps Before Faulting")
  create_param("Crank_Wait_Time",5,"Auto Restart","Enter The Time To Let The Engine Crank Before Shutting Down And Trying Again")
  create_param("Crank_Restart_Delay_Time",10,"Auto Restart","Enter The Time After A Failed Attempt To Energize Cranking Again")
end


--***********************-----------------------------***********************
-- local Variables (Inputs)
--***********************-----------------------------***********************

local State = get_state()
local RemoteSelected = get_channel_val(1,18)
local RemoteStart = get_channel_val(1,31)
local ActuCom_Raise = get_channel_val(1,9)
local ActuCom_Lower = get_channel_val(1,10)

--***********************-----------------------------***********************
-- Parameter Variables
--***********************-----------------------------***********************
local State_Time = get_sVirt("timer",0)
local Crank_Wait_Time = get_param("Crank_Wait_Time",0)
local Crank_Restart_Delay_Time = get_param("Crank_Restart_Delay_Time",0)

if get_state() == 0 then
    Auto_Restart_Attemps = get_param("Auto_Restart_Attemps",0)
    Auto_Restart_Enabled = 0
end

if get_state() == 1 then
    if Auto_Restart_Enabled == 1 then
        if get_time() - Timer_Restart > Crank_Restart_Delay_Time then
            Auto_Restart_Enabled = 0
        else
            set_sVirt("Auto Restart Permissive",0)
        end
    else
        set_sVirt("Auto Restart Permissive",1)
    end
end
 
if get_state() == 2 then
 	if RemoteSelected == 1 then
    	Auto_Restart_Enabled = 1
    	set_sVirt("Auto Restart Permissive",0)
    else
    	Auto_Restart_Enabled = 0
    end
end
 
if get_state() == 6 then
    if get_time() - State_6_Timer > Crank_Wait_Time then
        if RemoteSelected == 1 then
            set_state(1)
            Timer_Restart = get_time()
            Auto_Restart_Attemps = Auto_Restart_Attemps - 1
            set_ctrl_do(1,0)
            set_ctrl_do(2,0)
            set_ctrl_do(3,0)
            if Auto_Restart_Attemps <= 0 then customFault("Crank Attempt Fail") end
        end
    end
else
    State_6_Timer = get_time()
end
 
set_sVirt("Auto_Restart_Enabled",Auto_Restart_Enabled)
set_sVirt("Auto_Restart_Attemps",Auto_Restart_Attemps)
set_sVirt("Crank Time remaining",Crank_Wait_Time - (get_time() - State_6_Timer))
set_sVirt("Crank Delay Time",Crank_Restart_Delay_Time - (get_time() - Timer_Restart))





--***********************-----------------------------***********************
-- Routine
--***********************-----------------------------***********************

if get_state() == 0 then
	if RemoteSelected == 1 then
    	if RemoteStart == 1 then		
        	set_sGbl("resetFlag", true)
        	set_sGbl("startPressed", true)  
		end
	end
end






