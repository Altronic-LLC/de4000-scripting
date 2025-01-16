----------------------------
-- Linear PID Function --
-- Name = Enter The Name Of The Output In Parenthesis 
-- Output_Terminal = Terminal Board Number For Analog Output
-- Output_Number = Output Number For The Analog Output
-- Input = Enter Channel To Get The Process Varible From
-- in_min = Enter The Number That is equal to 0% Output
-- in_max = Enter The Number That is Equal to 100% Output
-- Enable_State = Enter The State Number To Release the Output
-- Reverse_Acting = 1 = Reverse acting, 0 = Normal Acting
----------------------------
function LinearPID(Name,Output_Terminal,Output_Number,Input,in_min,in_max,Enable_State,Reverse_Acting)

    local Reverse_Acting_Value = 100 * Reverse_Acting
    local Linear_Map = (0 + (Input - in_min)*(100 - 0)/(in_max - in_min)) 

    if Linear_Map >= 100 then Linear_Map = 100 end
    if Linear_Map <= 0 then Linear_Map = 0 end

    local Linear_Map_Output = math.abs(Linear_Map - Reverse_Acting_Value)
     
    if get_state() >= Enable_State then 
        set_ao_val(Output_Terminal,Output_Number,Linear_Map_Output)
    else
        if Reverse_Acting == 1 then
            set_ao_val(Output_Terminal,Output_Number,Reverse_Acting_Value)
        else
            set_ao_val(Output_Terminal,Output_Number,Reverse_Acting_Value)
        end
    end

    set_sVirt(Name.." Output",Linear_Map_Output)
end

LinearPID("Recycle Valve",1,4,get_channel_val(1,6),250,850,1,0)
LinearPID("Side Stream Valve",1,2,get_channel_val(1,7),20,77,5,1)

-- For Json Example Only.
if not FirstScan then
    FirstScan = 1
    set_sVirt("Input1",261)
    set_sVirt("Input2",30)
end

set_channel_val(1,6,get_sVirt("Input1",261))
set_channel_val(1,7,get_sVirt("Input2",20))






