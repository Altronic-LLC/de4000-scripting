----------------------------
-- Rev 1.0 - Initial Release
----------------------------

function AnalogOutputCmd(Name,Output_Terminal,Output_Number,Reverse_Acting,Bump_Increment)
    if not get_sVirt("_"..Name.."_FS") then
        set_sVirt("_"..Name.."_FS",1)
        if Reverse_Acting == 1 then 
            set_sVirt(Name.." Control",100)
        else
            set_sVirt(Name.." Control",0)
        end
    end

    if get_sVirt(Name.." ControlBump",0) ~= 0 then
        local si = Bump_Increment
        local Position = get_sVirt(Name.." Control",0)
        Position = Position + (si * get_sVirt(Name.." ControlBump",0))
        set_sVirt(Name.." Control",tostring(math.floor(Position)))
        set_sVirt(Name.." ControlBump",0)
    end

    if get_sVirt(Name.." Control",0) >= 100 then set_sVirt(Name.." Control",100) end
    if get_sVirt(Name.." Control",0) <= 0 then set_sVirt(Name.." Control",0) end

    local Analog_Output = math.abs(get_sVirt(Name.." Control",0))
    set_ao_val(Output_Terminal,Output_Number,Analog_Output)
end

AnalogOutputCmd("Suction",1,3,0,5) -- Example "Suction" = NAME, 1 = Output Terminal, 3 = Output Number, 0 = Reverse Acting,  5 = Bump Increment

AnalogOutputCmd("Blowdown",1,1,1,3) -- Example "Blowdown" = NAME, 1 = Output Terminal, 1 = Output Number, 1 = Reverse Acting,  3 = Bump Increment
