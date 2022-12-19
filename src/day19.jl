using DelimitedFiles
using Pipe

input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day19.txt"),' ',String) |> _[:,[7,13,19,22,28,31]] |> parse.(Int,_)

function part1(input_array)
    for row in eachrow(input_array)
        resources = Dict(:ore => 0, :clay => 0, :obsydian => 0, :geode => 0)
        robots = Dict(:ore => 1)
        for minute in 1:24
            resources.ore
        end
    end
    resources
end

part1(input_array)