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
    char_flags = [0 for i in 1:52]

    for string in strings
        for char in string
            char_flags[get_char_index(char)] += 1
        end
    end
    found_index = indexin(length(strings),char_flags)[1]
    typeof(found_index) == Nothing && return '_'
    return get_char_from_index(found_index)
end
get_common_char(values...) = get_common_char([values...])

function part1(input_array)
    
    points = 0
    for row in eachrow(input_array)
        value = row[1]
        val1 = value[1:Int(length(value)/2)]
        val2 = value[Int(length(value)/2)+1:end]
        points += get_char_index(get_common_char(val1,val2))
    end
    points
end

#println("Part1: ",part1(input_array))

function part2(input_array)
    
    points = 0
    for (index,_) in enumerate(input_array[1:3:end])
        common_char = get_common_char(input_array[index],input_array[index+1],input_array[index+2])
        println("")
        println(input_array[index]," ",input_array[index+1]," ",input_array[index+2])
        println(common_char)
        points += get_char_index(common_char)
        
    end
    points
end

#println("Part2: ",part2(input_array))
get_common_char("DD","DUPA")