using DelimitedFiles

input_array = readdlm("$(@__DIR__)\\..\\inputs\\day1.txt",',',Any,skipblanks=false)

function part1(input_array)
    max_calories, current_calories = 0, 0

    for row in input_array
        if typeof(row) <: SubString{String}
            if current_calories > max_calories
                max_calories = current_calories
            end
            current_calories = 0
        elseif typeof(row) <: Int64
            current_calories += row
        end
    end
    max_calories
end

print("Part1: ",part1(input_array))
