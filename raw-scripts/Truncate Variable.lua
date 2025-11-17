










-- Will truncate the number to the exact decimal places you want.

function truncate(num, decimals)
    local factor = 10 ^ decimals
    return math.floor(num * factor) / factor
end