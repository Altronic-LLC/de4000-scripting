----------------------------
-- Rev 1.0 - Initial Release
----------------------------

function DI_Exceeding(Input1,Input2)
    local In1 = Input1
    local In2 = Input2

    if Input1 >= Input2 then
        return Input1
    else
        return Input2
    end
end

local Answer = DI_Exceeding(get_channel_val(1,1),get_channel_val(1,2)) -- Example: get_channel_val(1,1) = First Analog Input Channel, get_channel_val(1,2) = Second Analog Input Channel
