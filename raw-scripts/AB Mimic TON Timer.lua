

if not FirstScan then
  FirstScan = 1
  set_sVirt("Andrew Enable",0)
  --timer = {accum = 0, done = false, enable = false, last_time = os.clock() * 1000}

end

function TON(timer_name, enable, preset_ms, return_Type)
    -- Load existing state or create it if it doesn't exist
    local Preset_ms = preset_ms * 1000
    local timer = get_sVirt(timer_name .. "_table", nil)
    if not timer then
        timer = {accum = 0, done = false, enable = false, last_time = os.clock() * 1000, timer_timing = 0} 
    end

    local now = os.clock() * 1000 -- ms
    local dt = now - (timer.last_time or now)
    timer.last_time = now

    if enable == 1 then
        if not timer.enable then
            timer.accum = 0 -- rising edge reset
        end
        timer.accum = math.min(timer.accum + dt, preset_ms)
        timer.done = (timer.accum >= preset_ms)
        timer.enable = true
        timer.timing = (timer.accum < preset_ms) and 1 or 0
    else
        timer.accum = 0
        timer.done = false
        timer.enable = false
        timer.timing = 0
    end

    -- SAVE the timer table back to persistent storage
    set_sVirt(timer_name .. "_table", timer)

    -- Optional: store ACC, DN, EN as separate variables
    set_sVirt(timer_name.."_Accum", timer.accum)
    set_sVirt(timer_name.."_Done", timer.done)
    set_sVirt(timer_name.."_Enable", timer.enable)
    set_sVirt(timer_name.."_Timing", timer.timing)
    
    return timer.done
end

local Andrew_Enable = get_sVirt("Andrew Enable",0)
local Andrew_Trial2 = TON("AndrewTimer2",Andrew_Enable,20000)
set_sVirt("Timer3",Andrew_Trial2)



if Andrew_Enable == 0 then set_sVirt("Timer Message","OFF") end

if get_sVirt("AndrewTimer2_Timing",0) == 1 then set_sVirt("Timer Message","Timing") end
  

if Andrew_Trial2 == true then set_sVirt("Timer Message","Finshed") end






