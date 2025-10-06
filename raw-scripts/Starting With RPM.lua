








-- Starting With RPM
function sys_stateFunctionRPMCheck()
    if (not get_sGbl("resetFlag")) and (get_sGbl("startPressed") == true  ) then
      set_sGbl("postLubeActive",false)
      set_sGbl("tableState","update")
      set_sGbl("reset",1)
      reset()
      createLogEntry("start", "start")
      set_sGbl("startPressed",false)
      print("startPressed")
      set_timers_active(2)
      set_sVirt("V8",0)
      set_state(1)
    end
end







