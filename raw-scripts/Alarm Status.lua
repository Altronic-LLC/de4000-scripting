



-- check if system has any active alarms currently
local Alarms_Active = get_alarm_status()








-- Check alarms on system
function CheckAlarms()
	local Num_Of_Boards = get_gbl("NumTerm",0)
	for termIndex = 1, Num_Of_Boards do -- Number of terminal boards
		for chIndex = 1, 32 do -- Number of channels on the boards
		local alarmval = get_channel_alarm(termIndex, chIndex) -- 0 = No Alarm, 1=Low Alarm, 2=High Alarm

		if alarmval > 0 then
			return alarmval, termIndex, chIndex
		end
		end
	end

	return nil
end


local Alarm_High_Low, Alarm_Terminal, Alarm_Channel = CheckAlarms()
if Alarm_High_Low then
  set_sVirt("Total",Alarm_High_Low..","..Alarm_Terminal..","..Alarm_Channel)
  set_sVirt("_Alarm_High_Low",Alarm_High_Low)
  set_sVirt("_Alarm_Terminal",Alarm_Terminal)
  set_sVirt("_Alarm_Channel",Alarm_Channel)
else
  set_sVirt("Total","No Alarms")
end


-- Modbus Script Functions
function setModbusVirt(param,val)         
    redis.call("append","gbl_str","v_"..param.."~"..val.."~")
end

function get_private(key,def)
  local val = redis.call("hget","priv",key)
  if tostring(val) == 'nil' and tostring(def) ~= 'nil' then
    return def
  end
  return totype(val)
end

    --To Redlion
 -- Alarm High or Low
set_modbus(60000,get_private("_Alarm_High_Low",0)) --Modbus Reg = 460,000
 -- Alarm Terminal Board
set_modbus(60002,get_private("_Alarm_Terminal",0)) --Modbus Reg = 460,002
 -- Alarm Channel Number
set_modbus(60004,get_private("_Alarm_Channel",0)) --Modbus Reg = 460,004

defaultModbus()