
if not FirstScan then
    FirstScan = 1
    create_param("Hour_Meter_Offset",50,"Hour Meter Configuration","Enter The Value To offset the hour meter to custom time")
end

local Hour_Meter_Offset = get_param("Hour_Meter_Offset",50)
set_sVirt("Hour Meter", get_sVirt("hourmeter",0) + Hour_Meter_Offset)