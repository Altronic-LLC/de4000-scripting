











function truncate(num, decimals)
    local factor = 10 ^ decimals
    return math.floor(num * factor) / factor
end

local Var = 12.158896349451616

local debug1 = truncate(Var, 1) -- Give you 1 decimal place = 12.1
local debug2 = truncate(Var, 2) -- two deciaml places = 12.15
local debug3 = truncate(Var, 3) -- three decimal places = 12.158

set_sVirt("debug1","_"..(math.floor((debug1+0.000005) * 10000) )/10000) -- Four Decimal Places
set_sVirt("debug2","_"..(math.floor((debug2+0.000005) * 10000) )/10000) -- Four Decimal Places
set_sVirt("debug3","_"..(math.floor((debug3+0.000005) * 10000) )/10000) -- Four Decimal Places