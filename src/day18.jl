using DelimitedFiles
using Pipe

input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day18.txt"),' ',String) .|> split(_,',') .|> parse.(Int,_) |> vec(_)

function part1(input_array)
    sides = 0

    offsets = [
        [1,0,0],
        [-1,0,0],
        [0,1,0],
        [0,-1,0],
        [0,0,1],
        [0,0,-1]
    ]

    input_length = length(input_array)

    for i in 1:input_length
        element = pop!(input_array)
        sides += 6
        for offset in offsets
            if (offset + element) in input_array
                sides -= 2
            end
        end
    end   
    sides
end
part1(input_array)