using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day3.txt"),' ',String,skipblanks=false)

function get_char_index(char::Char)
    char == '_' && error("'_' passed to get_char_index")
    Int(char) > 93 && return Int(char) - 96
    return Int(char) - 38
end

function get_common_char(strings::Vector{String}) #It turns out that can be achieved by simple "∩"

    flags_matrix = Array{Bool}(undef, 52, 0)
    for string in strings
        char_flags = [false for i in 1:52]
        for char in string
            char_flags[get_char_index(char)] = true
        end
        flags_matrix = [flags_matrix char_flags]
    end
    found_index = 0
    for (index,row) in enumerate(eachrow(flags_matrix))
        all(row) && (found_index = index)
    end

    found_index == 0 && error("No common chars found")
    return found_index
end
get_common_char(values...) = get_common_char([values...])

function part1(input_array)
    
    points = 0
    for row in input_array
        half = Int(length(row)/2)
        points += get_common_char(row[1:half],row[half+1:end])
    end
    points
end

println("Part1: ",part1(input_array))

function part2(input_array)
    
    points = 0
    for index in 1:3:length(input_array)
        points += get_common_char(input_array[index],input_array[index+1],input_array[index+2])
    end
    points
end

println("Part2: ",part2(input_array))