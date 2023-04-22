using DelimitedFiles
using LinkedLists

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day20.txt"),' ',Int64)

l = LinkedList{Int}()
append!(l, input_array)

index_list = [positiontoindex(i, l) for i in 1:7]

for index in index_list
    item = getindex(l, index)
    pos = indextoposition(index , l)

    deleteat!(l, index)
    new_pos = pos + item
    #println(new_pos)
    if new_pos == 1
        push!(l, item)
        continue
    elseif new_pos < 1
        new_pos = length(l) + new_pos
    elseif new_pos > length(l)
        new_pos -= length(l)
    end

    new_idx = positiontoindex(new_pos, l)
    insert!(l, new_idx, item)
    #println(l)
end
println(l)
zero_pos = indextoposition(findfirst(x -> x == 0, l),l)
l[positiontoindex((1000+zero_pos)%length(l),l)] + l[positiontoindex((2000+zero_pos)%length(l),l)] + l[positiontoindex((3000+zero_pos)%length(l),l)]
