

--Modbus Script
-- Areil Smart Compressor Logic
function setModbusVirt(param,val)         
    redis.call("append","gbl_str","v_"..param.."~"..val.."~")
end

local SPN_FLT_1 = tonumber(redis.call("hget","mod4","n10a30272"))
setModbusVirt("_SPN_FLT_1",SPN_FLT_1)

local SPN_FLT_2 = tonumber(redis.call("hget","mod4","n10a30273"))
setModbusVirt("_SPN_FLT_2",SPN_FLT_2)



--Master Script
-- LSW,MSW Unsigned Swapping
function Modbus_Unsigned_LSWMSW(Name,Register1,Register2)
    --change signed to unsigned
    if Register1 < 0 then 
        Register1 = Register1 + 65536
    end

    if Register2 < 0 then 
        Register2 = Register2 + 65536
    end

    -- Byte swap
    local Swapped_Result = Register2 * 65536 + Register1
    set_sVirt(Name,Swapped_Result)
end

local SPN_FLT_1 = get_sVirt("_SPN_FLT_1",0)
local SPN_FLT_2 = get_sVirt("_SPN_FLT_2",0)

set_sVirt("SPN_FLT_1",SPN_FLT_1)
set_sVirt("SPN_FLT_2",SPN_FLT_2)


Modbus_Unsigned_LSWMSW("SPN_Fault_Result",SPN_FLT_1,SPN_FLT_2)