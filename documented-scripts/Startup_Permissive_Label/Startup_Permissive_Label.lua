-----------------------------------------------------
--Startup Function Permissives Labels
-----------------------------------------------------
function PermissiveStateLabel()
  set_sVirt("State_Permissive","None")
  local Startup_Label_Winner = 0
  local pVal = 0
  local state = get_state()
  if tonumber(get_gbl("perm"..state.."a".."Enabled",0)) == 1 then
    local pTerm = get_gbl("perm"..state.."a".."Term",0)
    local pChan = get_gbl("perm"..state.."a".."Chan",0)
    local pSetPoint = get_gbl("perm"..state.."a".."Sp",0)
    local pRel = get_gbl("perm"..state.."a".."Rel","")

    if pTerm == "T1" then pTerm = 1 end
    if pTerm == "T2" then pTerm = 2 end
    if pTerm == "T3" then pTerm = 3 end
    if pTerm == "T4" then pTerm = 4 end
    if pTerm == "T5" then pTerm = 5 end
    if pTerm == "NONE" then pTerm = 0 end
    if pChan == "NONE" then pChan = 0 end
    if pChan == "sp1" then
      pChan = 0
      set_sVirt("State_Permissive","RPM > "..pSetPoint)
    end
    pVal = get_channel_val(pTerm,pChan)
    if pRel == ">" then
      if pVal > pSetPoint then Startup_Label_Winner = 1 end
    elseif pRel == "<" then
      if pVal < pSetPoint then Startup_Label_Winner = 1  end
    elseif pRel == "=" then
      if pVal == pSetPoint then Startup_Label_Winner = 1  end
    end
    if pTerm > 0 and pChan > 0 then
      set_sVirt("State_Permissive",get_channel_label(pTerm,pChan).." "..pRel.." "..pSetPoint)
    end
  end

  if tonumber(get_gbl("perm"..state.."b".."Enabled",0)) == 1 then
    local pTerm = get_gbl("perm"..state.."b".."Term",0)
    local pChan = get_gbl("perm"..state.."b".."Chan",0)
    local pSetPoint = get_gbl("perm"..state.."b".."Sp",0)
    local pRel = get_gbl("perm"..state.."b".."Rel","")

    if pTerm == "T1" then pTerm = 1 end
    if pTerm == "T2" then pTerm = 2 end
    if pTerm == "T3" then pTerm = 3 end
    if pTerm == "T4" then pTerm = 4 end
    if pTerm == "T5" then pTerm = 5 end
    if pTerm == "NONE" then pTerm = 0 end
    if pChan == "NONE" then pChan = 0 end
    if pChan == "sp1" then
      pChan = 0
      set_sVirt("State_Permissive","RPM > "..pSetPoint)
    end
    if pTerm > 0 and pChan > 0 and  Startup_Label_Winner == 1 then
      set_sVirt("State_Permissive",get_channel_label(pTerm,pChan).." "..pRel.." "..pSetPoint)
    elseif tonumber(get_gbl("perm"..state.."a".."Enabled",0)) == 0 then
      set_sVirt("State_Permissive",get_channel_label(pTerm,pChan))
    end
    pVal = get_channel_val(pTerm,pChan)
    if pRel == ">" then
      if pVal > pSetPoint then Startup_Label_Winner = 1 end
    elseif pRel == "<" then
      if pVal < pSetPoint then Startup_Label_Winner = 1  end
    elseif pRel == "=" then
      if pVal == pSetPoint then Startup_Label_Winner = 1  end
    end
    if pTerm > 0 and pChan > 0 then
      if get_sVirt("permissive_met",0) == "B not met" then set_sVirt("State_Permissive",get_channel_label(pTerm,pChan).." "..pRel.." "..pSetPoint) end
    end
  end
end

PermissiveStateLabel() 




--- Only for Json use for example

if not FirstScan then
  FirstScan = 1
  set_sVirt("SuctionPrs",20)
  set_sVirt("COP",25)
  set_sVirt("EOP",30)
  set_sVirt("DSCHPrs",35)
  set_sVirt("EOT",40)
  set_sVirt("COT",45)
  set_sVirt("RPM_Input",0)
end
if get_state() == 0 then set_sVirt("RPM_Input",0) end

set_channel_val(1,1,get_sVirt("SuctionPrs",20))
set_channel_val(1,2,get_sVirt("COP",25))
set_channel_val(1,3,get_sVirt("EOP",30))
set_channel_val(1,4,get_sVirt("DSCHPrs",35))
set_channel_val(1,5,get_sVirt("EOT",40))
set_channel_val(1,6,get_sVirt("COT",45))
set_rpm(get_sVirt("RPM_Input",0))




