using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day4.txt"),',',String,skipblanks=false)
