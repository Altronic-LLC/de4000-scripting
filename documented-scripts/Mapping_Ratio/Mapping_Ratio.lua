----------------------------
-- Rev 1.0 - Initial Release
----------------------------

function map(Input,input_Minimum,Input_Maximum,Output_Minimum,Output_Maximum)
  return Output_Minimum + (Input - input_Minimum)*(Output_Maximum - Output_Minimum)/(Input_Maximum - input_Minimum)
end 

local Suction_Prs_Mapped = map(get_channel_val(1,1),450,950,0,100) -- This example: get_channel_val(1,1) = Input, 450 = input_Minimum, 950 = input_Maximum, 0 = Output_Minimum, 100 = Output_Maximum

local Side_Stream_Temp_Mapped = map(get_channel_val(1,5),0,1600,850,1250) -- This example: get_channel_val(1,5) = Input, 0 = input_Minimum, 1600 = input_Maximum, 850 = Output_Minimum, 1250 = Output_Maximum



-- Section Only Used for Json example
if not FirstScan then
  FirstScan = 1
  set_sVirt("Input_1",450)
  set_sVirt("Input_2",10)
end

set_channel_val(1,1,get_sVirt("Input_1",450))
set_channel_val(1,5,get_sVirt("Input_2",10))

set_sVirt("Suction_Prs_Mapped",Suction_Prs_Mapped)
set_sVirt("Side_Stream_Temp_Mapped",Side_Stream_Temp_Mapped)

set_sVirt("Suction_Prs_Min_Input",450)
set_sVirt("Suction_Prs_Max_Input",950)
set_sVirt("Suction_Prs_Min_Output",0)
set_sVirt("Suction_Prs_Max_Output",100)

set_sVirt("SideStream_Temp_Min_Input",0)
set_sVirt("SideStream_Temp_Max_Input",1600)
set_sVirt("SideStream_Temp_Min_Output",850)
set_sVirt("SideStream_Temp_Max_Output",1250)
