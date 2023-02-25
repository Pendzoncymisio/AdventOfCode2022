using DelimitedFiles
using Pipe

input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day19.txt"),' ',String) |> _[:,[7,13,19,22,28,31]] |> parse.(Int,_)

function part1(input_array)
    res_order = [:geode, :obsydian, :clay, :ore]
    for row in eachrow(input_array)
        costs = Dict(:ore => [(row[1],:ore)],:clay => [(row[2],:ore)],:obsydian => [(row[3],:ore),(row[4],:clay)],:geode => [(row[5],:ore),(row[6],:obsydian)])
        resources = Dict(:ore => 0, :clay => 0, :obsydian => 0, :geode => 0)
        robots = Dict(:ore => 1, :clay => 0, :obsydian => 0, :geode => 0)
        for minute in 1:24
            robots_to_be = []
            for res_sym in res_order
                while all([resources[cost_sym] >= cost_num for (cost_num,cost_sym) in costs[res_sym]])
                    push!(robots_to_be,res_sym)
                    for (cost_num,cost_sym) in costs[res_sym]
                        resources[cost_sym] -= cost_num
                    end
                end
                resources[res_sym] += robots[res_sym]
            end
            for robot in robots_to_be
                robots[robot] += 1
            end
            println("Minute $(minute)")
            println("Robots to be $(robots_to_be)")
            println("Resources $(resources)")
            println("Robots $(robots)")
        end
    end
end

part1(input_array)