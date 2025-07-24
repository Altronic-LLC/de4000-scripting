

function doLinear(num, inp)
  local enabled = get_gbl("LINEAR" .. num .. "Enable", 0)
  if tonumber(enabled) < 1 then
      return 0
  end
 
  local reverseActing = tonumber(get_gbl("LINEAR" .. num .. "RevAct", 0))
  local inputTerm = tonumber(get_gbl("LINEAR" .. num .. "InTerm", 0))
  local inputChan = tonumber(get_gbl("LINEAR" .. num .. "InChan", 0))
  local outputTerm = tonumber(get_gbl("LINEAR" .. num .. "OutTerm", 0))
  local outputChan = tonumber(get_gbl("LINEAR" .. num .. "OutChan", 0))
  local inputMin = tonumber(get_gbl("LINEAR" .. num .. "Min", 0))
  local inputMax = tonumber(get_gbl("LINEAR" .. num .. "Max", 100))
  local outputLow = tonumber(get_gbl("LINEAR" .. num .. "OutLow", 0))
  local outputHigh = tonumber(get_gbl("LINEAR" .. num .. "OutHigh", 100))
  local rampRate = tonumber(get_gbl("LINEAR" .. num .. "RampRate", 0.8))
  local override = tonumber(get_sGbl("LINEAR" .. num .. "Override", -1))
  local lastOutput = tonumber(get_sGbl("LINEAR" .. num .. "lastOutput", 0))
  local inputValue = inp or tonumber(get_channel_val(inputTerm, inputChan))
 
  -- Standard linear control
  local mappedValue = map_range(inputMin, inputMax, inputValue)
 
  if reverseActing == 1 then
    mappedValue = 100 - mappedValue
  end
  local desiredOutput = outputLow + (mappedValue / 100) * (outputHigh - outputLow)

  -- Apply ramp rate
  local currentOutput = lastOutput
  local outputRange = outputHigh - outputLow

 
  local outputValue = desiredOutput
  if math.abs(desiredOutput - currentOutput) <= rampRate then
    outputValue = desiredOutput
  elseif desiredOutput > currentOutput then
    outputValue = currentOutput + rampRate
  else
    outputValue = currentOutput - rampRate
  end

 
  -- Ensure output is within bounds
  --outputValue = math.max(outputLow, math.min(outputHigh, outputValue))
 
  if override > -1 then
    if override > 100 then
       override = 100
    end
    outputValue = override
  end
 
 
  local outputInt = math.floor(outputValue)
  set_sVirt("LINEAR" .. num .. "Op", outputInt)
  set_sVirt("LINEAR" .. num .. "In", math.floor(inputValue))
  set_sGbl("LINEAR" .. num .. "lastOutput", outputValue)
  if not inp then
      set_ao_val(outputTerm, outputChan, outputValue)
  else
      return outputValue
  end
end