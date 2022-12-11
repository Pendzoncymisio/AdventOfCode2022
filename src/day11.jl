monkeys = []
operations = [x -> x*19, x-> x+6, x-> x*x, x->x+3]
divisible = (x,y) -> x%y == 0
tests = [x -> divisible(x,i) for i in [23,19,13,17]]
#=
push!(monkeys,[79, 98])
push!(monkeys,[54, 65, 75, 74])
push!(monkeys,[79, 60, 97])
push!(monkeys,[74])
=#
mutable struct Monkey
    items::Array{Int128}
    operation::Function
    test::Function
    throw_true::Int64
    throw_false::Int64
    counter::Int128 
end


push!(monkeys,Monkey([79, 98],x -> x*19,x -> divisible(x,23),2,3,0))
push!(monkeys,Monkey([54, 65, 75, 74],x -> x+6,x -> divisible(x,19),2,0,0))
push!(monkeys,Monkey([79, 60, 97],x -> x*x,x -> divisible(x,13),1,3,0))
push!(monkeys,Monkey([74],x -> x+3,x -> divisible(x,17),0,1,0))

#= TESTING MONKEYS
push!(monkeys,Monkey([66, 71, 94],x -> x*5,x -> divisible(x,3),7,4,0))
push!(monkeys,Monkey([70],x -> x+6,x -> divisible(x,17),3,0,0))
push!(monkeys,Monkey([62, 68, 56, 65, 94, 78],x -> x+5,x -> divisible(x,2),3,1,0))
push!(monkeys,Monkey([89, 94, 94, 67],x -> x+2,x -> divisible(x,19),7,0,0))
push!(monkeys,Monkey([71, 61, 73, 65, 98, 98, 63],x -> x*7,x -> divisible(x,11),5,6,0))
push!(monkeys,Monkey([55, 62, 68, 61, 60],x -> x+7,x -> divisible(x,5),2,1,0))
push!(monkeys,Monkey([93, 91, 69, 64, 72, 89, 50, 71],x -> x+1,x -> divisible(x,13),5,2,0))
push!(monkeys,Monkey([76, 50],x -> x*x,x -> divisible(x,7),4,6,0))
=#


for i in 1:1000
    for monkey in monkeys
        while length(monkey.items) > 0
            monkey.counter += 1
            item = popfirst!(monkey.items)
            item = monkey.operation(item)
            #item = convert(Int128,floor(item/3))
            if monkey.test(item)
                push!(monkeys[monkey.throw_true+1].items,item)
            else
                push!(monkeys[monkey.throw_false+1].items,item)
            end
        end
    end
end
monkeys
