using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day10.txt"),' ')

function part1(input_array)
    cycle_count = 0
    X = 1
    strenght_sum = 0
    for row in eachrow(input_array)
        if row[1] == "noop"
            if (cycle_count+20) % 40 in [39]
                strenght_sum += (cycle_count+1) * X
            end
            cycle_count+=1
        else
            if (cycle_count+20) % 40 in [38,39]
                strenght_sum += (cycle_count + 40 - (cycle_count+20) % 40) *X
            end
            X += row[2]
            cycle_count+=2
        end
    end
    strenght_sum
end

#part1(input_array)

function part2(input_array)
    op_number = sum((input_array[:,1] .== "noop") + (input_array[:,1] .== "addx") * 2)
end