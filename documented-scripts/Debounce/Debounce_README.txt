Description: Debounce Input Timer

Rev 1.0 - 

Code Reference
-----------------------------------------
function Debounce(Channel,On_Time,Off_Time,Var_Name)
Channel = On Timer/Off Timer based on channel value - (Channel = 0, Off Timer; Channel = 1, On Timer)
On_Time = Time for which the On Timer will stay on
Off_Timer = Time for which the On Timer will stay on
Var_Name = Name of Variable


Debounce(get_sVirt("Channel"),10,10,"andrew_test")
local RRRRRR = get_sVirt("andrew_test")
set_sVirt("RRRRRR",RRRRRR)