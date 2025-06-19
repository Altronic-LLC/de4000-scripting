--***************************************************
--Slide Valve Control
--***************************************************

if not Slide_FS then
  Slide_FS = 1

  create_param("Load_Valve_On_Time",1,"Slide Valve","Enter Load Valve on Time in Auto Mode (in sec)")
  create_param("Load_Valve_Off_Time",10,"Slide Valve","Enter Load Valve off Time in Auto Mode (in sec)")
  create_param("Unload_Valve_On_Time",1,"Slide Valve","Enter Unload Valve on Time in Auto Mode (in sec)")
  create_param("Unload_Valve_Off_Time",10,"Slide Valve","Enter Unload Valve off Time in Auto Mode (in sec)")
  create_param("Fast_Load_Valve_On_Time",3,"Slide Valve","Enter Load Valve on Time in Manual Mode (in sec)")
  create_param("Fast_Load_Valve_Off_Time",10,"Slide Valve","Enter Load Valve off Time in Manual Mode (in sec)")
  create_param("Fast_Unload_Valve_On_Time",3,"Slide Valve","Enter Unload Valve on Time in Manual Mode (in sec)")
  create_param("Fast_Unload_Valve_Off_Time",10,"Slide Valve","Enter Unload Valve off Time in Manual Mode (in sec)")
  create_param("Control_Deadband",0.1,"Slide Valve","Enter Deadband for the Slide Valve Control PDIC-101")
  create_param("Dis_Press_Deadband",1,"Slide Valve","Enter Deadband for the Discharge Pressure Control")

end

local Load_Valve_On_Time = 1000 * get_param("Load_Valve_On_Time",0)
local Load_Valve_Off_Time = get_param("Load_Valve_Off_Time",0)
local Unload_Valve_On_Time = 1000 * get_param("Unload_SV_On_Time",0)
local Unload_Valve_Off_Time = get_param("Unload_Valve_Off_Time",0)
local Fast_Load_Valve_On_Time = 1000 * get_param("Fast_Load_Valve_On_Time",0)
local Fast_Load_Valve_Off_Time = get_param("Fast_Load_Valve_Off_Time",0)
local Fast_Unload_Valve_On_Time = 1000 * get_param("Fast_Unload_Valve_On_Time",0)
local Fast_Unload_Valve_Off_Time = get_param("Fast_Unload_Valve_Off_Time",0)
local Control_Deadband = get_param("Control_Deadband",0)
local Dis_Press_Deadband = get_param("Dis_Press_Deadband",0)

local Comp_Dsch_Prs_SP = get_sVirt("Comp_Dsch_Prs_SP",0)

-------------------------------------------------------------------------
--  Determine Upper and Lower Deadband for Auto Control of Slide Valve
--  Primary - Differential Pressure
--  Secondary - Comp Discharge Pressure
-------------------------------------------------------------------------

local DiffPress_Half_DB = Control_Deadband / 2
local DiffPress_Low_DB_SP = DiffPress_SP - DiffPress_Half_DB
local DiffPress_High_DB_SP = DiffPress_SP + DiffPress_Half_DB

local Dis_Press_Half_Deadband = Dis_Press_Deadband / 2
local Dis_Press_Low_DB_SP = Comp_Dsch_Prs_SP - Dis_Press_Half_Deadband
local Dis_Press_High_DB_SP = Comp_Dsch_Prs_SP + Dis_Press_Half_Deadband


----------------------------------------------------- 
--Enable Auto Control
----------------------------------------------------- 

if Master_State >= 700 and Master_State < 900 and Man_Mode == 0 then
  SV_Auto_Control = 1
else
  SV_Auto_Control = 0
end

------------------------------------------------------------------------- 
--Determine if Comp Discharge Pressure needs to Override Primary Control
------------------------------------------------------------------------- 

if SV_Auto_Control == 1 then
  if PT_102 < Dis_Press_Low_DB_SP or PT_102 > Dis_Press_High_DB_SP then
    Override = 1
  else
    Override = 0
  end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------ 
-- Determine Auto Loading/Unloading Based on Differential Pressure Calculation, Differential Pressure Setpoint, and Differential Pressure Control Deadband  
-- Override Control Auto Loading/Unloading Based on Discharge Pressure, Discharge Pressure Setpoint, and Diischarge Pressure Control Deadband
------------------------------------------------------------------------------------------------------------------------------------------------------------ 

if Man_Mode == 0 and SV_Auto_Control == 1 then
  if Override == 0 then
    if DiffPress > DiffPress_Low_DB_SP and DiffPress < DiffPress_High_DB_SP then 
      Pri_At_SP = 1
    else
      Pri_At_SP = 0
    end

    if DiffPress < DiffPress_Low_DB_SP then 
      Pri_Unload_req = 1
    else
      Pri_Unload_req = 0
    end

    if DiffPress > DiffPress_High_DB_SP then 
      Pri_Load_req = 1
    else
      Pri_Load_req = 0
    end

  else

    if PT_102 > Dis_Press_Low_DB_SP and PT_102 < Dis_Press_High_DB_SP then
      Sec_At_SP = 1
    else
      Sec_At_SP = 0
    end 

    if PT_102 > Dis_Press_High_DB_SP then
      Sec_Unload_req = 1
    else
      Sec_Unload_req = 0
    end 

    if PT_102 < Dis_Press_Low_DB_SP then
      Sec_Load_req = 1
    else
      Sec_Load_req = 0
    end 
  end
end

if Man_Mode == 1 or SV_Auto_Control == 0 then
  Pri_At_SP = 0
  Pri_Unload_req = 0
  Pri_Load_req = 0
  Sec_At_SP = 0
  Sec_Unload_req = 0
  Sec_Load_req = 0
end


----------------------------------------------------------
--Load Slide Valve, XY_101 and XY_102 (T1:DO1 and T1:DO2)
--Unload Slide Valve, XY_103 and XY_104 (T1:DO3 and T1:DO4)
--No Position Input
----------------------------------------------------------

local do1Pos = tonumber(get_sGbl("do1Pos",0)) -- Load Slide Valve
local do3Pos = tonumber(get_sGbl("do3Pos",0)) -- Unload Slide Valve

-- XY-102 Follows XY-101, XY-104 Follows XY-103
set_do_val(1,2,XY_101_DO)
set_do_val(1,4,XY_103_DO)

-----------------------------------------------------
--Slide Valve Control - Auto
-----------------------------------------------------

-- Auto Unloading Before Compressor Running

if State >= 0 and State < 7 then
	if do1Pos > 0 or do3Pos > 0 then
		set_do_val(1,1,0)
		set_do_val(1,3,0)
		set_sGbl("do1Pos",0)
		set_sGbl("do3Pos",0)
    local sw_tmr_0 = get_time()
	else
		local sw = tonumber(get_sGbl("slide_wait",0))
		if sw > 0 then
			sw = Unload_Valve_Off_Time - (get_time() - sw_tmr_0)
			set_sGbl("slide_wait",sw)
		else
			set_sGbl("do3Pos",1)
			set_do_pulse(1,3,Unload_Valve_On_Time)
			set_do_val(1,3,1)
			set_sGbl("slide_wait",Unload_Valve_Off_Time)
    end
	end
end

-- Auto Unloading When Stopping

if State >= 9 then
	if do1Pos > 0 or do3Pos > 0 then
		set_do_val(1,1,0)
		set_do_val(1,3,0)
		set_sGbl("do1Pos",0)
		set_sGbl("do3Pos",0)
    local sw_tmr_0 = get_time()
	else
		local sw = tonumber(get_sGbl("slide_wait",0))
		if sw > 0 then
			sw = Unload_Valve_Off_Time - (get_time() - sw_tmr_0)
			set_sGbl("slide_wait",sw)
		else
			set_sGbl("do3Pos",1)
			set_do_pulse(1,3,Unload_Valve_On_Time)
			set_do_val(1,3,1)
			set_sGbl("slide_wait",Unload_Valve_Off_Time)
    end
	end
end

--Auto Control Based On Differential Pressure (Primary) or Comp Discharge Pressure (Secondary)

if SV_Auto_Control == 1 then
  if Pri_At_SP == 1 or Sec_At_SP == 1 then -- Slide Valve Idle State
    set_do_val(1,1,0)
    set_do_val(1,3,0)
    set_sGbl("do1Pos",0)
    set_sGbl("do3Pos",0)
  end
  if Pri_Unload_req == 1 or Sec_Unload_req == 1 then -- Slide Valve Unload
    if do1Pos > 0 or do3Pos > 0 then
      set_do_val(1,1,0)
      set_do_val(1,3,0)
      set_sGbl("do1Pos",0)
      set_sGbl("do3Pos",0)
      local sw_tmr_0 = get_time()
    else
      local sw = tonumber(get_sGbl("slide_wait",0))
      if sw > 0 then
        sw = Unload_Valve_Off_Time - (get_time() - sw_tmr_0)
        set_sGbl("slide_wait",sw)
      else
        set_sGbl("do3Pos",1)
        set_do_pulse(1,3,Unload_Valve_On_Time)
        set_do_val(1,3,1)
        set_sGbl("slide_wait",Unload_Valve_Off_Time)
      end
    end
  end
  if Pri_Load_req == 1 or Sec_Load_req == 1 then -- Slide Valve Load
    if do1Pos > 0 or do3Pos > 0 then
      set_do_val(1,1,0)
      set_do_val(1,3,0)
      set_sGbl("do1Pos",0)
      set_sGbl("do3Pos",0)
      local sw_tmr_0 = get_time()
    else
      local sw = tonumber(get_sGbl("slide_wait",0))
      if sw > 0 then
        sw = Unload_Valve_Off_Time - (get_time() - sw_tmr_0)
        set_sGbl("slide_wait",sw)
      else
        set_sGbl("do1Pos",1)
        set_do_pulse(1,1,Load_Valve_On_Time)
        set_do_val(1,1,1)
        set_sGbl("slide_wait",Load_Valve_Off_Time)
      end
    end
  end
end


-----------------------------------------------------
--Slide Valve Control - Manual
-----------------------------------------------------

if Man_Mode == 1 then
  if Fast_Load_PB == 0 then
    if do1Pos > 0 or do3Pos > 0 then
      set_do_val(1,1,0)
      set_do_val(1,3,0)
      set_sGbl("do1Pos",0)
      set_sGbl("do3Pos",0)
      local sw_tmr_0 = get_time()
    else
      local sw = tonumber(get_sGbl("slide_wait",0))
      if sw > 0 then
        sw = Unload_Valve_Off_Time - (get_time() - sw_tmr_0)
        set_sGbl("slide_wait",sw)
      else
        set_sGbl("do1Pos",1)
        set_do_pulse(1,1,Fast_Load_Valve_On_Time)
        set_do_val(1,1,1)
        set_sGbl("slide_wait",Fast_Load_Valve_Off_Time)
      end
    end
  end
  if Fast_Unload_PB == 0 then
    if do1Pos > 0 or do3Pos > 0 then
      set_do_val(1,1,0)
      set_do_val(1,3,0)
      set_sGbl("do1Pos",0)
      set_sGbl("do3Pos",0)
      local sw_tmr_0 = get_time()
    else
      local sw = tonumber(get_sGbl("slide_wait",0))
      if sw > 0 then
        sw = Unload_Valve_Off_Time - (get_time() - sw_tmr_0)
        set_sGbl("slide_wait",sw)
      else
        set_sGbl("do3Pos",1)
        set_do_pulse(1,3,Fast_Unload_Valve_On_Time)
        set_do_val(1,3,1)
        set_sGbl("slide_wait",Fast_Unload_Valve_Off_Time)
      end
    end
  end
end


--***************************************************
--END of Slide Valve Control
--***************************************************