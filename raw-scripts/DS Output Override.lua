
function DS_Output_Control(DS1,DS2,DS3,DS4)
  local State = get_state()
	local DS_ON = get_gbl("state"..State.."onChans")  -- e.g., "1,3,4"
	local DS_OFF = get_gbl("state"..State.."offChans")  -- e.g., "1,3,4"
	local StatesOn = {}
	local StatesOff = {}


  if State == 0 then DS_ON = "0,0,0,0" DS_OFF = "1,2,3,4" end

  set_sVirt("DS_ON",DS_ON)
  set_sVirt("DS_OFF",DS_OFF)


	-- Split string into numbers
	for val in string.gmatch(DS_ON, "%d+") do
	  table.insert(StatesOn, tonumber(val))
	end

	for val in string.gmatch(DS_OFF, "%d+") do
	  table.insert(StatesOff, tonumber(val))
	end

	-- Check if DS1 is in the list
	for _, v in ipairs(StatesOn) do
		if v == 1 then
			DS1_Master_State = true
			break
		end
	end

	for _, v in ipairs(StatesOff) do
		if v == 1 then
			DS1_Master_State = false
			break
		end
	end

	-- Check if DS2 is in the list
	for _, v in ipairs(StatesOn) do
		if v == 2 then
			DS2_Master_State = true
			break
		end
	end

	for _, v in ipairs(StatesOff) do
		if v == 2 then
			DS2_Master_State = false
			break
		end
	end

		-- Check if DS3 is in the list
	for _, v in ipairs(StatesOn) do
		if v == 3 then
			DS3_Master_State = true
			break
		end
	end

	for _, v in ipairs(StatesOff) do
		if v == 3 then
			DS3_Master_State = false
			break
		end
	end

		-- Check if DS3 is in the list
	for _, v in ipairs(StatesOn) do
		if v == 4 then
			DS4_Master_State = true
			break
		end
	end

	for _, v in ipairs(StatesOff) do
		if v == 4 then
			DS4_Master_State = false
			break
		end
	end

	if DS1 == 1 then set_ctrl_do_override(1,1) set_ctrl_do(1,1) else set_ctrl_do_override(1,0) set_ctrl_do(1,0) end
	if DS2 == 1 then set_ctrl_do_override(2,1) set_ctrl_do(2,1) else set_ctrl_do_override(2,0) set_ctrl_do(2,0) end
	if DS3 == 1 then set_ctrl_do_override(3,1) set_ctrl_do(3,1) else set_ctrl_do_override(3,0) set_ctrl_do(3,0) end
	if DS4 == 1 then set_ctrl_do_override(4,1) set_ctrl_do(4,1) else set_ctrl_do_override(4,0) set_ctrl_do(4,0) end
end

--Here is the test script code
function set_ctrl_do_override(ch, val)
    set_sVirt("ctrl_do_override" .. ch, val)
    if tonumber_def(get_sGbl("redis_ctrl"),0) ~= 1 then
      set_ctrl_do_val(ch,val)
    end
end


function set_ctrl_do(ch,val)
  if tonumber_def(get_sVirt("ctrl_do_override" .. ch, 2) ~= 2) then
    if tonumber_def(get_sGbl("redis_ctrl"),0) ~= 1 then
      set_ctrl_do_val(ch,val)
    end
  end
end


set_sVirt("DS1_Master_State",DS1_Master_State)
set_sVirt("DS2_Master_State",DS2_Master_State)
set_sVirt("DS3_Master_State",DS3_Master_State)
set_sVirt("DS4_Master_State",DS4_Master_State)

if DS1_Master_State == true then DS1_Master_Control = 1 else DS1_Master_Control = 0 end
if DS2_Master_State == true then DS2_Master_Control = 1 else DS2_Master_Control = 0 end
if DS3_Master_State == true then DS3_Master_Control = 1 else DS3_Master_Control = 0 end
if DS4_Master_State == true then DS4_Master_Control = 1 else DS4_Master_Control = 0 end

if get_state() == 5 then 
	if get_time() - Statetmr > 10 then 
		DS1_Master_Control = 0
		DS2_Master_Control = 0
		DS3_Master_Control = 0
		DS4_Master_Control = 0
	else
		DS1_Master_Control = 1
		DS2_Master_Control = 1
		DS3_Master_Control = 1
		DS4_Master_Control = 1
	end
else
	Statetmr = get_time()
end

DS_Output_Control(DS1_Master_Control,DS2_Master_Control,DS3_Master_Control,DS4_Master_Control)

set_sVirt("State",get_state())