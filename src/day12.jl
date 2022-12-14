using DelimitedFiles
using Pipe
using AStarSearch

input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day12.txt"),';',String) .|> split(_,"") |> mapreduce(permutedims, vcat, _) |> getindex.(_,1)
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

function part1()
    astar(neighbours, start, goal).cost
end

println("Part1: ",part1())

function part2(input_array)
    min_length = Inf
    
    for idx in CartesianIndices(input_array)
        if input_array[idx] == 1
            astar_res = astar(neighbours, idx, goal)
            if astar_res.status == :success
                curr_length = astar_res.cost
                curr_length < min_length && (min_length = curr_length)
            end
        end
    end

    min_length
end

println("Part2: ",part2(input_array))