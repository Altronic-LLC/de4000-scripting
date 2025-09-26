














defaultModbus()

local Channel_Input_11 = (get_channel_val(1,11)*10)
set_modbus(100, Channel_Input_11) -- This equals register 40100


--[[ This will take the current value in the channel lets say it is .31, the customer wants the decimal place still but is pulling the 16 bit registers, 
    this would now make the value the customer got in the modbus be 31 and then they would divide by 10 to get the value with decimal being .31
        
        Channel 11 on TB#1
        Register 16 bit 40100
        Channel set a 0.00 to 2.00 IPS (4-20mA current loop)

        Normal DE4K displayed value = 0.31

        Standard MB when poled sends a 0
        
]]