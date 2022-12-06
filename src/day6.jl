using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day6.txt"),';',String,skipblanks=false)
input_string = input_array[1]

function parts(input_string, buffer_size)
    for index in 1:length(input_string)
        length(Set(input_string[index:index+buffer_size-1])) == buffer_size && return index
    end
end

println("Part1: ",parts(input_string, 4))
println("Part2: ",parts(input_string, 14))