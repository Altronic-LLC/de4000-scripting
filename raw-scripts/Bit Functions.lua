-- This will take an integer Value "n" and turn it into a binary repersentation. All 1's and 0's
function FindBits(n) -- Error Array
    local result = ""
    for i = 31, 0, -1 do
        local bit = (n >> i) & 1
        result = result .. bit
    end
    return result
end

Integer = 3222

local FindBits_Array = FindBits(Integer)
set_sVirt("Bit",FindBits_Array)




-- This will take an integer number, turn it into binary then tell you if the POS is a 1 or 0.
function getBit(n, pos)
    return (n >> pos) & 1
end

local ExactBit = getBit(Integer,3)
set_sVirt("ExactBit",ExactBit)




-- This is taking an integer and turning it into Binary then loading a Array table of all the 1's and 0's
function Bit_Array(Name,Integer)
    Bitset = {}
    Bitset[Name] = {}
    for i = 31, 0, -1 do
        local Bit = (Integer >> i) & 1
        Bitset[Name][i] = Bit 
    end
end    

Bit_Array("Andrew",3256)
set_sVirt("AndrwBit",Bitset["Andrew"][2])



-- Same as function above but the table is set outside. This is needed if you nest this function inside another function.
-- Global bitset table
local Bitset = {}

-- Function to generate a bit array
function Bit_Array(Name, Integer)
    Bitset[Name] = {}
    for i = 31, 0, -1 do
        local Bit = (Integer >> i) & 1
        Bitset[Name][i] = Bit 
    end
end  
Bit_Array("Andrew",3256)
set_sVirt("AndrwBit",Bitset["Andrew"][2])

