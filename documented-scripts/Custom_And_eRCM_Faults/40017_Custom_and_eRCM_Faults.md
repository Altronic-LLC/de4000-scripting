# Register 40017 — Custom Faults and eRCM Faults

**Applies to:** DE-4000 firmware **3.1.10** and later

**Files in this folder**
- [`Custom_And_eRCM_Faults.lua`](Custom_And_eRCM_Faults.lua) — the three functions to paste at the top of the Master Script
- [`readme`](readme) — short description and code reference

**Related files in this repository**
- [`raw-scripts/Modbus_Custom_Faults.lua`](../../raw-scripts/Modbus_Custom_Faults.lua) — the Modbus Script that computes 40017
- [`raw-scripts/Custom Faults NEW MODBUS.lua`](../../raw-scripts/Custom%20Faults%20NEW%20MODBUS.lua) — raw/undocumented version of these helpers

**Related file in Altronic-Public-Files**
- [DE-4000_REG_40017_4-7-26.xlsx](https://github.com/Altronic-LLC/Altronic-Public-Files/blob/main/DE4000_Firmware_Releases/Final/3.1.10/DE-4000_REG_40017_4-7-26.xlsx) — the complete 40017 lookup table, including the eRCM fault index list

> All scripting here is example code for reference only. Verify operation on the final system before placing it into use.

---

## 1. What Register 40017 Is

Register **40017** reports the panel's **first fault** as a single 16-bit number. A Modbus master can read one register and know both *what kind* of fault occurred and *which* fault it was, without having to read and parse the fault banner string.

Register **40018** is the companion fault flag:

| Register | Meaning |
|---|---|
| **40017** | First-fault status code (`0` when no fault is latched) |
| **40018** | Fault flag — `1` when a first fault is latched, `0` when clear |

40017 divides the entire fault space into three ranges using the two upper bits of the register:

| Range | Upper bit set | Fault class | Value formula |
|---|---|---|---|
| `1` – `999` | none | **Input channel fault** (analog, discrete, RPM) | code as-is |
| `16385` – `18384` | `+16384` | **System fault** (including eRCM) | `16384 + code` |
| `32769` – `48768` | `+32768` | **Custom fault** | `32768 + index` |

> The script comments call these "bit 15" and "bit 16" using 1-based bit numbering. In 0-based terms they are bit 14 (`16384`) and bit 15 (`32768`).

Input channel faults need no extra work — the firmware generates them from the terminal and channel number. **Custom faults and eRCM faults are the two cases where the script writer controls the value**, and those are what this document covers.

---

## 2. The Problem This Solves

Most existing scripts call `customFault()` with only a fault string:

```lua
customFault("Low differential pressure")
```

Called this way the string is used for the banner display and the fault type defaults to **9** ("custom fault"). Every custom fault in the panel therefore reports the *same* value in 40017 (`32768`). A Modbus master can see that *a* custom fault occurred, but not *which one*.

Passing a **fault index** through the additional arguments fixes this. The index becomes part of the 40017 value, so each custom or eRCM fault gets its own distinct code that the master can look up in a table.

- **eRCM faults must always be indexed.**
- **Custom faults** — the index is optional, but **strongly recommended** on any panel that is monitored over Modbus.

---

## 3. The `customFault()` Function

The full signature is:

```lua
customFault(faultString, term, chan, type, chtyp, value)
```

| Argument | Purpose | Default |
|---|---|---|
| `faultString` | Text shown on the fault banner | *(required)* |
| `term` | **High byte** of the fault index | `0` |
| `chan` | **Low byte** of the fault index | `0` |
| `type` | Fault type — `9` = custom fault, `24` = eRCM fault | `9` |
| `chtyp` | Channel type — **leave at the default for indexed faults** | `0` |
| `value` | Channel value | `0` |

For custom and eRCM faults you only ever need the first four arguments:

```lua
customFault(faultString, term, chan, type)
```

`term` and `chan` are normally the terminal and channel number of a hardware fault. For custom and eRCM faults they are **reused as the two halves of a 16-bit fault index** — this is why the index has to be split into a high byte and a low byte before it is passed in.

> ### ⚠ Leave `chtyp` alone
> If `chtyp` is set to `1`, `2`, or `3` **and** `chan` is greater than zero, 40017 treats the fault as a physical input channel fault and computes a channel code from `term` and `chan` instead of a custom/eRCM code. Always leave `chtyp` at its default of `0` when passing a fault index.

> ### ⚠ `customFault()` shuts the unit down
> `customFault()` latches the first fault, sets the fault flag, and issues a `stop()`. It is a shutdown, not an alarm. This is true for eRCM faults as well, since they are raised through the same function.

> ### ⚠ Only the first fault is captured
> `customFault()` records the fault only when no fault is already latched. Everything in 40017 refers to the **first** fault since the last reset.

---

## 4. Splitting the Index

The index has to be split into two 8-bit values before it is passed to `customFault()`. Add this helper to the top of the Master Script:

```lua
function split16(value16)
  local high_byte = math.floor(value16 / 256)
  local low_byte = value16 % 256
  return high_byte, low_byte
end
```

The firmware reassembles the index internally as `term * 256 + chan`.

---

## 5. Custom Faults (type 9)

### Value in 40017

```
40017 = 32768 + faultIndex

faultIndex = 40017 - 32768
```

Valid index range: **1 – 16000**. Index `1` reports as `32769`, index `182` reports as `32950`, index `16000` reports as `48768`. An unindexed custom fault reports as `32768`. Indexes above `16383` wrap and are not usable.

### Helper function

```lua
function custFault(faultString, index)
  local high,low = split16(index)
  customFault(faultString,high,low,9)
end
```

### Example

```lua
-- Fault index 182 -> 40017 reads 32950
local faultIndex = 182
local high,low = split16(faultIndex)
customFault("Low differential pressure",high,low,9)
```

or, using the helper:

```lua
custFault("Low differential pressure",182)
```

### Worked example in context

```lua
-- Index constants at the top of the Master Script
FLT_LOW_DIFF_PRESS = 10
FLT_HIGH_SUCTION   = 11
FLT_SCRUBBER_LEVEL = 12

local suction   = get_channel_val(1,3)
local discharge = get_channel_val(1,5)

if (discharge - suction) < 15 then
  custFault("Low Diff Pressure",FLT_LOW_DIFF_PRESS)      -- 40017 = 32778
end

if suction > 55 then
  custFault("High Suction Pressure",FLT_HIGH_SUCTION)    -- 40017 = 32779
end
```

Keep the index constants in one block at the top of the script. That block *is* the lookup table the Modbus master needs.

> ### ⚠ Avoid reserved wording in custom fault strings
> 40017 recognises certain system faults by searching the fault string, and that search also runs on custom faults. If a **custom** fault string contains one of these phrases, the fault is reported as that system fault instead of as a custom fault:
>
> `System Unlocked` · `Attempted Start with RPM` · `Cooldown Complete` · `- Auto-Restart Cancelled` · `Lube No Flow` · `HSC TRIPPED` · `Internal Fault` · `Power Up` · `PowerFail` · `WATCHDOG` · `Timeout A` · `Timeout B` · `Permissive not met in State 0` · `Low Differential` · `High Differential` · `Terminal Board <n> HSC` · `NO COMM FROM TERM: <n>` · `Terminal Board <n> Missing`
>
> For example, `custFault("Low Differential Pressure",10)` contains `Low Differential` and reports **16724** (system fault "Low Differential"), not `32778`. Word the string differently — `"Low Diff Pressure"` or `"Suction/Discharge Delta Low"` — or verify the value the panel actually reports before putting the script into service.

---

## 6. eRCM Faults (type 24)

eRCM faults use fault type **24** and are reported in the **system fault** range, in a block reserved above the other system faults.

### Value in 40017

```
40017 = 16384 + 1000 + faultIndex   (= 17384 + faultIndex)

faultIndex = 40017 - 17384
```

Valid index range: **1 – 1000**. An index above 1000 is clamped to 1000.

| eRCM index | 40017 value | Fault (per the published lookup table) |
|---|---|---|
| 1 | 17385 | ACI Heartbeat Fault |
| 2 | 17386 | Invalid Speed |
| 3 | 17387 | High Discharge Temperature |
| 4 | 17388 | Low Volumetric Efficiency |
| 5 | 17389 | Pin Non Reversal |

The complete index list is on the **eRCM Fault Codes** tab of [DE-4000_REG_40017_4-7-26.xlsx](https://github.com/Altronic-LLC/Altronic-Public-Files/blob/main/DE4000_Firmware_Releases/Final/3.1.10/DE-4000_REG_40017_4-7-26.xlsx). **Use the indexes from that sheet** so every panel in the fleet reports the same code for the same condition.

### Helper function

```lua
function eRCMfault(faultString, index)
  local high,low = split16(index)
  customFault(faultString,high,low,24)
end
```

### Examples

```lua
eRCMfault("LS"..Name.." Invalid Speed (script)",2)                -- 40017 = 17386
eRCMfault("LS"..Name.." High Discharge Temperature (script)",3)   -- 40017 = 17387
eRCMfault("LS"..Name.." Low Volumetric Efficiency (script)",4)    -- 40017 = 17388
```

### Converting an existing eRCM script

Existing eRCM scripts typically call `customFault()` with the string only. Converting them is a one-line-per-fault change:

```lua
-- Before - every one of these reports 32768
customFault("LS"..Name.." Invalid Speed (script)")
customFault("LS"..Name.." High Discharge Temperature (script)")

-- After - each reports its own code
eRCMfault("LS"..Name.." Invalid Speed (script)",2)
eRCMfault("LS"..Name.." High Discharge Temperature (script)",3)
```

---

## 7. Quick Reference

| Fault class | `type` | Index range | 40017 value |
|---|---|---|---|
| Input channel fault | *(firmware generated)* | — | `1` – `999` |
| System fault | *(firmware generated)* | — | `16384 + code` |
| **eRCM fault** | **24** | **1 – 1000** | **`17384 + index`** |
| **Custom fault** | **9** | **1 – 16000** | **`32768 + index`** |
| No fault latched | — | — | `0` |

Full value-by-value breakdown: [DE-4000_REG_40017_4-7-26.xlsx](https://github.com/Altronic-LLC/Altronic-Public-Files/blob/main/DE4000_Firmware_Releases/Final/3.1.10/DE-4000_REG_40017_4-7-26.xlsx)

---

## 8. Checklist for a New Panel

1. Confirm the panel is running DE-4000 firmware **3.1.10** or later.
2. Confirm the panel's Modbus Script contains the 40017 logic — see [`raw-scripts/Modbus_Custom_Faults.lua`](../../raw-scripts/Modbus_Custom_Faults.lua).
3. Paste `split16()`, `custFault()` and `eRCMfault()` from [`Custom_And_eRCM_Faults.lua`](Custom_And_eRCM_Faults.lua) at the top of the **Master Script**.
4. Assign an index to every custom fault and define them as named constants in one block.
5. Use the indexes from the **eRCM Fault Codes** tab of the spreadsheet for every eRCM fault — do not invent new ones.
6. Check custom fault strings against the reserved-wording list in Section 5.
7. Trip each fault on the bench and confirm 40017 reads the expected value before the panel ships.
8. Hand the index list to whoever is configuring the SCADA/Modbus master.
