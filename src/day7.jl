using DelimitedFiles
using AbstractTrees

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day7.txt"))

function part1(input_array)

    current_size = 0
    result_size = 0
    parents_tmp_array = []
    for row in eachrow(input_array)
        if row[1] == "\$"
            if row[2] == "cd"
                if row[3] == ".."
                    parent_weight = pop!(parents_tmp_array)
                    current_size < 100000 && (result_size += current_size)
                    current_size += parent_weight
                else
                    push!(parents_tmp_array,current_size)
                    current_size = 0
                end
            end
        elseif typeof(row[1][1]) <: Int64
            current_size += row[1]
        end
    end
    result_size
end

println("Part1: ",part1(input_array))

function get_space_to_free(input_array)
    current_size = 0
    for row in eachrow(input_array)
        if typeof(row[1][1]) <: Int64
            current_size += row[1]
        end
    end
    30000000 - 70000000 + current_size
end

function part2(input_array)
    space_to_free = get_space_to_free(input_array)
    current_size = 0
    parents_tmp_array = []
    potential_dir = []
    for row in eachrow(input_array)
        if row[1] == "\$"
            if row[2] == "cd"
                if row[3] == ".."
                    parent_weight = pop!(parents_tmp_array)
                    current_size > space_to_free && (push!(potential_dir,current_size))
                    current_size += parent_weight
                else
                    push!(parents_tmp_array,current_size)
                    current_size = 0
                end
            end
        elseif typeof(row[1][1]) <: Int64
            current_size += row[1]
        end
    end
    return minimum(potential_dir)
end

println("Part2: ",part2(input_array))