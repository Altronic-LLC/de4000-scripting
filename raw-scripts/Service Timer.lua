function ServiceMeter(Name,num,Service_Time)
    if not get_sVirt("_"..Name.."_FS") then
        set_sVirt("_"..Name.."_FS",1)
		set_sVirt("Service Needed "..Name,0) -- Need On HMI As LED
		set_sVirt("Service Reset "..Name,0) -- Need On HMI As Input
		set_sVirt("SavedValue "..Name,get_consumption(num))
		Cntdown = get_time()
    end

	local state = get_state()
	local ServiceOp = Service_Time
	local reset = get_sVirt("Service Reset "..Name)

	set_sVirt("Consumption",get_consumption(num))

	if state == 0 then
		set_sVirt("SavedValue "..Name,get_consumption(num))
		set_sVirt("HrsLeft "..Name, ((ServiceOp * 3600) - get_sVirt("SavedValue "..Name)) / 3600) -- Put On HMI Screen As Value
	end

	if state == 7 then 
		Tmr = get_time() 
		set_sVirt("Tmr "..Name,get_time())
	end

	if state == 8 then
		local Cntdown = get_time() - get_sVirt("Tmr "..Name,get_time()) + get_sVirt("SavedValue "..Name)
		set_consumption(num,Cntdown)
		set_sVirt("HrsLeft "..Name, ((ServiceOp * 3600) - Cntdown) / 3600)
	end

	if get_sVirt("HrsLeft "..Name,0) <= 0 then 
		set_sVirt("Service Needed "..Name,1)
	else
		set_sVirt("Service Needed "..Name,0)
	end


	if reset == 1234 then
		set_consumption(num,0)
		set_sVirt("SavedValue "..Name,0)
		set_sVirt("Service Reset "..Name,0)
	else
		set_sVirt("Service Reset "..Name,0)
	end
end

ServiceMeter("Oil",6,.1)