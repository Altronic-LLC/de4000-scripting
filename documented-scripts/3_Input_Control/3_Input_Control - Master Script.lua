if not firstscan then
	firstscan = 1
	create_param("Input_Term",1,"Control Input 3","Enter The Input Terminal Number of Control #3")
	create_param("Input_Chan",3,"Control Input 3","Enter The Input Channel Number of Control #3")
	create_param("Linear_High_SP",77,"Control Input 3","Enter The High Setpoint of Control #3")
	create_param("Linear_Low_SP",17,"Control Input 3","Enter The Low Setpoint of Control #3")
	create_param("Input3_Enable",1,"Control Input 3","Control #3: Enable = 1, Disable = 0")

end



set_gbl("Input_Term",get_param("Input_Term",0))
set_gbl("Input_Chan",get_param("Input_Chan",0))
set_gbl("Linear_High_SP",get_param("Linear_High_SP",0))
set_gbl("Linear_Low_SP",get_param("Linear_Low_SP",0))
set_gbl("Input3_Enable",get_param("Input3_Enable",0))


if not Andrew_FS then
	Andrew_FS = 1
	set_sVirt("Input1",0)
	set_sVirt("Input2",0)
	set_sVirt("Input3",0)
end