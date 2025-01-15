Description: Linear PID Function

Rev 1.0 -

Code Reference:
----------------------------------------
function LinearPID(Name,Output_Terminal,Output_Number,Input,in_min,in_max,Enable_State,Reverse_Acting)

-- Name = Enter The Name Of The Output In Parenthesis 
-- Output_Terminal = Terminal Board Number For Analog Output
-- Output_Number = Output Number For The Analog Output
-- Input = Enter Channel To Get The Process Varible From
-- in_min = Enter The Number That is equal to 0% Output
-- in_max = Enter The Number That is Equal to 100% Output
-- Enable_State = Enter The State Number To Release the Output
-- Reverse_Acting = 1 = Reverse acting, 0 = Normal Acting
-----------------------------------------

LinearPID("BTU_Control",1,4,get_channel_val(1,6),250,850,1,0)

--"BTU_Control": Name of the PID controller (used for labeling output).
--1: Terminal board number for the analog output.
--4: Output number on the terminal board.
--get_channel_val(1,6): Reads the process variable from channel 6 on terminal 1.
--250: Minimum input value (0% output).
--850: Maximum input value (100% output).
--1: State number to enable the output (active in state 1 or higher).
--0: Normal acting PID (output increases with input).