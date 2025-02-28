----------------------------
-- Rev 1.0 - Initial Release
----------------------------

function AO_Linear_AutoMan(Name,Output_Terminal,Output_Number,Input,in_min,in_max,Enable_State,Reverse_Acting,Bump_Increment)
    if not get_sVirt("_"..Name.."_FS") then
        set_sVirt("_"..Name.."_FS",1)
        set_sVirt(Name.." Mode","Auto")
        set_sVirt(Name.." Map",0)
    end

    -- Manual/Auto Control 
    checkToggle(Name.." Mode","Auto","Manual")
    
    if get_sVirt(Name.." Mode") == "Manual" then 
        set_sVirt("_"..Name.." Input_Value",get_sVirt(Name.." Control",0))
    else
        set_sVirt("_"..Name.." Input_Value",Input)
        set_sVirt(Name.." Control",math.floor(Input))
    end
      
    if get_sVirt(Name.." Mode") == "Manual" then
        if get_sVirt(Name.." ControlBump",0) ~= 0 then
          local si = Bump_Increment
          local Position = get_sVirt(Name.." Control",0)
          Position = Position + (si * get_sVirt(Name.." ControlBump",0))
          set_sVirt(Name.." Control",tostring(math.floor(Position)))
          set_sVirt(Name.." ControlBump",0)
        end
        set_sVirt(Name.." Map",get_sVirt(Name.." Control"))
    else 
       set_sVirt(Name.." ControlBump",0)
       set_sVirt(Name.." Map",(0 + (get_sVirt("_"..Name.." Input_Value",0) - in_min)*(100 - 0)/(in_max - in_min))) 
       set_sVirt(Name.." Control",math.floor(get_sVirt(Name.." Map",0)))
    end

    if get_sVirt(Name.." Control",0) >= 100 then set_sVirt(Name.." Control",100) end
    if get_sVirt(Name.." Control",0) <= 0 then set_sVirt(Name.." Control",0) end
    
    if get_sVirt(Name.." Map",0) >= 100 then set_sVirt(Name.." Map",100) end
    if get_sVirt(Name.." Map",0) <= 0 then set_sVirt(Name.." Map",0) end

    if Reverse_Acting == 1 then
        if get_sVirt(Name.." Mode") == "Auto" then
            set_sVirt(Name.." Map",(100 - get_sVirt(Name.." Map",0)))
            set_sVirt(Name.." Control",math.floor(get_sVirt(Name.." Map",0))) 
        end
    end

    if get_state() >= Enable_State then 
        set_ao_val(Output_Terminal,Output_Number,get_sVirt(Name.." Map",0))
    else
        if get_sVirt(Name.." Mode") == "Auto" then
            if Reverse_Acting == 0 then
                set_ao_val(Output_Terminal,Output_Number,0)
                set_sVirt(Name.." Map",0)
                set_sVirt(Name.." Control",0)
            else
                set_ao_val(Output_Terminal,Output_Number,100)
                set_sVirt(Name.." Map",100)
                set_sVirt(Name.." Control",100)
            end
        else
            set_ao_val(Output_Terminal,Output_Number,get_sVirt(Name.." Map",0))
        end
    end    
end

AO_Linear_AutoMan("Recycle_Valve",1,1,get_channel_val(1,1),0,50,0,1,5)  --Example  "Recycle_Valve" = Name (User Enterable), 1 = Terminal Board Number, 1 = Output Number, get_channel_val(1,1) = Input Channel To Monitor, 0 = Input Minimum Value, 50 = Input Maximum Value, 0 = State To Start AO Output, 1 = Reverse Acting, 5 = Bump_Increment (Amount for up and down arrows in manual mode)

AO_Linear_AutoMan("Suction_Valve",1,3,get_channel_val(1,6),30,700,1,0,3) --Example  "Suction_Valve" = Name (User Enterable), 1 = Terminal Board Number, 3 = Output Number, get_channel_val(1,3) = Input Channel To Monitor, 30 = Input Minimum Value, 700 = Input Maximum Value, 1 = State To Start AO Output, 1 = Reverse Acting, 3 = Bump_Increment (Amount for up and down arrows in manual mode)



-- Section Only Used for Json example
if not FirstScan then
    FirstScan = 1
    set_sVirt("Input_1",0)
    set_sVirt("Input_2",100)
end

set_channel_val(1,1,get_sVirt("Input_1",0))
set_channel_val(1,6,get_sVirt("Input_2",100))

set_sVirt("Recycle_Valve_Min_Input",0)
set_sVirt("Recycle_Valve_Max_Input",50)

set_sVirt("Suction_Valve_Min_Input",30)
set_sVirt("Suction_Valve_Max_Input",700)


