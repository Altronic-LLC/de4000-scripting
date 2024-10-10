Description: Battery saver operates continuously under normal conditions. If a system fault is detected, a countdown timer begins. Once the timer expires, the battery saver deactivates

Rev 1.0 - Initial Release 


Example Code/Code Reference:
----------------------------
-- Digital Output Function --
-- Output_Terminal = Terminal Board Number For Digital Output
-- Output_Number = Output Number For The Digital Output
-- Delay = Enter The Output Number The Battery Saver Output Is On In Minutes
----------------------------
--Params--
create_param("Battery_Saver_Delay",10,"BatterySaver Shutoff Control","Enter BatterySaver Shutoff Delay Time (0-9999min)")
create_param("Battery_Saver_Output_Terminal",1,"BatterySaver Shutoff Control","Enter The Terminal Board The Battery Saver Output Is On")
create_param("Battery_Saver_Output_Output",5,"BatterySaver Shutoff Control","Enter The Output Number The Battery Saver Output Is On")


Battery_Saver(1,5,2)  -- Example 1 = Output Terminal, 5 = Output Number, 2 = Delay of 2 Minutes