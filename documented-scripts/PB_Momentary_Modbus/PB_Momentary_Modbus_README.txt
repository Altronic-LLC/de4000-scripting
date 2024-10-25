Description: Trigger a Modbus device with this configurable momentary pushbutton. Set the desired "on" duration with the "Time" parameter.

Rev 1.0 -

Code Reference:
----------------------------------------
function MomentaryPB_Modbus(Name,Time,Terminal,Output,Modbus_Name)
-- First Value "Name" Is String Name
-- Second value "Time", is time for output ON
-- Third Value "Terminal", is terminal board Number
-- Fourth Value "Output", Is the output number
-- Fifth Value, "Modbus_Name", needs to be the same name as in the modbus script functions
----------------------------

MomentaryPB_Modbus("VFD Reset",2,1,2,"VFDResetMB") -- This example "VFD RESET" = First Value, 2 = Time, 1 = Terminal Board, 2 = Output #


-----------------------------------------------------------------------------

-- PUT IN MODBUS SCRIPT -- NODE 200
-- The Modbus_Pushbutton function needs to go inside the modbusWrites() function. If one is already in the system you can't put it in again.
-- Example below uses 40799 as input modbus value, and 40801 as the output modbus value


function modbusWrites()
    function Modbus_PushButton(Modbus_Name,Number_In)

Modbus_PushButton("VFDResetMB",799) -- 1st value = Name of the Modbus button this needs to match in all 3 places, 2nd value reading paramter from outside modbus
Modbus_PushButton("Modbus_Reset_3",803)  

--------------------------------------------------------

function Modbus_PushButton_Out(Modbus_Name,Number_Out)

Modbus_PushButton_Out("VFDResetMB",801) -- 1st value = Name of the Modbus button this needs to match in all 3 places, 2nd value to write to when pushbutton is energized.