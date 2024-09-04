

Description: Creating a Three Input Linear Control Scheme

Rev 1.0 - Initial Release 8/5/2024


Code Reference:
----------------------------
-- Use Three Inputs for Linear Control (2 configured on DE-4000 HMI, one configured via script)--
-- Input_Term = Parameter for the Terminal Board Number For Control #3 Input
-- Input_Chan = Parameter for the Input Channel Number For Control #3 Input
-- Linear_High_SP =  Parameter for the High Linear Setpoint For Control #3 Input
-- Linear_Low_SP =  Parameter for the Low Linear Setpoint For Control #3 Input
-- Input3_Enable = Parameter for Enabling/Disabaling of Control 
----------------------------
create_param("Input_Term",default value,"Control Input 3","Enter The Input Terminal Number of Control #3")
create_param("Input_Chan",default value,"Control Input 3","Enter The Input Channel Number of Control #3")
create_param("Linear_High_SP",default value,"Control Input 3","Enter The High Setpoint of Control #3")
create_param("Linear_Low_SP",default value,"Control Input 3","Enter The Low Setpoint of Control #3")
create_param("Input3_Enable",default value,"Control Input 3","Control #3: Enable = 1, Disable = 0")


create_param("Input_Term",1,"Control Input 3","Enter The Input Terminal Number of Control #3") -- Example 1 = Creates Terminal Board Parameter for Control #3 Input with a default value of Terminal Board #1