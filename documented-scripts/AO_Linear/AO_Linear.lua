----------------------------
-- Rev 1.0 - Initial Release
----------------------------

function AO_Linear(Name,Output_Terminal,Output_Number,Input,in_min,in_max,Enable_State,Reverse_Acting)

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

AO_Linear("Recycle Valve",1,4,get_channel_val(1,6),250,850,1,0) --Example  "Recycle Valve" = Name (User Enterable), 1 = Terminal Board Number, 4 = Output Number, get_channel_val(1,6) = Input Channel To Monitor, 250 = Input Minimum Value, 850 = Input Maximum Value, 1 = State To Start AO Output, 0 = Normal Acting.
AO_Linear("Side Stream Valve",1,2,get_channel_val(1,7),20,77,5,1) --Example  "Side Stream Valve" = Name (User Enterable), 1 = Terminal Board Number, 2 = Output Number, get_channel_val(1,7) = Input Channel To Monitor, 20 = Input Minimum Value, 77 = Input Maximum Value, 5 = State To Start AO Output, 1 = Reverse Acting.








