Description: 

Rev 1.0 - 

Code Reference:
------------------------
-- ActuCom_Enable_Cmd = On/Off depending on State
-- ActuCom_Raise_Cmd = Raises ActuCom by pre-defined Speed Increment value for every button press. On by default in Auto (doesn't change RPM as ActuCom_Lower_Cmd is On by default too)
-- ActuCom_Lower_Cmd = Lower ActuCom by pre-defined Speed Increment value for every button press. On by default in Auto (doesn't change RPM as ActuCom_Raise_Cmd is On by default too)

------------------------
Params:
create_param("ActuCom_Enable",3,"ActuCom Control","Enter amount The State To Enable The Actucom")
create_param("SpeedIncrement",50,"ActuCom Control","Enter amount of RPM to increse/decrease per button press")
create_param("Raise_Time",10,"ActuCom Control","Enter ON time for ActuCom Raise in Seconds")
create_param("Lower_Time",10,"ActuCom Control","Enter ON time for ActuCom Lower in Seconds")


%% Need reference for Manual speed control and ActuCom Auto/Manual Control