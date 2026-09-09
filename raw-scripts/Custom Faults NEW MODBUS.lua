
--[[ For eRCM faults if the index number is 22 then the result in Reg 40,017 = 17406
        then if you do 17406 - 17384 = 22. Always subtract away 17384 from Reg 40017 to get the actual eRCM fault code.
]]
    -- Custom Fault Splitting 
function split16(value16)
  local high_byte = math.floor(value16 / 256)
  local low_byte = value16 % 256
  return high_byte, low_byte
end

    -- Custom Fault with spliting value
function custFault(faultString, index)
  local high,low = split16(index)
  customFault(faultString,high,low,9)
end
    -- eRCM Custom Faults with splitting value
function eRCMfault(faultString, index)
  local high,low = split16(index)
  customFault(faultString,high,low,24)
end

if not firstscan then
  	firstscan = 1
    set_sVirt("On",0)
    set_sVirt("Number",22)
end

local On = get_sVirt("On",0)
local number = get_sVirt("Number",22)

if On == 1 then eRCMfault("Andrew Test", number) end
