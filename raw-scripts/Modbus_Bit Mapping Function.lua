


-- this function will replace doing that commented out part.


-- Fault Codes to Redlion
function FaultCodeToBitValue(code,offset)
    local bitIndex = code - offset   -- Use offset if number doesn't start at exactly 0
    if bitIndex >= 0 and bitIndex < 16 then
        return 1 << bitIndex
    else
        return 0
    end
end

local Fault_Code_Status = get_private("_Fault_Code_Status",0)


local Reg1_FaultCode = FaultCodeToBitValue(Fault_Code_Status,5)
set_modbus(60000,Reg1_FaultCode)
local Reg2_FaultCode = FaultCodeToBitValue(Fault_Code_Status,0)
set_modbus(60001,Reg2_FaultCode)




--[[
local Reg1_d1 = (Fault_Code_Status == 5) and 1 or 0
local Reg1_d2 = (Fault_Code_Status == 6) and 1 or 0
local Reg1_d3 = (Fault_Code_Status == 7) and 1 or 0
local Reg1_d4 = (Fault_Code_Status == 8) and 1 or 0

local Reg1_d5 = (Fault_Code_Status == 9) and 1 or 0
local Reg1_d6 = (Fault_Code_Status == 10) and 1 or 0
local Reg1_d7 = (Fault_Code_Status == 11) and 1 or 0
local Reg1_d8 = (Fault_Code_Status == 12) and 1 or 0

local Reg1_d9 = (Fault_Code_Status == 13) and 1 or 0
local Reg1_d10 = (Fault_Code_Status == 14) and 1 or 0
local Reg1_d11 = (Fault_Code_Status == 15) and 1 or 0
local Reg1_d12 = (Fault_Code_Status == 16) and 1 or 0

local Reg1_d13 = (Fault_Code_Status == 17) and 1 or 0
local Reg1_d14 = (Fault_Code_Status == 18) and 1 or 0
local Reg1_d15 = (Fault_Code_Status == 19) and 1 or 0
local Reg1_d16 = (Fault_Code_Status == 20) and 1 or 0

set_modbus(60000,(1*d1)+(2*d2)+(4*d3)+(8*d4)+(16*d5)+(32*d6)+(64*d7)+(128*d8)+(256*d9)+(512*d10)+(1024*d11)+(2048*d12)+(4096*d13)+(8192*d14)+(16384*d15)+(32768*d16))
]]