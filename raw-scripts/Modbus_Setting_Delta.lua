

-- Modbus Script Functions
local Input6 = get_channel_val(1,6)
local Input7 = get_channel_val(1,7)

local Diff = Input7 - Input6
set_modbus(60002,Diff) -- Register is 460002

defaultModbus()


--[[ This is all done in the modbus script, take any channels and get the values, then do the math and put back into an unused register.
]]

