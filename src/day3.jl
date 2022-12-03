using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day3.txt"),' ',String,skipblanks=false)