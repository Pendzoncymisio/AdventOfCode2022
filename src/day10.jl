using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day10.txt"),' ')


function part1(input_array)
    cycle_count = 0
    X = 1
    for row in eachrow(input_array)
        row[1] == "noop" && (cycle_count+=1)
    end
end

part1(input_array)
