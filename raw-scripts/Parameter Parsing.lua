













-- Function to parse terminal and IO from parameter strings
-- param_in:  name of the input parameter
-- returns: Terminal, IO
function parse_param_io(param_in)
    local val_in  = get_param(param_in)

    -- Terminal = number before "/"
    local Terminal = tonumber(string.match(val_in,  '%d[%d.,]*'))

    -- IO = number after "/"
    local IO = tonumber(string.match(val_in,  '/%s*(%d[,.%d]*)'))

    return Terminal, IO
end




-- Define params (you probably create_param earlier somewhere)
create_param("Scrubber_Dump_Valve_Stg1_LS_Input","3/1","Scrubber Stg1 Dump Valve Configuration","First Number = Terminal Board, Second Number = Input")

-- Call function
local Terminal, IO = parse_param_io("Scrubber_Dump_Valve_Stg1_LS_Input")

set_sVirt("debug1",Terminal)
set_sVirt("debug2",IO)
set_sVirt("debug3",parse_param_io("Scrubber_Dump_Valve_Stg1_LS_Input"))
set_do_val(Terminal,IO,1)