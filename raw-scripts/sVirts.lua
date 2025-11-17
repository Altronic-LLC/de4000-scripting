









-- EXAMPLES OF USING sVIRT with color changing backgrounds
-- The #A105FA is a HTML hex color, look up HTML color codes and that will be what you enter for that



-- Setting background color on the HMI dashbaord with a variable
var = 1
set_sVirt("Comp1Fault",var.." (#A105FA)")


  -- Setting background color with string word.
if Solenoid_Suction_SDV_Close_LS == 0 and Solenoid_Suction_SDV_Open_LS == 1 then set_sVirt("Suction SDV-4001 Position","OPEN(#58FF33)") end --Green  
if Solenoid_Suction_SDV_Close_LS == 0 and Solenoid_Suction_SDV_Open_LS == 0 then set_sVirt("Suction SDV-4001 Position","MOVING(#E2F40A)") end --Yellow
if Solenoid_Suction_SDV_Close_LS == 1 and Solenoid_Suction_SDV_Open_LS == 0 then set_sVirt("Suction SDV-4001 Position","CLOSED(#FB2103)") end --Red
if Solenoid_Suction_SDV_Close_LS == 1 and Solenoid_Suction_SDV_Open_LS == 1 then set_sVirt("Suction SDV-4001 Position","ERROR(#A105FA)") end --Purple



  -- Setting background color and if using LED indicator the second color is the LED light color. For LED indicator the color can only be R, Y, G, P
set_sVirt("test","1(BLUE,R)")

set_sVirt("test2","1(#58FF33,R)")
