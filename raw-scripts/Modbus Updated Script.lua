--***********************-----------------------------***********************
-- Modbus Fault Logic for additional registers
--***********************-----------------------------***********************
setmetatable(_G, nil)

mb_retStr = ""
mb_node = redis.call("hget","gbl","ModbusAddr")
if not tonumber(mb_node) then
    return 0
end

mb_NumTerm = tonumber(redis.call("hget","gbl","NumTerm"))
if not mb_NumTerm then mb_NumTerm = 1 end
mb_callString = {}
mb_modString = {}
table.insert(mb_callString,"hmget")
table.insert(mb_callString,"vals")
for mb_term = 1,mb_NumTerm do
    for lpIndex = 1,32 do
    table.insert(mb_callString,"t"..mb_term..":in"..lpIndex)
    end
end
mb_sTab = redis.call(unpack(mb_callString))
table.insert(mb_modString,"hmset")
table.insert(mb_modString,"mod4")
mb_node = redis.call("hget","gbl","ModbusAddr")
mb_tabCount = #mb_sTab
for lpIndex = 1,mb_tabCount do
  mb_v = tonumber(mb_sTab[lpIndex])
  if not mb_v then
      mb_v = 0
  end
  table.insert(mb_modString,"n"..mb_node.."a"..(88 + lpIndex))
  table.insert(mb_modString,math.floor(tonumber(mb_v)))
  if math.floor(tonumber(mb_v)) == 24 then
      mb_termNum = math.floor(lpIndex / 32) + 1
      mb_chanNum = math.floor(lpIndex - ((mb_termNum - 1) * 32))
      mb_statVal = redis.call("hget","s:t"..mb_termNum..":in"..mb_chanNum,"Val")
      mb_psVal = redis.call("hget","s:t"..mb_termNum..":ps","Val")
      mb_retStr = "lpIndex: "..lpIndex.." "..mb_v.." sTabCount: "..mb_tabCount.." statVal: "..mb_statVal.." psVal: "..mb_psVal
  end
end
redis.call(unpack(mb_modString))
set_modbus(250,math.floor(get_rpm(1) + 0.5))
set_modbus(251,math.floor(get_rpm(2) + 0.5))
set_modbus(252,math.floor(get_rpm(3) + 0.5))
set_modbus(253,math.floor(get_rpm(4) + 0.5))
set_modbus(254,math.floor(get_rpm(5) + 0.5))
set_modbus(255,math.floor(get_rpm(6) + 0.5))
set_modbus(256,math.floor(get_rpm(7) + 0.5))
set_modbus(257,math.floor(get_rpm(8) + 0.5))
set_modbus(258,math.floor(get_rpm(9) + 0.5))
set_modbus(259,math.floor(get_rpm(10) + 0.5))

mb_status = 0
mb_status2 = 0
mb_ff = redis.call("hmget","firstFault","flag","channel","type","ChTyp","terminal","value","fault_string","state")
mb_faultFlag = tonumber(mb_ff[1]) or 0
mb_faultChannel = tonumber(mb_ff[2]) or 0
mb_faultType = tonumber(mb_ff[3]) or 0
mb_faultChType = tonumber(mb_ff[4]) or 0
mb_faultTerm = tonumber(mb_ff[5]) or 0
mb_faultValue = tonumber(mb_ff[6]) or 0
mb_faultString = mb_ff[7]
mb_faultState = tonumber(mb_ff[8]) or 0

--CODE FOR ORIGINAL STATUS REGISTER
mb_faultLoHi = 0
if mb_faultFlag == 1 then
  if (mb_faultChType == 1 or mb_faultChType == 3) and mb_faultChannel > 0 then --analog channel fault
      if mb_faultTerm > 0 then
      mb_status = (mb_faultTerm - 1) * 32 + mb_faultChannel
      mb_status2 = mb_status
      end
  else
      if mb_faultType >= 3 then
          mb_status = 160 + mb_faultType
          if mb_status > 253 then
          mb_status = 253
          end
      end
  end

  set_modbus(12,math.floor(mb_faultTerm))
  set_modbus(13,math.floor(mb_faultChannel))
  set_modbus(14,math.floor(mb_faultType))
  set_modbus(15,math.floor(mb_faultChType))
  set_modbus(16,math.floor(mb_faultValue))

  if mb_faultChType == 2 then --speed fault
    if mb_faultTerm == 1 and mb_faultChannel == 1 then mb_status = 161 end
    if mb_faultTerm == 1 and mb_faultChannel == 2 then mb_status = 162 end
    if mb_faultTerm == 2 and mb_faultChannel == 1 then mb_status = 163 end
    if mb_faultTerm == 2 and mb_faultChannel == 2 then mb_status = 164 end
    if mb_faultTerm == 3 and mb_faultChannel == 1 then mb_status = 165 end
    if mb_faultTerm == 3 and mb_faultChannel == 2 then mb_status = 166 end
    if mb_faultTerm == 4 and mb_faultChannel == 1 then mb_status = 167 end
    if mb_faultTerm == 4 and mb_faultChannel == 2 then mb_status = 168 end
    if mb_faultTerm == 5 and mb_faultChannel == 1 then mb_status = 169 end
    if mb_faultTerm == 5 and mb_faultChannel == 2 then mb_status = 170 end
  end
  if mb_faultType == 1 then mb_faultLoHi = 1 end
  if mb_faultType == 2 then mb_faultLoHi = 2 end
  else
  if get_state() > 0 then
      mb_status = 255
  end
  if mb_status == 255 and get_timers_active() > 0   then
      mb_status = 254
  end
end

--CODE FOR NEW STATUS REGISTER
if mb_faultFlag == 1 then
  if (mb_faultChType == 1 or mb_faultChType == 2 or mb_faultChType == 3) and mb_faultChannel > 0 then --channel fault (analog, discrete or speed)
    if mb_faultChType == 2 then --fault channel is RPM channel
      mb_faultChannel = mb_faultChannel + 40 --RPM channels start at 41
    end
    if mb_faultLoHi == 2 then --for high faults we add 50 to the channel number
      mb_faultChannel = mb_faultChannel + 50
    end
    if mb_faultTerm == 0 then
      mb_faultTerm = 1
    end
    mb_status2 = mb_faultTerm * 100 + mb_faultChannel
  else
    mb_bits = 0
    mb_customFault = 0
    if mb_faultString:find("System Unlocked") then
      mb_faultType = 16
    end
    if mb_faultString:find("Attempted Start with RPM") then
      mb_faultType = 7
    end
    if mb_faultString:find("Cooldown Complete") then
      mb_faultType = 17
    end
    if mb_faultString:find("- Auto-Restart Cancelled") then
      mb_faultType = 11
    end
    if mb_faultString:find("Lube No Flow") then
      mb_faultType = 8
    end
    if mb_faultString:find("HSC TRIPPED") then
      mb_faultType = 260
    end
    if mb_faultString:find("Internal Fault") then
      mb_faultType = 22
    end
    if mb_faultString:find("Internal Fault(run)") then
      mb_faultType = 23
    end
    if mb_faultString:find("Power Up") then
      mb_faultType = 18
    end
    if mb_faultString:find("PowerFail") then
      mb_faultType = 19
    end
    if mb_faultString:find("WATCHDOG") then
      mb_faultType = 20
    end
    if mb_faultString:find("WATCHDOG (soft)") then
      mb_faultType = 21
    end
    mb_matchCode = tonumber(mb_faultString:match("Terminal Board (%d+) HSC"))
    if mb_matchCode then
      mb_faultType = 260 + mb_matchCode
    end

    mb_matchCode = tonumber(mb_faultString:match("NO COMM FROM TERM: (%d+)"))
    if mb_matchCode then
      mb_faultType = 270 + mb_matchCode
    end

    mb_matchCode = tonumber(mb_faultString:match("Terminal Board (%d+) Missing"))
    if mb_matchCode then
      mb_faultType = 280 + mb_matchCode * mb_faultState
    end


    if mb_faultString:find("Timeout A") then
      mb_faultType = 300 + mb_faultState * 2
    end

    if mb_faultString:find("Timeout B") then
      mb_faultType = 300 + mb_faultState * 2 + 1
    end


    if mb_faultString:find("Permissive not met in State 0") then
      mb_faultType = 300
    end


    if mb_faultString:find("Low Differential") then
      mb_faultType = 340
    end

    if mb_faultString:find("High Differential") then
      mb_faultType = 360
    end


    if mb_faultType == 9 then
      mb_bits = mb_faultTerm * 256 + mb_faultChannel
      mb_status2 = bit.band(mb_bits, 0x3FFF) --mask off bits 15 and 16 so that we can use those bits to represent system fault (bit 15 set) vs custom fault (bit 16 set)
      mb_status2 = mb_status2 + 32768 -- set bit 16 for custom fault
    else
      if mb_faultType == 24 then -- ERCM fault
        mb_bits = mb_faultTerm * 256 + mb_faultChannel
        if mb_bits > 1000 then
          mb_bits = 1000
        end
        mb_bits = mb_bits + 1000 -- set bit 16 for custom fault
        mb_status2 = bit.band(mb_bits, 0x3FFF) --mask off bits 15 and 16 so that we can use those bits to represent system fault (bit 15 set) vs custom fault (bit 16 set)
        mb_status2 = mb_status2 + 16384 -- set bit 15 for system fault
      else
        mb_bits = mb_faultType
        mb_status2 = bit.band(mb_bits, 0x3FFF) --mask of bits 15 and 16 so that we can use those bits to represent system fault (bit 15 set) vs custom fault (bit 16 set)
        mb_status2 = mb_status2 + 16384 -- set bit 15 for system fault
      end
    end
  end
end

if mb_faultFlag == 0 then
  mb_status2 = 0
end

set_modbus(1,get_state())
set_modbus(2,get_hourmeter())
set_modbus(3,get_hourmeter_mins())
set_modbus(4,math.floor(mb_status))
set_modbus(6,math.floor(mb_faultLoHi))
set_modbus(7,math.floor(mb_faultTerm))
set_modbus(8,math.floor(mb_faultChannel))
set_modbus(9,math.floor(mb_faultType))
set_modbus(10,math.floor(mb_faultChType))
set_modbus(11,math.floor(mb_faultValue))
-- get status of DS outputs on Controller
mb_d1 = get_ctrl_do_val(1)
if not mb_d1 then mb_d1 = 0 end
mb_d2 = get_ctrl_do_val(2)
if not mb_d2 then mb_d2 = 0 end
mb_d3 = get_ctrl_do_val(3)
if not mb_d3 then mb_d3 = 0 end
mb_d4 = get_ctrl_do_val(4)
if not mb_d4 then mb_d4 = 0 end
set_modbus(5,(1*mb_d1)+(2*mb_d2)+(4*mb_d3)+(8*mb_d4)) -- set ds outputs to register 5
mb_d5 = nil
mb_d6 = nil
mb_d7 = nil
mb_d8 = nil
for termIndex = 1,5 do -- set DO values starting at register 20 for term #1
  mb_d1 = get_do_val(termIndex,1);
  mb_d2 = get_do_val(termIndex,2);
  mb_d3 = get_do_val(termIndex,3);
  mb_d4 = get_do_val(termIndex,4);
  mb_d5 = get_do_val(termIndex,5);
  mb_d6 = get_do_val(termIndex,6);
  mb_d7 = get_do_val(termIndex,7);
  mb_d8 = get_do_val(termIndex,8);
  set_modbus((19+termIndex),(1*mb_d1)+(2*mb_d2)+(4*mb_d3)+(8*mb_d4)+(16*mb_d5)+(32*mb_d6)+(64*mb_d7)+(128*mb_d8))
end
set_modbus(17,mb_status2)
set_modbus(18,mb_faultFlag)
mb_chInc = 0
for termIndex = 1,5 do
  for chIndex = 1,4 do
    set_modbus(260+mb_chInc,get_ao_val(termIndex,chIndex))
    mb_chInc = mb_chInc + 1
  end
end
return mb_retStr