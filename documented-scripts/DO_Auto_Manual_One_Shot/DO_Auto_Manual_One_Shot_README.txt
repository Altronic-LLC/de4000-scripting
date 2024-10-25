Description: Digital Output Function for Auto/Manual One Shot

Rev 1.0 -

Code Reference:
----------------------------------------
function DigitalOutput_OneShot_AutoMan(Name,Output_Terminal,Output_Number,Normally_Closed,Enable_Manual,Input)
-- Name = Enter The Name Of The Output In Parenthesis 
-- Output_Terminal = Terminal Board Number For Digital Output
-- Output_Number = Output Number For The Digital Output
-- Normally_Closed = 0 = Normally Open, 1 = Normally Closed
-- Enable_Manual = If this is a 0 can not change to manual mode, if 1 then toggle button active
-- Input = Variable Name Used In Master Script Logic
----------------------------------------


DigitalOutput_OneShot_AutoMan("Blowdown",1,3,0,1,Blowdown_Output_Cmd) -- Example "Blowdown" = NAME  1 = Output Terminal, 3 = Output Number, 0 = Normally_Open, 1 = Manual Mode Change Enabled, Blowdown_Output_Cmd = Variable Name Used In Master Script Logic