using DelimitedFiles
using Pipe
input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day8.txt"),';',String) .|> split(_,"") |> mapreduce(permutedims, vcat, _) |> parse.(Int,_)

function part1(input_array)
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
end


function part2(input_array)
    dim = 99
    max_scenic_score = 0
    for i in 2:dim-1
        for j in 2:dim-1
            current_tree = input_array[i,j]
            scenic_score = 1

            offset_delta = -1
            offset = offset_delta
            current_view = 0
            while true
                i+offset == 0 && break
                current_view += 1
                current_tree <= input_array[i+offset,j] && break
                offset += offset_delta
            end
            scenic_score *= current_view
            
            offset_delta = 1
            offset = offset_delta
            current_view = 0
            while true
                i+offset == dim+1 && break
                current_view += 1
                current_tree <= input_array[i+offset,j] && break
                offset += offset_delta
            end
            scenic_score *= current_view

            offset_delta = -1
            offset = offset_delta
            current_view = 0
            while true
                j+offset == 0 && break
                current_view += 1
                current_tree <= input_array[i,j+offset] && break
                offset += offset_delta
            end
            scenic_score *= current_view
            
            offset_delta = 1
            offset = offset_delta
            current_view = 0
            while true
                j+offset == dim+1 && break
                current_view += 1
                current_tree <= input_array[i,j+offset] && break
                offset += offset_delta
            end
            scenic_score *= current_view

            max_scenic_score < scenic_score && (max_scenic_score = scenic_score)
        end
    end
    max_scenic_score
end

part2(input_array)