using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day3.txt"),' ',String,skipblanks=false)

function get_char_index(char::Char)
    char == '_' && error("'_' passed to get_char_index")
    Int(char) > 93 && return Int(char) - 96
    return Int(char) - 38
end

function get_char_from_index(index::Int)
    index <= 26 && return Char(index+96)
    return Char(index+38)
end

function get_common_char(strings::Vector{String})

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
    for row in eachrow(input_array)
        value = row[1]
        val1 = value[1:Int(length(value)/2)]
        val2 = value[Int(length(value)/2)+1:end]
        points += get_common_char(val1,val2)
    end
    points
end

println("Part1: ",part1(input_array))

function part2(input_array)
    
    points = 0
    for (index,_) in enumerate(input_array[1:3:end])
        points += get_common_char(input_array[index*3-2],input_array[index*3-1],input_array[index*3])
    end
    points
end

println("Part2: ",part2(input_array))