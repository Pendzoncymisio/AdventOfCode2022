using DelimitedFiles
using Pipe
using Agents
using CSV
using InteractiveDynamics
using CairoMakie

input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day24.txt"),';',String) .|> 
    split(_,"") |> 
    mapreduce(permutedims, vcat, _) |> 
    getindex.(_,1) |>
    _[2:end-1,2:end-1]


@agent Blizzard GridAgent{2} begin
    move::Char #<>^v
end

function initialize_model(input_array)
    grid_dim = size(input_array)
    space = GridSpace(grid_dim, periodic = true)
    properties = Dict(:step => 1,
                    :direction_dict => Dict('>'=>(0,1),'<'=>(0,-1),'^'=>(-1,0),'v'=>(1,0), '.'=>(0,0)),
                    :started => false,
                    :available_spaces => [],
                    :max_distance => 0,
                    :sim_phase => 1,
                    :sim_finished => false,
                    :i_am_outside_space => false,
                    :i_am_turning_around => false,
                    :phases_to_go => 1,
                    )
    model = ABM(Blizzard, space; properties = properties, scheduler = Schedulers.by_id)

    i = 1
    for (ind, val) in pairs(input_array)
        if val != '.'
            tmp_agent = Blizzard(i, Tuple(ind), val)
            add_agent!(tmp_agent, Tuple(ind), model)
            i += 1
        end
    end
    return model
end

function agent_step!(agent, model)
    walk!(agent,model.direction_dict[agent.move],model; ifempty = false)    
end

function go_back(model)
    model.i_am_turning_around = true
    if model.i_am_turning_around && !model.i_am_outside_space
        model.available_spaces = []
        model.i_am_outside_space = true
    elseif model.i_am_turning_around && model.i_am_outside_space
        model.i_am_turning_around = false
        model.i_am_outside_space = false
    end
end

function model_step!(model)
    if model.sim_phase % 2 == 1 && isempty((1,1), model) 
        push!(model.available_spaces, (1,1))
    elseif model.sim_phase % 2 == 0 && isempty(size(model.space), model)
        push!(model.available_spaces, size(model.space))
    end
    new_fields = []
    for field in model.available_spaces
        for dir in values(model.direction_dict)
            check_field = field .+ dir
            try
                if isempty(check_field, model) && (check_field[1] + check_field[2] >= model.max_distance - 150)
                    push!(new_fields, check_field)
                    if check_field[1] + check_field[2] > model.max_distance
                        model.max_distance = check_field[1] + check_field[2]
                    end
                end
            catch e
                if typeof(e) != BoundsError
                    throw(e)
                end
            end
        end
    end
    model.available_spaces = unique(new_fields)
    model.step += 1;

    if model.sim_phase % 2 == 1 && size(model.space) in model.available_spaces
        model.phases_to_go == model.sim_phase && (model.sim_finished = true) # Finish simulation if last phase
        model.sim_phase += 1
        go_back(model)
    elseif model.sim_phase % 2 == 0 && (1, 1) in model.available_spaces
        model.phases_to_go == model.sim_phase && (model.sim_finished = true) # Finish simulation if last phase
        model.sim_phase += 1
        go_back(model)
    elseif model.i_am_turning_around
        go_back(model)
    end
end

function n(model, step) #step when false
    return model.sim_finished
end


function parts(input_array, phases_to_go)
    model = initialize_model(input_array)
    model.phases_to_go = phases_to_go
    adata = [:pos]
    mdata = [:sim_phase,:available_spaces]
    agent_df, model_df = run!(model, agent_step!, model_step!, n; adata, mdata)

    #print(agent_df)
    CSV.write(joinpath(@__DIR__,"..","inputs","day24_output.csv"), model_df)
    return model.step
end

println("Part1: ",parts(input_array, 1))
println("Part2: ",parts(input_array, 3))

#= OUTPUTTING ANIMATING GRAPH
am(a) = a.move

abmvideo(
        joinpath(@__DIR__,"..","inputs","day24_video.mp4"), initialize_model(input_array), agent_step!, model_step!;
        #ac = groupcolor, 
        am = am, as = 50,
        framerate = 1, frames = 30,
        title = "Catching the head"
    )

=#