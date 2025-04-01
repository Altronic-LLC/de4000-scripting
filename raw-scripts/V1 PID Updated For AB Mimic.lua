-- example PID values for tuning P=2.5, I=0.75, D=2

if not FirstScan then
	FirstScan = 1
	set_sVirt("ChannelInput",10)
	set_sVirt("AMax",50)
	set_sVirt("AMin",5)
	set_sVirt("AOverride",-1)
  end
  
  local ChannelInput = get_sVirt("ChannelInput",10)
  local AMax = get_sVirt("AMax",50)
  local AMin = get_sVirt("AMin",5)
  local AOverride = get_sVirt("AOverride",-1)
  
  set_channel_val(1,2,ChannelInput)
  set_gbl("PID1Min",AMin)
  set_gbl("PID1Max",AMax)
  set_sGbl("PID1Override",AOverride)
  
  function doPid(num,inp)
	  -- Set the following keys to control PID behavior
	  local dOnPV = true
	  local pOnPv = true
	  -- END OF SET KEYS
	  local enabled = get_gbl("PID"..num.."Enable",0)
	  if tonumber(enabled) < 1 then
		  return 0
	  end
	  local pidTime = 0
	  if get_epoch_float ~= nil then
		  pidTime = get_epoch_float()
	  else
		  pidTime = os.clock()
	  end
	  local state = get_state()
	  local Kp = tonumber(get_gbl("PID"..num.."PFactor",0))
	  local Ki = tonumber(get_gbl("PID"..num.."IFactor",0))
	  local Kd = tonumber(get_gbl("PID"..num.."DFactor",0))
	  local pidMax = tonumber(get_gbl("PID"..num.."Max",100))
	  local pidMin = tonumber(get_gbl("PID"..num.."Min",0))
	  local inputTerm = tonumber(get_gbl("PID"..num.."InTerm",0))
	  local inputChan = tonumber(get_gbl("PID"..num.."InChan",0))
	  local outputTerm = tonumber(get_gbl("PID"..num.."OutTerm",0))
	  local outputChan = tonumber(get_gbl("PID"..num.."OutChan",0))
	  local deadband = tonumber(get_gbl("PID"..num.."Deadband",0.2))
	  local setpoint = tonumber(get_gbl("PID"..num.."Sp",0))
	  local vSetpoint = get_sVirt("PID"..num.."Sp",0)
	  local lastSetpoint = tonumber(get_sGbl("lastSetpoint"..num,0))
	  local lastOutput = get_sGbl("PID"..num.."Op",0)
	  local lastPidTime = get_sGbl("lastTime"..num,pidTime)
  
	  if not tonumber(vSetpoint) then vSetpoint = setpoint end
	  if vSetpoint ~= setpoint then
		  if setpoint == lastSetpoint then
		  setpoint = vSetpoint
		  set_gbl("PID"..num.."Sp",setpoint)
		  else
		  vSetpoint = setpoint
		  set_gbl("PID"..num.."Sp",setpoint)
		  set_sVirt("PID"..num.."Sp",vSetpoint)
		  end
	  end
	  local pV = inp or tonumber(get_channel_val(inputTerm,inputChan))
	  local pV2 = tonumber(get_sGbl("pV2"..num,0))
	  local pV3 = tonumber(get_sGbl("pV3"..num,0))
	  local err2 = tonumber(get_sGbl("err2"..num,0))
	  local err3 = tonumber(get_sGbl("err3"..num,0))
	  local lastErr = tonumber(get_sGbl("lastErr"..num,0))
	  local outputSum = tonumber(get_sGbl("outputSum"..num,0))
	  local integral = tonumber(get_sGbl("integral"..num,0))
	  local lastIntegral = tonumber(get_sGbl("lastIntegral"..num,0))
	  integral = 0
	  if state == 0 then lastIntegral = 0 end
	  local revact = tonumber(get_gbl("PID"..num.."RevAct",0))
  
	  local override = tonumber(get_sGbl("PID"..num.."Override",-1))
	  if override > 100 then override = 100 end
	  if override == -2 then
		  set_sGbl("PID"..num.."Override",lastOutput)
		  override = lastOutput
	  end
  
	  local err = setpoint - pV
	  local dErr = err - lastErr
	  local dPv =  pV2 - pV
	  local filteredDPv = pV - 2 * pV2 + pV3  --use last 3 values with filtering
	  local filteredErr = err - 2 * err2 + err3
	  local deriv = dPv
	  local proportional =  Kp * dErr
	  if dOnPv == true then --calculate derivative on Process Value otherwise on err
		  deriv = filteredDPv
	  else
		  deriv = -1 * (filteredErr)
	  end
  
	  if pOnPv == true then --calculates proportional on Process Value otherwise on err
		  proportional = Kp * dPv
	  end
  
	  local deltaTime = pidTime - lastPidTime
	  if deltaTime < 0.01 then deltaTime = 0.25 end
	  local output2 = lastOutput
	  --[[
		  This is the velocity form of the PID algorithm from the document https://literature.rockwellautomation.com/idc/groups/literature/documents/wp/logix-wp008_-en-p.pdf
		  u(k)=u(k-1) +Kp*[y(k-1)-y(k)]+Ki*T*[sp-y(k)]+(Kd/T)*[2y(k-1)-y(k)-y(k-2)]
  
		  translation of formula variables to variables used in doPID
		  u(k) = output
		  u(k-1) = output2
		  Kp = Kp
		  y(k) = pV
		  y(k-1) = pV2
		  y(k-2) = pV3
		  Ki = Ki
		  T = time in seconds since last execution (can be fractional) deltaTime
		  sp = current setpoint
		  Kd = Kd
	  --]]--
  
	  local output = 0
	  if revact > 0 then
		output = output2
	  else
      	output = pidMax + (output2 - pidMin)*(pidMin - pidMax)/(pidMax - pidMin)
	  end
  
	  output = output + (proportional)
	  output = output + Ki *  deltaTime * err 
	  output = output - (Kd / deltaTime) * (deriv)
    
	  output = math.max(math.min(output, pidMax), pidMin)
  
	  if revact == 0 then
        output = pidMax + (output - pidMin)*(pidMin - pidMax)/(pidMax - pidMin)
      end

	  if override > -1 then
		output = override
	  end
  
	  lastErr = err
  
	  set_sGbl("lastErr"..num,lastErr)
	  set_sGbl("outputSum"..num,outputSum)
	  set_sGbl("pV2"..num,pV)
	  set_sGbl("pV3"..num,pV2)
	  set_sGbl("err2"..num,lastErr)
	  set_sGbl("err3"..num,err2)
	  set_sGbl("lastTime"..num,pidTime)
	  set_sVirt("PID"..num.."Op",output)
	  set_sVirt("PID"..num.."Sp",setpoint)
	  set_sVirt("PID"..num.."In",pV)
  
	  set_sGbl("PID"..num.."Op",output)
	  set_sGbl("PID"..num.."Sp",setpoint)
	  set_sGbl("PID"..num.."In",actualTemp)
  
	  if not inp then
		  set_ao_val(outputTerm,outputChan,output)
	  else
		  return output
	  end
  end
  

  
  
  
  
  
  
  
  
  
  