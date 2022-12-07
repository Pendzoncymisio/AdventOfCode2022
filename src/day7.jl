using DelimitedFiles
using AbstractTrees

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day7.txt"))
print(typeof(input_array[1]))

for row in eachrow(input_array)
    if row[1] == "\$"
        println(row[3])
    end
end

struct Directory
    value::Int
    children::Vector{Directory}
enD

