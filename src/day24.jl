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

function try_kickstarting(model)
    if isempty((1,1), model) 
        push!(model.available_spaces, (1,1))
        model.started = true
    end
end

function model_step!(model)
    model.started || try_kickstarting(model)
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
    println(model.step," ",length(new_fields)," ", model.max_distance)
    model.step += 1;
end

function n(model, step) #step when false
    if step < 10000 && !(size(model.space) in model.available_spaces)
        return false
    end
    return true
end

model = initialize_model(input_array)

function part1(model)
    adata = [:pos]
    mdata = [:available_spaces]
    agent_df, model_df = run!(model, agent_step!, model_step!, n; adata, mdata)

    #print(agent_df)
    CSV.write(joinpath(@__DIR__,"..","inputs","day24_output.csv"), model_df)
    println(model.step)
end

part1(model)

#=
am(a) = a.move

abmvideo(
        joinpath(@__DIR__,"..","inputs","day24_video.mp4"), initialize_model(input_array), agent_step!, model_step!;
        #ac = groupcolor, 
        am = am, as = 50,
        framerate = 1, frames = 20,
        title = "Catching the head"
    )
=#