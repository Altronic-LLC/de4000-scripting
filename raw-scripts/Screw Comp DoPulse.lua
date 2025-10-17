


if not firstscan then
	firstscan = 1
	set_sVirt("Debug1",250)
	set_sVirt("Debug2",2000)

	set_sVirt("Debug_Input",20)
	set_sVirt("Debug_Sepoint",10)
end


local Ontime = get_sVirt("Debug1",25) 
local Offtime = get_sVirt("Debug2",5000) / 1000 -- Turn into milliseconds
local DeadBand = 1
local Slide_Valve_Idle_Position = get_sVirt("Debug_Sepoint",10)
local Slide_Valve_Position = get_sVirt("Debug_Input",20)

	-- Screw Compressor Code with Do_Pulse
function SlideValveDoPulse(Target_Pos, Input, DO_Num_Load, DO_Num_Unload, On_Pulse_Time, Wait_Time, Deadband, Release_State)
    -- Initialize pulse state if not set
    if not get_sVirt("_Pulse_Num"..DO_Num_Load..DO_Num_Unload.."_FS") then
        set_sVirt("_Pulse_Num"..DO_Num_Load..DO_Num_Unload.."_FS", 1)
        set_sVirt("Pulse_Num"..DO_Num_Load..DO_Num_Unload.."_Tmr", 0)
		get_sGbl("do"..DO_Num_Load.."Pos", 1)
		get_sGbl("do"..DO_Num_Unload.."Pos", 1)
    end

    local err = Input - Target_Pos 
	if get_state() < Release_State then err = -10 end
	set_sVirt("err",err)
    local DO_Pulse_Load_Output = get_sGbl("do"..DO_Num_Load.."Pos", 0)
    local DO_Pulse_UnLoad_Output = get_sGbl("do"..DO_Num_Unload.."Pos", 0)
	local Wait_Time = Wait_Time / 1000
    -- If output is currently ON, turn it off and reset timer
    if DO_Pulse_Load_Output > 0 or DO_Pulse_UnLoad_Output > 0 then
        set_do_val(1, DO_Num_Load, 0)
        set_do_val(1, DO_Num_Unload, 0)
        set_sGbl("do"..DO_Num_Load.."Pos", 0)
        set_sGbl("do"..DO_Num_Unload.."Pos", 0)
        set_sVirt("Pulse_Num"..DO_Num_Load..DO_Num_Unload.."_Tmr", get_time())
    else
        local elapsed = get_time() - get_sVirt("Pulse_Num"..DO_Num_Load..DO_Num_Unload.."_Tmr", 0)
		set_sVirt("elapsed",elapsed)
		set_sVirt("Wait_Time",Wait_Time)
        -- Check if enough time has passed since last pulse
        if elapsed > Wait_Time then
            if err > Deadband then  -- Need adjustment
                set_sGbl("do"..DO_Num_Load.."Pos", 1)
                set_do_pulse(1, DO_Num_Load, On_Pulse_Time)
                set_do_val(1, DO_Num_Load, 1)
                set_sGbl("slide_"..DO_Num_Load.."_wait", get_time())
			elseif err < Deadband then  -- Need adjustment
                set_sGbl("do"..DO_Num_Unload.."Pos", 1)
                set_do_pulse(1, DO_Num_Unload, On_Pulse_Time)
                set_do_val(1, DO_Num_Unload, 1)
                set_sGbl("slide_"..DO_Num_Unload.."_wait", get_time())
            end
        end
    end
end


SlideValveDoPulse(Slide_Valve_Idle_Position, Slide_Valve_Position, 1, 2, Ontime, Offtime, DeadBand,2)



