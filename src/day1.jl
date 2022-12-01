using DelimitedFiles

input_array = readdlm("$(@__DIR__)\\..\\inputs\\day1.txt",',',Any,skipblanks=false)

function get_sorted_calories(input_array)
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
end

calories_array = get_sorted_calories(input_array)

function part1(calories_array)
    calories_array[1]
end

println("Part1: ",part1(calories_array))

function part2(calories_array)
    calories_array[1] + calories_array[2] + calories_array[3]
end

println("Part2: ",part2(calories_array))
