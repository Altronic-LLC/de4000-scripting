----------------------------
-- Rev 1.0 - Initial Release
----------------------------

----------------------------------------------------------------------------
-- Custom And eRCM Faults --
-- Requires DE-4000 firmware 3.1.10 or later, and a Modbus Script containing
-- the 40017 status register logic (raw-scripts/Modbus_Custom_Faults.lua).
--
-- Paste these three functions at the TOP of the MASTER script.
--
-- Without an index, every custom fault reports the same value (32768) in
-- register 40017, so a Modbus master cannot tell them apart. Passing an index
-- gives each fault its own value:
--
--   custFault() - custom fault, type 9   ->  40017 = 32768 + index
--                 index range 1 - 16000
--   eRCMfault() - eRCM fault,   type 24  ->  40017 = 17384 + index
--                 index range 1 - 1000
--
-- To go the other way, subtract: eRCM index = 40017 - 17384,
--                                custom index = 40017 - 32768.
--
-- NOTE: customFault() is a SHUTDOWN. It latches the first fault, sets the
--       fault flag and issues a stop(). Only the FIRST fault since the last
--       reset is reported in 40017.
----------------------------------------------------------------------------

    -- Splits a 16 bit fault index into the high and low bytes that
    -- customFault() expects in its term and chan arguments
function split16(value16)
  local high_byte = math.floor(value16 / 256)
  local low_byte = value16 % 256
  return high_byte, low_byte
end

    -- Custom fault (type 9) with splitting value
function custFault(faultString, index)
  local high,low = split16(index)
  customFault(faultString,high,low,9)
end

    -- eRCM fault (type 24) with splitting value
function eRCMfault(faultString, index)
  local high,low = split16(index)
  customFault(faultString,high,low,24)
end


----------------------------------------------------------------------------
-- EXAMPLE USE --
-- Keep every custom fault index as a named constant in one block. That block
-- is the lookup table the Modbus master needs.
----------------------------------------------------------------------------

-- FLT_LOW_DIFF_PRESS = 10   -- 40017 = 32778
-- FLT_HIGH_SUCTION   = 11   -- 40017 = 32779
-- FLT_SCRUBBER_LEVEL = 12   -- 40017 = 32780
--
-- local suction   = get_channel_val(1,3)
-- local discharge = get_channel_val(1,5)
--
-- if (discharge - suction) < 15 then
--   custFault("Low Diff Pressure",FLT_LOW_DIFF_PRESS)
-- end
--
-- if suction > 55 then
--   custFault("High Suction Pressure",FLT_HIGH_SUCTION)
-- end

    -- eRCM faults, indexed per the published eRCM lookup table
--
-- eRCMfault("LS"..Name.." Invalid Speed (script)",2)               -- 17386
-- eRCMfault("LS"..Name.." High Discharge Temperature (script)",3)  -- 17387
-- eRCMfault("LS"..Name.." Low Volumetric Efficiency (script)",4)   -- 17388


----------------------------------------------------------------------------
-- WARNING - reserved wording in custom fault strings --
-- Register 40017 identifies system faults by searching the fault string, and
-- that search also runs on custom faults. A custom fault whose string contains
-- one of these phrases is reported as that SYSTEM fault instead:
--
--   System Unlocked            Attempted Start with RPM   Cooldown Complete
--   - Auto-Restart Cancelled   Lube No Flow               HSC TRIPPED
--   Internal Fault             Power Up                   PowerFail
--   WATCHDOG                   Timeout A                  Timeout B
--   Low Differential           High Differential
--   Permissive not met in State 0
--   Terminal Board <n> HSC     NO COMM FROM TERM: <n>     Terminal Board <n> Missing
--
-- Example: custFault("Low Differential Pressure",10) reports 16724 (system
-- fault "Low Differential"), NOT 32778. Word it "Low Diff Pressure" instead.
----------------------------------------------------------------------------
