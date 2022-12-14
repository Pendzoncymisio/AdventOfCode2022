using DelimitedFiles

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day14.txt"),' ')

function parse_sand_array(input_array)
    highest_y = 0
    sand_array = trues(1000,1000)

    for row in eachrow(input_array)
        for i in 1:2:length(row)-2

            point_curr = parse.(Int,split(row[i],","))
            point_curr[2] > highest_y && (highest_y = point_curr[2])
            row[i+2] == "" && break
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
    return sand_array, highest_y
end

function drop_sand!(sand_array)
    point_sand = CartesianIndex(500,0)

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

    sand_array
end

function part1(input_array)
    sand_array, _ = parse_sand_array(input_array)
    prior_sum = sum(sand_array)

    while true
        try
            drop_sand!(sand_array)
        catch
            break
        end
    end

    prior_sum-sum(sand_array)
end

println("Part1: ",part1(input_array))

function part2(input_array)
    sand_array, highest_y = parse_sand_array(input_array)
    sand_array[:,highest_y+2] .= false
    
    prior_sum = sum(sand_array)
    while true
        try
            drop_sand!(sand_array)
        catch
            break
        end
    end

    prior_sum-sum(sand_array) + 1
end



println("Part2: ",part2(input_array))
