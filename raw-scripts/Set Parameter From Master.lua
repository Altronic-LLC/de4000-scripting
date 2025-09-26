

function set_param_perm (key, val)
  set_gbl("p_" .. key, val)
end 


set_param_perm("Some parameter Name",TheValueYouWant)


--[[ This is a way to use the master script to update and push values into create parametes that are on the HMI dashboard screens, this will push the value and the 
    code will see it, but the HMI screens will not update with this new value until a refresh or power cycle.
]]

