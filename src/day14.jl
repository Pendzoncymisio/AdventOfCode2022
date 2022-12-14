using DelimitedFiles
using Pipe
using AStarSearch

input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day14.txt"),';',String) .|> split(_,"") |> mapreduce(permutedims, vcat, _) |> getindex.(_,1)

function part1(input_array)
    start = indexin('S',input_array)[1]
    input_array[start] = 'a'
    goal = indexin('E',input_array)[1]
    input_array[goal] = 'z'

    input_array = @pipe input_array |> indexin(_,collect('a':'z'))

    function neighbours(state)
        tmp_array = []
        for (i,j) in [(-1,0),(0,-1),(1,0),(0,1)]
            i == 0 && j == 0 && continue
            idx = CartesianIndex(state[1]+i,state[2]+j)
            try
                if input_array[idx] <= input_array[state] + 1
                    push!(tmp_array,idx)
                end
            catch err
            end
        end
        tmp_array
    end

    length(astar(neighbours, start, goal).path) - 1
end

part1(input_array)