using DelimitedFiles
using Pipe
using Agents
using CSV
using DataStructures
using InteractiveDynamics
using CairoMakie

input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day23.txt"),';',String) .|> 
    split(_,"") |> 
    mapreduce(permutedims, vcat, _) |> 
    getindex.(_,1)

@agent Elf GridAgent{2} begin
    moving::Bool
    proposed_position::Tuple{Int,Int}
end

function init_deque()
    a = CircularDeque{Char}(4)
    push!(a, 'N')
    push!(a, 'S')
    push!(a, 'W')
    push!(a, 'E')
    return a
end

function initialize_model(input_array)
    margin = 20
    grid_dim = size(input_array) .+ margin * 2
    space = GridSpaceSingle(grid_dim, periodic = false)

    properties = Dict(:step_calc => 1,
                    :direction_dict => Dict('E'=>(0,1),'W'=>(0,-1),'N'=>(-1,0),'S'=>(1,0)),
                    :direction_deque => init_deque(),
                    :direction_neigh => Dict('E'=>('N','S'),'W'=>('N','S'),'N'=>('E','W'),'S'=>('E','W')),
                    :sim_phase => :proposing,
                    )
    model = ABM(Elf, space; properties = properties, scheduler = Schedulers.by_id)

    i = 1
    for (ind, val) in pairs(input_array)
        if val == '#'
            tmp_agent = Elf(i, Tuple(ind).+ margin, false, (-1,-1))
            add_agent!(tmp_agent, Tuple(ind) .+ margin, model)
            i += 1
        end
    end
    return model
end

function agent_step!(agent, model)
    if model.sim_phase == :proposing
        
        if length(collect(nearby_ids(agent, model, 1))) != 0
            for direction in model.direction_deque
                if isempty(agent.pos .+ model.direction_dict[direction],model) &&
                        isempty(agent.pos .+ model.direction_dict[direction] .+ model.direction_dict[model.direction_neigh[direction][1]],model) &&
                        isempty(agent.pos .+ model.direction_dict[direction] .+ model.direction_dict[model.direction_neigh[direction][2]],model)

                    agent.proposed_position = agent.pos .+ model.direction_dict[direction]
                    agent.moving = true
                    break
                end
            end
        end
    elseif model.sim_phase == :solving
        for neighboor in nearby_agents(agent, model, 2)
            if neighboor.proposed_position == agent.proposed_position
                agent.moving = false
            end
        end

    else # when reached then model.sim_phase = :moving
        if agent.moving
            move_agent!(agent,agent.proposed_position,model)
            agent.moving = false
            agent.proposed_position = (-1,-1)
        end
    end
end

function model_step!(model)
    

    #Switch phase and add step number
    if model.sim_phase == :proposing
        model.sim_phase = :solving
    elseif model.sim_phase == :solving
        model.sim_phase = :moving
    else
        #Circle the proposing direction
        direction = popfirst!(model.direction_deque)
        push!(model.direction_deque, direction)

        model.sim_phase = :proposing
        model.step_calc += 1
    end
end

function n_part1(model, step) #step when false
    model.step_calc > 10 && return true
    
    return false
end



function part1(input_array)
    model = initialize_model(input_array)
    adata = [:pos]
    mdata = [:step_calc]
    agent_df, model_df = run!(model, agent_step!, model_step!, n_part1; adata, mdata)

    #print(agent_df)
    CSV.write(joinpath(@__DIR__,"..","inputs","day23_output.csv"), agent_df)

    min_y,max_y = trunc(Int, spacesize(model)[1]/2), trunc(Int, spacesize(model)[1]/2)
    min_x,max_x = trunc(Int, spacesize(model)[2]/2), trunc(Int, spacesize(model)[2]/2)
    #Find smallest square
    for tmp_agent in allagents(model)
        tmp_agent.pos[1] < min_y && (min_y = tmp_agent.pos[1])
        tmp_agent.pos[1] > max_y && (max_y = tmp_agent.pos[1])
        tmp_agent.pos[2] < min_x && (min_x = tmp_agent.pos[2])
        tmp_agent.pos[2] > max_x && (max_x = tmp_agent.pos[2])
    end

    counter = 0
    for y in min_y:max_y, x in min_x:max_x
        isempty((y,x),model) && (counter += 1)
        #println(x,y,counter)
    end

    return counter, model
end
counter, model = part1(input_array)
println("Part1: ",counter)
#=
abmvideo(
        joinpath(@__DIR__,"..","inputs","day24_video.mp4"), initialize_model(input_array), agent_step!, model_step!;
        #ac = groupcolor, 
        am = '●', as = 30,
        framerate = 1, frames = 31,
        title = "Catching the head"
    )=#

