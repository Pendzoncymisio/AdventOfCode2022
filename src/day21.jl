using DelimitedFiles
using Pipe
using LightGraphs


input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day21.txt"),' ',String)
input_array[:,1] = chop.(input_array[:,1])



function part1(input_array)
    main_graph = SimpleDiGraph(20)

    nodes_dict = Dict()

    i = 1
    for row in eachrow(input_array)
        try
            nodes_dict[row[1]]
        catch e
            if typeof(e) <: KeyError
                nodes_dict[row[1]] = i
                i += 1
            end
        end
    end

    return nodes_dict
end

part1(input_array)