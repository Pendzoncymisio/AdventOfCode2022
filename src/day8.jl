using DelimitedFiles
using Pipe
input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day8.txt"),';',String) .|> split(_,"") |> mapreduce(permutedims, vcat, _) |> parse.(Int,_)

dim = 99
visible_array = falses(dim,dim)

for i in 1:dim
    highest_tree = -1
    for j in 1:dim
        if input_array[i,j] > highest_tree
            highest_tree = input_array[i,j]
            visible_array[i,j] = true
        end
    end
end

for i in 1:dim
    highest_tree = -1
    for j in 1:dim
        if input_array[j,i] > highest_tree
            highest_tree = input_array[j,i]
            visible_array[j,i] = true
        end
    end
end


for i in dim:-1:1
    highest_tree = -1
    for j in dim:-1:1
        if input_array[i,j] > highest_tree
            highest_tree = input_array[i,j]
            visible_array[i,j] = true
        end
    end
end

for i in dim:-1:1
    highest_tree = -1
    for j in dim:-1:1
        if input_array[j,i] > highest_tree
            highest_tree = input_array[j,i]
            visible_array[j,i] = true
        end
    end
end

sum(visible_array)