using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day3.txt"),' ',String,skipblanks=false)

function get_char_index(char::Char)
    Int(char) > 93 && return Int(char) - 96
    return Int(char) - 38
end

function get_common_char(val1::String,val2::String)
    char_flags = [false for i in 1:52]
    for char in val1
        char_flags[get_char_index(char)] = true
    end

    for char in val2
        char_flags[get_char_index(char)] && return char
    end

    return '_'
end

function part1(input_array)
    
    points = 0
    for row in eachrow(input_array)
        value = row[1]
        val1 = value[1:Int(length(value)/2)]
        val2 = value[Int(length(value)/2)+1:length(value)]
        #println(value,' ',val1,' ',val2)
        points += get_char_index(get_common_char(val1,val2))
    end
    points
end

println("Part1: ",part1(input_array))