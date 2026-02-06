





-- Function to apply ramp 
function applyRamp(actualValue, targetValue, rampRate) 
  -- Check if the actual value is already equal to the target value 
  if actualValue == targetValue then 
    return targetValue -- No need to ramp, already at the target 
  end 

  -- Ramp up if the actual value is less than the target value 
  if actualValue < targetValue then 
    return math.min(actualValue + rampRate, targetValue) -- Increment by rampRate, but don't overshoot 
  end 

  -- Ramp down if the actual value is greater than the target value 
  if actualValue > targetValue then 
    return math.max(actualValue - rampRate, targetValue) -- Decrement by rampRate, but don't undershoot 
  end 
end 
