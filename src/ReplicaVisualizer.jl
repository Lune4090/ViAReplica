#= Load Library=#
using JLD2
using TOML
using CairoMakie

#= connect utility files=#
include("Utilities/FileManager.jl")
include("Utilities/DataTrimmer.jl")
include("Utilities/ParseInputTOML.jl")

#= set variable names =#
dir_rawdata = "RawdataStation"
dest_rawdata = "RawdataWarehouse"
dest_replica = "ReplicaHolder"
dir_inputfiles = "Templates/Generator"

path_dir_rawdata = joinpath(@__DIR__, dir_rawdata)
path_dest_rawdata = joinpath(@__DIR__, dest_rawdata)
path_dest_replica = joinpath(@__DIR__, dest_replica)
path_dir_inputfiles = joinpath(@__DIR__, dir_inputfiles)

function visualize_replica(replicaname::String)
    replica = read_inputfiles(path_dest_replica; filename=replicaname)[1]
    visualize_options = replica["mod-replica"]["visualization"]

    if visualize_options["template"] != ""
        visualize_options = read_inputfiles(path_dest_replica; filename=visualize_options["template"])[1]["mod-replica"]["visualization"]
    else
        visualizer = ":(Axis("
        keys = keys(visualize_options["axis"])
        for option in keys
            visualizer = visualizer*String(option)*"="*String(get(visualize_options["axis"], option, nothing))*","
        end
        visualizer = visualizer*"))"
        eval(visualizer)
    end
end
