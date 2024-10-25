Description: Momentary Button Function - Pushbutton for interacting with an external Modbus device.

Rev 1.0 -

Code Reference:
------------------------------------------
function MomentaryPB_Modbus(Name,Time,Terminal,Output,Modbus_Name)
-- First Value "Name" Is String Name
-- Second value "Time", is time for output ON
-- Third Value "Terminal", is terminal board Number
-- Fourth Value "Output", Is the output number
-- Fifth Value, "Modbus_Name", needs to be the same name as in the modbus script functions
-------------------------------------------

MomentaryPB_Modbus("VFD Reset",2,1,2,"VFDResetMB") -- This example "VFD RESET" = First Value, 2 = Time, 1 = Terminal Board, 2 = Output #
MomentaryPB_Modbus("Reset 3",5,1,5,"Modbus_Reset_3")

-------------------------------------------

-- PUT IN MODBUS SCRIPT
-- The Modbus_Pushbutton function needs to go inside the modbusWrites() function. If one is already in the system you can't put it in again.
-- Example below uses 40799 as input modbus value, and 40801 as the output modbus value

-------------------------------------------
function Modbus_PushButton(Modbus_Name,Number_In)

--Example in Code
Modbus_PushButton("VFDResetMB",799) -- 1st value = Name of the Modbus button this needs to match in all 3 places, 2nd value reading paramter from outside modbus
Modbus_PushButton("Modbus_Reset_3",803)
--------------------------------------------
function Modbus_PushButton_Out(Modbus_Name,Number_Out)

--Example in Code
Modbus_PushButton_Out("VFDResetMB",1) -- 1st value = Name of the Modbus button this needs to match in all 3 places, 2nd value to write to when pushbutton is energized.
Modbus_PushButton_Out("Modbus_Reset_3",5)