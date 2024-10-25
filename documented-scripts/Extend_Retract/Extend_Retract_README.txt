Description: An Extend/Retract function which can be enabled or disabld

Rev 1.0 - Initial Release


Code Reference:
------------------------------
function Ext_Ret(Name,Extend_Time,Retract_Time,Enable,Override)
-- Name = Enter The Name Of The Output In Parenthesis
-- Extend_Time = Enter the time it should be in extend position in seconds
-- Retract_Time = Enter the time it should be in retract position in seconds
-- Enable = 0 = Extend/Reteact is enabled will be taking place, 1 = Extend/retract is not enabled
-- Override = 

--State = 0 = Extend, 2 = Retract
----------------------------------------------------------

local Andrew = get_sVirt("Andrew Eanble",0)

Andrew_Test = Ext_Ret("Testing",10,10,Andrew)
set_sVirt("Andrew_Test",Andrew_Test)