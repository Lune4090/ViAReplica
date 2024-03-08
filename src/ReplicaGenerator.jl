#= Load Library=#
using JLD2
using TOML

#= connect utility files=#
include("Utilities/FileManager.jl")
include("Utilities/DataTrimmer.jl")
include("Utilities/ParseInputTOML.jl")

#= set variable names =#
dir_rawdata = "RawdataStation"
dest_rawdata = "RawdataWarehouse"
dest_replica = "ReplicaHolder"
dir_inputfiles = "Templates"

path_dir_rawdata = joinpath(@__DIR__, dir_rawdata)
path_dest_rawdata = joinpath(@__DIR__, dest_rawdata)
path_dest_replica = joinpath(@__DIR__, dest_replica)
path_dir_inputfiles = joinpath(@__DIR__, dir_inputfiles)


function generate_replica(templatename::String)
	# load template
	template = read_inputfiles(path_dir_inputfiles; filename=templatename)[1]
	data_ext = template["rawdata"]["data"]["ext"]
	# ignore_flag = nothing
	header_commentout = template["rawdata"]["data"]["header_commentout"]

	# generate replica based on template
	replica = template

	# search and retrieve rawdata in dir_rawdata
	paths_rawdata = filecollector(path_dir_rawdata, detect_exts = data_ext)

	if paths_rawdata == []
		println("No file found, check whether rawdata exists in "*path_dir_rawdata*", or try to change searching condition...")
		return nothing
	elseif replica["rawdata"]["data"]["datacollector"] == "wavedatapacker"
		@show filenames_rawdata	= paths_rawdata .|> basename .|> x -> splitext(x)[1]
		rawdata	= paths_rawdata .|> x -> wavedatapacker(x; ignore_icon = header_commentout)
	else
		println("datacollector couldn't be recognized, check whether datacollector is registered in Utilities/DataTrimmer")
		return nothing
	end
	
	# add information to replica and save it
	counter = joinpath(path_dest_rawdata, ".counter.txt")
	packeddata = zip(rawdata, filenames_rawdata, paths_rawdata)
	for (data, filename, path) in packeddata

		file = open(counter, "r")
		num_rawdata = parse(Int, readline(file))+1
		close(file)
		open(joinpath(path_dest_rawdata, ".counter.txt"), "w") do file
			println(file, num_rawdata)
		end

		name_rawdata = string(num_rawdata)*data_ext

		replica["rawdata"]["data"]["name"] = name_rawdata
		replica["root-replica"]["data"]["contents"] = data
		replica["root-replica"]["data"]["size"] = size(data)

		replica["mod-replica"]["data"] = replica["root-replica"]["data"]

		jldsave(joinpath(path_dest_replica, filename*".jld2"); replica)
		mv(path, joinpath(path_dest_rawdata, name_rawdata))
	end
	return nothing
end
