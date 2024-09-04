local rampRate1 = get_gbl("rampRate1",0.8)
local rampRate2 = get_gbl("rampRate2",0.8)
local dischTerm = tonumber_def(get_gbl("spDischTerm",0),0)
local dischChan = tonumber_def(get_gbl("spDischChan",0),0)
local suctTerm = tonumber_def(get_gbl("spSuctTerm",0),0)
local suctChan = tonumber_def(get_gbl("spSuctChan",0),0)
local suctMin = tonumber_def(get_gbl("suctMin",0),0)
local recycleMin = tonumber_def(get_gbl("recycleMin",0),0)
local recycleMax = tonumber_def(get_gbl("recycleMax",0),0)
local suctSp = tonumber_def(get_gbl("suctSp",0),0)
local dischMax = tonumber_def(get_gbl("dischMax",0),0)
local dischSp = tonumber_def(get_gbl("dischSp",0),0)
local outputTerm = tonumber_def(get_gbl("outputTerm",0),0)
local outputChan = tonumber_def(get_gbl("outputChan",0),0)
local recycleTerm = tonumber_def(get_gbl("outputTerm2",0),0)
local recycleChan = tonumber_def(get_gbl("outputChan2",0),0)
local speedRevAct = tonumber_def(get_gbl("speedRevAct",0),0)
local recycleRevAct = tonumber_def(get_gbl("recycleRevAct",0),0)
local outputLow = tonumber_def(get_gbl("outputLow",0),0)
local outputLow2 = tonumber_def(get_gbl("outputLow2",0),0)
local outputHigh = tonumber_def(get_gbl("outputHigh",0),0)
local outputHigh2 = tonumber_def(get_gbl("outputHigh2",0),0)
local spSuctType = get_gbl("spSuctType","linear")
local spDischType = get_gbl("spDischType","linear")
local suctPIDPFactor = tonumber_def(get_gbl("suctPIDPFactor",0),0)
local suctPIDIFactor = tonumber_def(get_gbl("suctPIDIFactor",0),0)
local suctPIDDFactor = tonumber_def(get_gbl("suctPIDDFactor",0),0)
local dischPIDPFactor = tonumber_def(get_gbl("dischPIDPFactor",0),0)
local dischPIDIFactor = tonumber_def(get_gbl("dischPIDIFactor",0),0)
local dischPIDDFactor = tonumber_def(get_gbl("dischPIDDFactor",0),0)

set_sVirt("suctSp",suctSp)

local recycleCtrl = false
local recycleSuctionRev = false
local recycleDischargeRev = false

if recycleChan > 0 and recycleTerm > 0 then
	recycleCtrl = true
end

local dischPct = 100
local suctPct = 100

local Input3_Output = 0
local dischOutput = 0
local suctOutput = 0
local rSuctOutput = 0
local rDischOutput = 0
local minLoad = 0
local maxLoad = 100
local minRecycle = 0
local maxRecycle = 100
local speedTarget = get_sGbl("speedTarget",0)
local recycleTarget = get_sGbl("recycleTarget",0)
  
function map_range(rangeLow,rangeHigh,input)
	if input <= rangeLow and input <= rangeHigh then
		return 0
	end
	if input >= rangeLow and input >= rangeHigh then
		return 100
	end
	local rangeDiff = math.abs(rangeLow - rangeHigh)
	local min = math.min(rangeLow,rangeHigh)
	local retval = math.abs(input - min) / rangeDiff * 100
	if retval > 100 then retval = 100 end
	if retval < 0 then retval = 0 end
	return retval
end
  
local suct = false
local suctVal = 0
if tonumber_def(get_gbl("spSuctEn",0),0) == 1 then
	if suctTerm > 0 and suctChan > 0 then
		suctVal = get_channel_val(suctTerm,suctChan)
		suct = true
	end
end
if suct then
	if spSuctType == "linear" then
		local suctDiff = suctSp - suctMin
		if suctDiff == 0 then suctDiff = 1 end
		if suctVal < suctSp then
			local suctErr = suctSp - suctVal
			suctPct = suctErr / suctDiff
			if suctPct > 1 then suctPct = 1 end
			if suctPct < 0 then suctPct = 0 end
			suctOutput = (1 - suctPct) * 100
		else
			suctOutput = 100
		end
	end
else
	suctOutput = 100
end
  
local disch = false
local dischVal = 0
if tonumber_def(get_gbl("spDischEn",0),0) == 1 then
	if dischTerm > 0 and dischChan > 0 then
		dischVal = get_channel_val(dischTerm,dischChan)
		disch = true
	end
end
if disch then
	if spDischType == "linear" then
		local dischDiff = dischMax - dischSp
		if dischDiff == 0 then dischDiff = 1 end
		if dischVal > dischSp then
			local dischErr = dischVal - dischSp
			dischPct = dischErr / dischDiff
			if dischPct > 1 then dischPct = 1 end
			if dischPct < 0 then dischPct = 0 end
			dischOutput = (1 - dischPct) * 100
		else
			dischOutput = 100
		end
	end
else
	dischOutput = 100
end

local Input3 = false
local Input3Val = 0
local Input3_Term = get_gbl("Input_Term",0)
local Input3_Chan = get_gbl("Input_Chan",0)
local Linear_High_SP = get_gbl("Linear_High_SP",0)
local Linear_Low_SP = get_gbl("Linear_Low_SP",0)
local Input3_Enable = get_gbl("Input3_Enable")

set_sVirt("Linear_High_SP",Linear_High_SP)
set_sVirt("Linear_Low_SP",Linear_Low_SP)
set_sVirt("Input_Term",Input3_Term)
set_sVirt("Input_Chan",Input3_Chan)
set_sVirt("Input3_Enable",Input3_Enable)


if Input3_Enable == 1 then
	Input3Val = get_channel_val(Input3_Term,Input3_Chan)
	Input3 = true
end

if Input3 then
	local Input3_Diff = Linear_High_SP - Linear_Low_SP
	if Input3_Diff == 0 then Input3_Diff = 1 end
	if Input3Val < Linear_High_SP then
		local Input3_Err = Linear_High_SP - Input3Val
		Input3_Pct = Input3_Err / Input3_Diff
		if Input3_Pct > 1 then Input3_Pct = 1 end
		if Input3_Pct < 0 then Input3_Pct = 0 end
		Input3_Output = (1 - Input3_Pct) * 100
	else
		Input3_Output = 100
	end
else
	Input3_Output = 100
end
  
local minOutput = 100

if suctOutput < minOutput then
	minOutput = suctOutput
	set_sVirt("Winning",1)
end

if dischOutput < minOutput then
	minOutput = dischOutput
	set_sVirt("Winning",2)

end

if Input3_Output < minOutput then
	minOutput = Input3_Output
	set_sVirt("Winning",3)

end


local recycleMinOutput = minOutput

local manOutput = 0
	--********************************************************************
local manMode = 0
local manTerm = tonumber_def(get_gbl("manTerm",0),0)
local manChan = tonumber_def(get_gbl("manChan",0),0)
if manTerm > 0 and manChan > 0 then
	local manInput = get_channel_val(manTerm,manChan)
	if manInput > 0.5 then
	manMode = 0
	set_sVirt("SpeedControl","Auto")
	else
	manMode = 1
	set_sVirt("SpeedControl","Manual")
	end
else
	if get_sVirt("SpeedControl","Auto") == "Auto" then
	manMode = 0
	else
	manMode = 1
	end
end

local manSpeed = get_sVirt("ManualSpeed",0)
local idleSpeed = get_gbl("idleSpeed",0)
local lowSpeed = get_gbl("lowSpeed",0)
local highSpeed = get_gbl("highSpeed",0)
local maxSpeed = get_gbl("maxSpeed",0)
local diff = highSpeed - lowSpeed
if diff < 0 then diff = 0 end
local maxDiff = maxSpeed - idleSpeed
if maxDiff < 0 then maxDiff = 0 end

if get_sVirt("speedBump",0) ~= 0 then
	manSpeed = manSpeed + (get_gbl("SpeedIncrement") * get_sVirt("speedBump",0))
	set_sVirt("speedBump",0)
end

if get_sVirt("AutoManBump",0) > 0 then
	set_sVirt("SpeedControl","Auto")
	set_sVirt("AutoManBump",0)
end

if get_sVirt("AutoManBump",0) < 0 then
	set_sVirt("SpeedControl","Manual")
	set_sVirt("AutoManBump",0)
end

if manMode == 1 then
	local manSpeedTerm = tonumber_def(get_gbl("manSpeedTerm",0),0)
	local manSpeedChan = tonumber_def(get_gbl("manSpeedChan",0),0)
	if manSpeedTerm > 0 and manSpeedChan > 0 then --*** USE SPEED POT TO SET SPEED
		local speedInput = tonumber(get_channel_val(manSpeedTerm,manSpeedChan))
		local speedPct = (speedInput / 5) * 100
		if speedPct > 100 then speedPct = 100 end
		if speedPct < 0 then speedPct = 0 end
		manOutput = speedPct
		manSpeed = math.floor((speedPct / 100) * diff + lowSpeed + 0.5)
	else -- Use ManualSpeed to set speed
		manOutput = ((manSpeed - lowSpeed) / diff) * 100.0
		if manOutput < 0 then manOutput = 0 end
		if manOutput > 100 then manOutput = 100 end
	end
	minOutput = manOutput
else
	local stRpm = (speedTarget/100) * maxDiff + idleSpeed
	if stRpm < lowSpeed then stRpm = lowSpeed end
	if stRpm > highSpeed then stRpm = highSpeed end
	manSpeed = math.floor(stRpm)
end

if get_state() == 8 then
	if get_sVirt("SpeedControl",0) == "Auto" then
		set_sGbl("PIDsuctOverride",-1)
	else
		set_sGbl("PIDsuctOverride",minOutput)
	end
else
	if get_sVirt("SpeedControl",0) == "Auto" then
		set_sGbl("PIDsuctOverride",0)
	else
		set_sGbl("PIDsuctOverride",minOutput)
	end
end

if manSpeed < lowSpeed then
	manSpeed = lowSpeed
end

if manSpeed > highSpeed then
	manSpeed = highSpeed
end

set_sVirt("ManualSpeed",manSpeed)
  
  
  
	--********************************************************************
  
  
local output1 = 0
local output2 = 0

-- Remember that minOutput is 0 - 100 pct of lowSpeed <-> highSpeed
-- We need to convert this to 0 - 100 pct of idleSpeed <-> maxSpeed
local suctPct = map_range(outputLow,outputHigh,minOutput)
local speedRpm = suctPct / 100  * (highSpeed - lowSpeed) + lowSpeed
minOutput = (speedRpm - idleSpeed) / (maxSpeed - idleSpeed) * 100



if minOutput <= speedTarget then
	speedTarget = speedTarget - rampRate1
	if speedTarget < minOutput then speedTarget = minOutput end
else
	speedTarget = speedTarget + rampRate1
	if speedTarget > minOutput then speedTarget = minOutput end
	if speedTarget > maxLoad then speedTarget = maxLoad end
end

if speedTarget > maxLoad then speedTarget = maxLoad end
if speedTarget < minLoad then speedTarget = minLoad end

if recycleCtrl then
	local recyclePct = map_range(outputLow2,outputHigh2,recycleMinOutput)
	if recyclePct <= recycleTarget then
		recycleTarget = recycleTarget - rampRate2
		if recycleTarget < recyclePct then recycleTarget = recyclePct end
	else
		recycleTarget = recycleTarget + rampRate2
		if recycleTarget > recyclePct then recycleTarget = recyclePct end
	end
	if recycleTarget > maxRecycle then recycleTarget = maxRecycle end
	if recycleTarget < minRecycle then recycleTarget = minRecycle end
	local recycleOutput = recycleTarget
	if get_state() < 8 then
		recycleTarget = 0
	end
	if recycleRevAct == 1 then
		recycleOutput = 100 - recycleOutput
	end
	set_ao_val(recycleTerm,recycleChan,recycleOutput)
	set_sGbl("recycleTarget",recycleTarget)
	set_sVirt("recycleTarget",recycleTarget)
end

if get_state() == 9 then
	speedTarget = get_sGbl("speedTarget",0)
	if speedTarget > 0 then speedTarget = speedTarget - rampRate1 end
	if speedTarget < 0 then speedTarget = 0 end
end

if get_state() < 8 then speedTarget = 0 end
set_sGbl("speedTarget",speedTarget)
set_ao_val(outputTerm,outputChan,speedTarget)
set_sVirt("spTarget",speedTarget)
local sRpm = (speedTarget/100) * maxDiff + idleSpeed
set_sVirt("Speed Target",math.floor(sRpm + 0.5))

  
  
  