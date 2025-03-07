----------------------------
-- Rev 1.0 - Initial Release
----------------------------

----------------------------
-- Battery Saver Function --
----------------------------
function Battery_Saver()
    if not Battery_Saver_FS then 
        Battery_Saver_FS = 1
        create_param("Battery_Saver_Delay",10,"BatterySaver Shutoff Control","Enter BatterySaver Shutoff Delay Time (0-9999min)")
        create_param("Battery_Saver_Output_Terminal",1,"BatterySaver Shutoff Control","Enter The Terminal Board The Battery Saver Output Is On")
        create_param("Battery_Saver_Output_Output",5,"BatterySaver Shutoff Control","Enter The Output Number The Battery Saver Output Is On")
    end
    
    local Battery_Saver_Delay = get_param("Battery_Saver_Delay",10) * 60
    local Battery_Saver_Output_Terminal = get_param("Battery_Saver_Output_Terminal",1)
    local Battery_Saver_Output_Output = get_param("Battery_Saver_Output_Output",5)
    local Output_Status = get_do_val(Battery_Saver_Output_Terminal,Battery_Saver_Output_Output) 
    
    if Battery_Saver_Cmd ~= Battery_Saver_Cmd_Last then
        Battery_Saver_Output = Battery_Saver_Cmd
        Battery_Saver_Cmd_Last = Battery_Saver_Cmd
    end
    set_do_val(Battery_Saver_Output_Terminal,Battery_Saver_Output_Output,Battery_Saver_Output) 
        
    if tonumber(get_firstFault("flag")) ~= 1 then  -- fault output adjust to match your confirguration
        Battery_Saver_Cmd = 1 -- power output adjust to match your configuration
    end
    if tonumber(get_firstFault("flag")) ~= 1 and Output_Status == 1 then
        set_timer("BatterySaverTimer",Battery_Saver_Delay) -- keeps resetting timer as long as there are no faults
    end
    if tonumber(get_firstFault("flag")) == 1 and Output_Status == 1 then
        if not get_timer("BatterySaverTimer") then -- wait for timer to complete then turn output off
            Battery_Saver_Cmd = 0
        end
    end
    
    local bsl,bst = get_timer("BatterySaverTimer")
    set_sVirt("BatterySaverTimer",bst)

end

Battery_Saver() 
