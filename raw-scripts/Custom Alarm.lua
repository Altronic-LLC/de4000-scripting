    -- Custom Alarms
function CustomAlarmLogging(Name,Alarm_Active,Alarm_Oneshot)
  local Alarm_OneShot_Input = Alarm_Oneshot
  local Alarm_Active_Input = Alarm_Active
  if Alarm_OneShot_Input == 1 then 
    if Alarm_Active_Input ~= get_sVirt("_"..Name.."_Cmd_Last") then 
      set_sVirt("_"..Name.."_Output",Alarm_Active_Input)
      set_sVirt("_"..Name.."_Cmd_Last",Alarm_Active_Input)
      set_sVirt("ERCMCustomAlarm",Name) 
    end
  else
    if Alarm_Active_Input ~= get_sVirt("_"..Name.."_Cmd_Last") then 
      set_sVirt("_"..Name.."_Output",Alarm_Active_Input)
      set_sVirt("_"..Name.."_Cmd_Last",Alarm_Active_Input)
      if Alarm_Active_Input == 1 then 
        set_sVirt("ERCMCustomAlarm",Name) 
      else
        set_sVirt("ERCMCustomAlarm",Name.." Cleared") 
      end
    end
  end
end