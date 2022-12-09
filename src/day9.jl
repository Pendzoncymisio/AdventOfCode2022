using DelimitedFiles
using Agents

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day9.txt"),' ')

@agent Knot GridAgent{2} begin
    type::Bool #true when head, false when tail
end

function initialize_model()
    space = GridSpace((1000, 1000), metric=:chebyshev, periodic = false)
    properties = Dict(:step => 1, :row => 1, :move => "R", :direction_dict => Dict("R"=>(1,0),"L"=>(-1,0),"U"=>(0,1),"D"=>(0,-1)), :head_prev_pos => (50,50), :head_history =>[], :tail_history => [])
    model = ABM(Knot, space; properties = properties, scheduler = Schedulers.by_id)

    head = Knot(1, (500, 500), true)
    add_agent!(head, (500, 500), model)

    tail = Knot(2, (500, 500), false)
    add_agent!(tail, (500, 500), model)
    
    return model
end

function agent_step!(agent, model)
    if agent.type #move head
        model.head_prev_pos = agent.pos
        walk!(agent,model.direction_dict[model.move],model)
    else #move tail
        if max(abs(model[1].pos[1] - agent.pos[1]),abs(model[1].pos[2] - agent.pos[2])) > 1
            move_agent!(agent,model.head_prev_pos,model) 
        end
    end
end

function model_step!(model)
    #println(model.step,model[1].pos,model[2].pos)
    model.step += 1
    push!(model.head_history,model[1].pos)
    push!(model.tail_history,model[2].pos)
end

function part1(input_array, model)

    for row in eachrow(input_array)
        model.move = row[1]
        step!(model,agent_step!,model_step!,row[2])
    end
    length(Set(model.tail_history))
end

part1(input_array, initialize_model())