using DelimitedFiles
using Pipe
#using LightGraphs
using Graphs
using MetaGraphs


input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day21.txt"),' ',String)
input_array[:,1] = chop.(input_array[:,1])

function generate_graph(input_array)
    main_graph = MetaGraph()
    set_indexing_prop!(main_graph, :name)

    nodes_dict = Dict()

    for (i, row) in enumerate(eachrow(input_array))
        add_vertices!(main_graph, 1)
        set_prop!(main_graph, i, :name, row[1])

        if row[1] == "humn"
            set_prop!(main_graph, i, :humn_branch, true)
        else
            set_prop!(main_graph, i, :humn_branch, false)
        end

        try
            num = parse(Int64, row[2])
            set_prop!(main_graph, i, :value, num)
        catch e
            if typeof(e) <: ArgumentError
                set_prop!(main_graph, i, :arg1, row[2])
                set_prop!(main_graph, i, :op, row[3])
                set_prop!(main_graph, i, :arg2, row[4])
            end
        end
    end

    return main_graph
end

function solve_node(main_graph, node_name)
    node_num = main_graph[node_name, :name]
    try
        return get_prop(main_graph, node_num, :value)
    catch e
        if typeof(e) <: KeyError
            arg1 = get_prop(main_graph, node_num, :arg1)
            arg2 = get_prop(main_graph, node_num, :arg2)
            op = get_prop(main_graph, node_num, :op)
            return eval(Expr(:call, Meta.parse(op), Int64(solve_node(main_graph, arg1)),Int64(solve_node(main_graph, arg2))))
        end
    end
end

function part1(input_array)
    main_graph = generate_graph(input_array)
    solve_node(main_graph, "root")
end

println("Part1: ",part1(input_array))

function solve_humn(main_graph, value_to_get, node_name)
    if node_name == "humn"
        return value_to_get
    end

    node_num = main_graph[node_name, :name]

    arg1 = get_prop(main_graph, node_num, :arg1)
    arg2 = get_prop(main_graph, node_num, :arg2)

    op = get_prop(main_graph, node_num, :op)

    node_num_arg1 = main_graph[arg1, :name]
    node_num_arg2 = main_graph[arg2, :name]
    is_arg1_humn_branch = get_prop(main_graph, node_num_arg1, :humn_branch)

    if is_arg1_humn_branch
        humn_branch_node_name = arg1
        const_value = get_prop(main_graph, node_num_arg2, :value)
    else
        humn_branch_node_name = arg2
        const_value = get_prop(main_graph, node_num_arg1, :value)
    end

    if op == "+"
        new_value_to_get = value_to_get - const_value
    elseif op == "-"
        if is_arg1_humn_branch
            new_value_to_get = value_to_get + const_value
        else
            new_value_to_get = const_value - value_to_get
        end
    elseif op == "*"
        new_value_to_get = value_to_get / const_value
    else
        if is_arg1_humn_branch
            new_value_to_get = const_value * value_to_get
        else
            new_value_to_get = const_value / value_to_get
        end
    end

    return Int64(solve_humn(main_graph, new_value_to_get, humn_branch_node_name))
end

function solve_node_two(main_graph, node_name)
    node_num = main_graph[node_name, :name]
    try
        return get_prop(main_graph, node_num, :value), get_prop(main_graph, node_num, :humn_branch)
    catch e
        if typeof(e) <: KeyError
            arg1 = get_prop(main_graph, node_num, :arg1)
            arg2 = get_prop(main_graph, node_num, :arg2)
            op = get_prop(main_graph, node_num, :op)
            solve_arg1, is_humn_branch_arg1 = solve_node_two(main_graph, arg1)
            solve_arg2, is_humn_branch_arg2 = solve_node_two(main_graph, arg2)

            if node_name==="root"
                if is_humn_branch_arg1
                    return solve_humn(main_graph, solve_arg2, arg1)
                else
                    return solve_humn(main_graph, solve_arg1, arg2)
                end
            end

            is_humn_branch = false
            if is_humn_branch_arg1 || is_humn_branch_arg2
                is_humn_branch = true
            end
            
            num = eval(Expr(:call, Meta.parse(op), Int64(solve_arg1),Int64(solve_arg2)))
            set_prop!(main_graph, node_num, :value, num)
            set_prop!(main_graph, node_num, :humn_branch, is_humn_branch)
            return (num, is_humn_branch)
        end
    end
end

function part2(input_array)
    main_graph = generate_graph(input_array)
    return solve_node_two(main_graph, "root")
end

println("Part2: ",part2(input_array))