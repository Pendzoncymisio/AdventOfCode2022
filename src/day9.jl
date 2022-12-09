using DelimitedFiles
using Agents

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day9.txt"),' ')

@agent Knot GridAgent{2} begin
    type::Bool #true when head, false when tail
end

using Random # for reproducibility
function part1(input_array)
    space = GridSpace((100, 100), metric=:manhattan, periodic = false)
    model = ABM(Knot, space)

    head = Knot(1, (50, 50), true)
    add_agent!(head, model)

    tail = Knot(2, (50, 50), false)
    add_agent!(head, model)
    
    return model
end

part1(1)