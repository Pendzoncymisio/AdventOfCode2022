using DelimitedFiles
using DataStructures

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day5.txt"),';',String,skipblanks=false)

function split_input_array(input_array)
    for (index,value) in enumerate(input_array)
        if length(value)==0
            return input_array[1:index-1], input_array[index+1:end]
        end
    end
end

function get_start_stacks_array(stacks_input_array)
    number_of_stacks = parse(Int,stacks_input_array[end][end-1])
    stacks = [Stack{Char}() for i in 1:number_of_stacks]
    max_height = length(stacks_input_array)-1
    for (stack_index,stack) in enumerate(stacks)
        for row_num in reverse(1:max_height)
            crate = stacks_input_array[row_num][stack_index*4-2]
            crate != ' ' && push!(stack,crate)
        end
    end
    stacks
end

function parse_moves_array(moves_input_array)
    [parse.(Int,split(move_row,' ')[2:2:end]) for move_row in moves_input_array]
end

function make_move!(stacks, from, to)
    crate = pop!(stacks[from])
    push!(stacks[to],crate)
    stacks
end

function make_agg_move!(stacks, number, from, to)
    temp_stack = Stack{Char}()
    for i in 1:number
        push!(temp_stack,pop!(stacks[from]))
    end
    for i in 1:number
        push!(stacks[to],pop!(temp_stack))
    end
    stacks
end

stacks_input_array, moves_input_array = split_input_array(input_array)
stacks = get_start_stacks_array(stacks_input_array)
moves = parse_moves_array(moves_input_array)


function part1(stacks,moves)
    for move in moves
        for i in 1:move[1]
            make_move!(stacks,move[2],move[3])
        end
    end
    for stack in stacks
        print(pop!(stack))
    end
end

print("Part1: ")
part1(stacks,moves)

function part2(stacks,moves)
    for move in moves
        make_agg_move!(stacks,move[1],move[2],move[3])
    end
    for stack in stacks
        print(pop!(stack))
    end
end

stacks = get_start_stacks_array(stacks_input_array)

print("\nPart2: ")
part2(stacks,moves)