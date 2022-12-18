using DelimitedFiles
using Pipe

input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day15.txt"),' ',String) 
input_array = @pipe input_array[:,[3,4,9,10]] .|> split(_,"=") .|> getindex(_,2) 
input_array2 = @pipe input_array[:,[1,2,3]] .|> _[1:end-1] |> hcat(_,input_array[:,4]) |> parse.(Int,_)

y_fin_array = trues(1,100)
y_fin = 10
for row in eachrow(input_array2)
    dist = abs(row[1] - row[3]) + abs(row[2] - row[4])
    println(dist)
    for field in y_fin_array
        
    end
end
