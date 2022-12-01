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

#print("Part1: ",part1(input_array))

function part2(input_array)
    current_calories = 0
    calories_array = []

    for row in input_array
        if typeof(row) <: SubString{String}
            append!(calories_array,current_calories)
            current_calories = 0
        elseif typeof(row) <: Int64
            current_calories += row
        end
    end
    sort!(calories_array,rev=true)
    calories_array[1] + calories_array[2] + calories_array[3]
end

print("Part2: ",part2(input_array))
