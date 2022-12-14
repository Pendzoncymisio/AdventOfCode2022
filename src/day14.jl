using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day14.txt"),' ')

sand_array = trues(1000,1000)

for row in eachrow(input_array)
    for i in 1:2:length(row)-2
        row[i+2] == "" && break
        point_curr = parse.(Int,split(row[i],","))
        point_next = parse.(Int,split(row[i+2],","))

        if point_curr[1] + point_curr[2] < point_next[1] + point_next[2]
            point_start = CartesianIndex(point_curr[1],point_curr[2])
            point_end = CartesianIndex(point_next[1],point_next[2])
        else
            point_end = CartesianIndex(point_curr[1],point_curr[2])
            point_start = CartesianIndex(point_next[1],point_next[2])
        end

        for idx in point_start:point_end
            sand_array[idx] = false
        end
    end
end
prior_sum = sum(sand_array)

while true
    point_sand = CartesianIndex(500,1)
    
    try
        while true
            if sand_array[point_sand+CartesianIndex(0,1)]
                point_sand += CartesianIndex(0,1)
            elseif sand_array[point_sand+CartesianIndex(-1,1)]
                point_sand += CartesianIndex(-1,1)
            elseif sand_array[point_sand+CartesianIndex(1,1)]
                point_sand += CartesianIndex(1,1)
            else
                sand_array[point_sand] = false
                break
            end
        end
    catch
        break
    end
end

println(prior_sum-sum(sand_array))
sand_array[495:510,1:10]