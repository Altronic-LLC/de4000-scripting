





















local debug1 = 12.655


function sVirt_Decimals(Description, Value, Accuracy)
    -- Calculate the multiplier for the desired decimal places
    local multiplier = 10 ^ Accuracy

    -- Round the value to the specified decimal places
    local rounded = math.floor((Value + 0.5 / multiplier) * multiplier) / multiplier

    -- Set the sVirt with "_" prefix
    set_sVirt(Description, "_" .. rounded)
end



sVirt_Decimals("Debugging Answer1", debug1, 2) -- this give two decimal places = 12.66
sVirt_Decimals("Debugging Answer1", debug1, 3) -- this give three decimal places = 12.655