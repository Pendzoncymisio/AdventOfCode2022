using DelimitedFiles
using Agents
using CSV
using InteractiveDynamics
using CairoMakie

input_array = readdlm(joinpath(@__DIR__,"..","inputs","day9.txt"),' ')

@agent Knot GridAgent{2} begin
    type::Bool #true when head, false when tail
end

function initialize_model(input_array)
    grid_dim = (1000,1000)
    space = GridSpace(grid_dim, metric=:chebyshev, periodic = false)
    properties = Dict(:step => 1,
                    :row => 1,
                    :row_move => 0,
                    :move => "D",
                    :input_array=> input_array,
                    :direction_dict => Dict("R"=>(1,0),"L"=>(-1,0),"U"=>(0,1),"D"=>(0,-1)),
                    :head_prev_pos => (500,500),
                    :head_history => [],
                    :tail_history => [],
                    )
    model = ABM(Knot, space; properties = properties, scheduler = Schedulers.by_id)
    model.move = model.input_array[1]

    head = Knot(1, Int.(grid_dim./ 2), true)
    add_agent!(head, Int.(grid_dim./ 2), model)

    tail = Knot(2, Int.(grid_dim./ 2), false)
    add_agent!(tail, Int.(grid_dim./ 2), model)
    
    return model
end

function agent_step!(agent, model)
    if agent.type #move head
        model.head_prev_pos = agent.pos
        walk!(agent,model.direction_dict[model.move],model; ifempty = false)
    else #move tail
        if max(abs(model[1].pos[1] - agent.pos[1]),abs(model[1].pos[2] - agent.pos[2])) > 1
            move_agent!(agent,model.head_prev_pos,model) 
        end
    end
end

function model_step!(model)
    #println(model.row," ",model.row_move," ",model.move)
    model.row_move += 1
    if model.row_move == model.input_array[model.row,2]
        model.row_move = 0
        model.row += 1
        model.move = model.input_array[model.row,1]
    end
    model.step += 1
    push!(model.head_history,model[1].pos)
    push!(model.tail_history,model[2].pos)
end

function n(model,step)
    step < sum(model.input_array[:,2]) - 1 && return false
    return true
end

function part1(model)
    adata = [:type, :pos]
    agent_df, model_df = run!(model, agent_step!, model_step!, n; adata)

    print(agent_df)
    #CSV.write(joinpath(@__DIR__,"..","inputs","day9_output.csv"), agent_df)

    length(Set(model.tail_history))
end

model = initialize_model(input_array)
part1(model) #add 1 to final solution 
#=
groupcolor(a) = a.type ? :blue : :orange
abmvideo(
        joinpath(@__DIR__,"..","inputs","day9_video.mp4"), initialize_model(input_array), agent_step!, model_step!;
        ac = groupcolor, am = :rect, as = 10,
        framerate = 1, frames = 1000,
        title = "Catching the head"
    )
    =#