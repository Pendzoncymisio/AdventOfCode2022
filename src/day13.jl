using DelimitedFiles
using Pipe

input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day13.txt"),' ',String) |>
    [ _[rownum*2+colnum] for rownum in 1:Int(length(_)/2), colnum in -1:0] |>
    Meta.parse.(_) |>
    eval.(_)

input_array_2 = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day13.txt"),' ',String) |>
    Meta.parse.(_) |>
    eval.(_)

function compare_values(val_a, val_b)
    if typeof(val_a) <: Int64 && typeof(val_b) <: Int64
        if val_a < val_b
            return 1
        elseif val_a > val_b
            return -1
        else
            return 0
        end
    else
        for i in eachindex(val_a)
            try
                res = compare_values(val_a[i],val_b[i])
                if res != 0
                    return res
                end
            catch e
                if typeof(e) <: BoundsError #Right run out of values
                    return -1
                end
            end
        end # Left run out of values
        if length(val_a) != length(val_b)
            return 1
        else
            return 0
        end
    end
end

function part1(input_array)
    sum = 0
    for (idx, row) in enumerate(eachrow(input_array))
        if compare_values(row[1], row[2]) == 1
            sum += idx
        end
    end
    return sum
end

println("Part1: ",part1(input_array))

input_array_2

function part2(input_array)
    idx_6 = 0
    for (idx, row) in enumerate(eachrow(input_array))
        if compare_values(row[1], [6]) == 1
            idx_6 += 1
        end
    end

    idx_2 = 0
    for (idx, row) in enumerate(eachrow(input_array))
        if compare_values(row[1], [2]) == 1
            idx_2 += 1
        end
    end

    return (idx_6 + 2) * (idx_2 + 1)


end

println("Part2: ",part2(input_array_2))