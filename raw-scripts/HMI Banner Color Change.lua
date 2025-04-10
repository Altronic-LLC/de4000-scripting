
-- Example using RPM

if get_rpm(1) > 100 then
    set_sVirt("statusLCDBackgroundColorOverride", "#3335E3")
else
    set_sVirt("statusLCDBackgroundColorOverride", "")
end
