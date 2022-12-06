using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day6.txt"),';',String,skipblanks=false)
input_string = input_array[1]