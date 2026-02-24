if not firstscan then
    firstscan = 1
    set_sVirt("ChannelInput",0)
end

local function scaleNumber(num)
    local intPart, fracPart = math.modf(num)
    return (intPart * 10) + fracPart
end

set_channel_val(1,26,get_sVirt("ChannelInput",0))


local Calc = scaleNumber(get_channel_val(1,26))

set_sVirt("Flow Meter",Calc)


-----------------------------------------
-- Flow Meter With Scaling
-----------------------------------------
local function scaleNumber(num)
    local intPart, fracPart = math.modf(num)
    return (intPart * 10) + fracPart
end

local Calc = scaleNumber(get_channel_val(1,26))
set_sVirt("Flow Meter",Calc.." SCMD")