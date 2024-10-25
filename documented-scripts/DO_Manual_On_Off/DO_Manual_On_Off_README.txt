Description: Digital Output Function for Manual On/Off
Rv 1.0 -

Code Reference:
-----------------------------------------
function DigitalOutput_ON_OFF(Name,Output_Terminal,Output_Number,Normally_Closed)
-- Name = Enter The Name Of The Output In Parenthesis 
-- Output_Terminal = Terminal Board Number For Digital Output
-- Output_Number = Output Number For The Digital Output
-- Normally_Closed = 0 = Normally Open, 1 = Normally Closed
------------------------------------------

DigitalOutput_ON_OFF("Blowdown",1,6,0) -- Example "Blowdown" = NAME, 1 = Output Terminal, 6 = Output Number, 0 = Normally_Open