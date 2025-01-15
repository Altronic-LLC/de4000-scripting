Description: Momentary pushbutton function activates an output for a specified duration (On_Time parameter) when pressed.

Rev 1.0 -

Code Reference:
----------------------------------------
function MomentaryPB(Name,Output_Terminal,Output_Number,On_Time)
-- Name = Enter The Name Of The Output In Parenthesis 
-- Output_Terminal = Terminal Board Number For Digital Output
-- Output_Number = Output Number For The Digital Output
-- On_Time = Enter Time To Keep Output On, Once Energized
----------------------------------------


MomentaryPB("VFD Reet",1,2,3) -- This example "VFD RESET" = Name, 1 = Terminal Board, 2 = Output #, 3 = On_Time

MomentaryPB("Reset",1,5,5) -- This example "Reset" = Name, 1 = Terminal Board, 5 = Output #, 5 = On_Time
