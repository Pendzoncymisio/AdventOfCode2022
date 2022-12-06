using DelimitedFiles
using DataStructures

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day6.txt"),';',String,skipblanks=false)
input_string = input_array[1]

function part1(input_string)
    letter_buffer = CircularBuffer{Char}(4)
    for (index,input_letter) in enumerate(input_string)
        push!(letter_buffer,input_letter)
        if isfull(letter_buffer)
            if letter_buffer[1] != letter_buffer[2] && letter_buffer[1] != letter_buffer[3] && letter_buffer[1] != letter_buffer[4] && letter_buffer[2] != letter_buffer[3] && letter_buffer[2] != letter_buffer[4] && letter_buffer[3] != letter_buffer[4]
                return index
            end
        end
    end
end

println("Part1: ",part1(input_string))