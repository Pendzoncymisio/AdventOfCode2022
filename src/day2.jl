using DelimitedFiles

input_array = readdlm("$(@__DIR__)\\..\\inputs\\day2.txt",' ',Char,skipblanks=false)

function part1(input_array)

    function one_play(pick_opp, pick_me)
        points = 0
        pick_me == 'X' && (points += 1)
        pick_me == 'Y' && (points += 2)
        pick_me == 'Z' && (points += 3)
    
        pick_me == 'X' && pick_opp == 'A' && (points += 3)
        pick_me == 'X' && pick_opp == 'B' && (points += 0)
        pick_me == 'X' && pick_opp == 'C' && (points += 6)
    
        pick_me == 'Y' && pick_opp == 'A' && (points += 6)
        pick_me == 'Y' && pick_opp == 'B' && (points += 3)
        pick_me == 'Y' && pick_opp == 'C' && (points += 0)
    
        pick_me == 'Z' && pick_opp == 'A' && (points += 0)
        pick_me == 'Z' && pick_opp == 'B' && (points += 6)
        pick_me == 'Z' && pick_opp == 'C' && (points += 3)
        points
    end

    points = 0
    for row in eachrow(input_array)
        points += one_play(row[1],row[2])
    end
    points
end

println("Part1: ",part1(input_array))

function part2(input_array)

    function one_play(pick_opp, result)
        points = 0
        result == 'X' && (points += 0)
        result == 'Y' && (points += 3)
        result == 'Z' && (points += 6)
    
        pick_opp == 'A' && result == 'X' && (points += 3)
        pick_opp == 'A' && result == 'Y' && (points += 1)
        pick_opp == 'A' && result == 'Z' && (points += 2)

        pick_opp == 'B' && result == 'X' && (points += 1)
        pick_opp == 'B' && result == 'Y' && (points += 2)
        pick_opp == 'B' && result == 'Z' && (points += 3)

        pick_opp == 'C' && result == 'X' && (points += 2)
        pick_opp == 'C' && result == 'Y' && (points += 3)
        pick_opp == 'C' && result == 'Z' && (points += 1)

        points
    end

    points = 0
    for row in eachrow(input_array)
        points += one_play(row[1],row[2])
    end
    points
end

println("Part2: ",part2(input_array))