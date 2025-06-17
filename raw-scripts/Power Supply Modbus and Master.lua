
-- Modbus Script Functions
function setModbusVirt(param,val)         
    redis.call("append","gbl_str","v_"..param.."~"..val.."~")
end

function get_ps_val(term)
  return tonumber(redis.call("hget","s:t"..term..":ps" ,"Val"))
end

local psv = get_ps_val(1)
setModbusVirt("_TB_Power_Supply_Volts",psv*100)
set_modbus(320, psv*100)




-- Master Script
-- Power Supply
if not TB_PS_FS then
    TB_PS_FS = 1
    create_param("Power_Supply_Low_Voltage",23,"Power Supply Voltage","Enter The Low Voltage For The Power Supply To Alarm")
end

local Power_Supply_Low_Voltage = get_param("Power_Supply_Low_Voltage",23)
local TB_Power_Supply = tonumber(get_sVirt("_TB_Power_Supply_Volts",0)) / 100
local TB_Power_Supply_Formatted = string.format("%.1f", TB_Power_Supply)

if TB_Power_Supply < Power_Supply_Low_Voltage then 
    set_sVirt("Power_Supply_Voltage",TB_Power_Supply_Formatted.." LOW(#E2F40A)") -- Yellow
else
    set_sVirt("Power_Supply_Voltage",TB_Power_Supply_Formatted.." OKAY(#58FF33)") -- Green
end