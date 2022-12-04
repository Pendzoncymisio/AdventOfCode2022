using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day4.txt"),',',String,skipblanks=false)


function parse_range(input::String)
    val_min, val_max = parse.(Int,split(input,'-'))
    return val_min:val_max
end

parsed_input_array = parse_range.(input_array)
function part1(parsed_input_array)
    points = 0
    points_debug = 0
    for row in eachrow(parsed_input_array)
        if (row[1].start <= row[2].start && row[1].stop >= row[2].stop) || 
            (row[1].start >= row[2].start && row[1].stop <= row[2].stop)
            points+=1
        end
    end
    points
end

println("Part1: ",part1(parsed_input_array))

function part2(parsed_input_array)
    points = 0
    for row in eachrow(parsed_input_array)
        length(intersect(row[1],row[2])) > 0 && (points += 1) 
    end
    points
end

println("Part2: ",part2(parsed_input_array))