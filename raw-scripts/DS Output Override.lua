--Here is the test script code
function set_ctrl_do_override(ch, val)
    set_sVirt("ctrl_do_override" .. ch, val)
    if tonumber_def(get_sGbl("redis_ctrl"),0) ~= 1 then
      set_ctrl_do_val(ch,val)
    end
end

function set_ctrl_do(ch,val)
  if tonumber_def(get_sVirt("ctrl_do_override" .. ch, 2) ~= 2) then
    if tonumber_def(get_sGbl("redis_ctrl"),0) ~= 1 then
      set_ctrl_do_val(ch,val)
    end
  end
end



-- Only used for testing and reference

local test = get_ctrl_do_val(3)

if get_state() ~= 8 then 
  set_ctrl_do_override(1,1)
  set_ctrl_do_override(2,0)
  set_ctrl_do_override(3,0)
  set_ctrl_do_override(4,1)
else
  set_ctrl_do_override(1,0)
  set_ctrl_do_override(2,1)
  set_ctrl_do_override(3,1)
  set_ctrl_do_override(4,0)
end