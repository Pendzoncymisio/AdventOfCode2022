using DelimitedFiles
using DataStructures

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day6.txt"),';',String,skipblanks=false)
input_string = input_array[1]

function parts(input_string, buffer_size)
    letter_buffer = CircularBuffer{Char}(buffer_size)
    for (index,input_letter) in enumerate(input_string)
        push!(letter_buffer,input_letter)
        if isfull(letter_buffer)
            if length(Set(letter_buffer[1:end])) == capacity(letter_buffer)
                return index
            end
        end
    end
end

println("Part1: ",parts(input_string, 4))
println("Part2: ",parts(input_string, 14))