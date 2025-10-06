















function CheckToggle_Mode(Name,Enable_Manual)
	-- Manual Control 
	if not get_sVirt("_"..Name.."_FS") then
        set_sVirt("_"..Name.."_FS",1)
        set_sVirt(Name.."_Mode","Auto")
    end

	checkToggle(Name.."_Mode","Auto","Manual")
	if Enable_Manual == 0 then set_sVirt(Name.."_Mode","Auto") end
		
	if get_sVirt(Name.."_Mode") == "Manual" then
		if get_sVirt(Name.."_Manual_POSBump",0) ~= 0 then
		local si = 5
		local Position = get_sVirt(Name.."_Manual_POS",0)
		Position = Position + (si * get_sVirt(Name.."_Manual_POSBump",0))
		set_sVirt(Name.."_Manual_POS",tostring(math.floor(Position)))
		set_sVirt(Name.."_Manual_POSBump",0)
		end
	else 
		set_sVirt(Name.."_Manual_POSBump",0)
	end

	if get_sVirt(Name.."_Manual_POS",0) >= 100 then set_sVirt(Name.."_Manual_POS",100) end
	if get_sVirt(Name.."_Manual_POS",0) <= 0 then set_sVirt(Name.."_Manual_POS",0) end
end


CheckToggle_Mode("Recycle_Valve",1)