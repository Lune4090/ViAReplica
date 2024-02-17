"""
Return Vector("file_path")
begin_dir have to be an absolute path at now
"""
function filecollector(begin_dir::String; 
		detect_exts::Union{Nothing, String, Vector{String}} = nothing, 
		ignore_exts::Union{Nothing, String, Vector{String}} = nothing)
    # error handling
    
	!isdir(begin_dir) && ArgumentError("begin_dir is not correct")
    
	if !isnothing(detect_exts) && !isnothing(ignore_exts)
        ArgumentError("you can set only one of detect_exts or ignore_exts")
    end

	if typeof(detect_exts)==String
		detect_exts = [detect_exts]
	end
	if typeof(ignore_exts)==String
		ignore_exts = [ignore_exts]
	end
	
	# check whether args are correct format
	if !isnothing(detect_exts)
		for detect_ext in detect_exts
			detect_ext[1] != '.' && throw(ArgumentError("in $detect_exts,  $detect_ext must include initial '.'"))
		end
	end

	if !isnothing(ignore_exts)
		for ignore_ext in ignore_exts
			ignore_ext[1] != '.' && throw(ArgumentError("in $detect_exts,  $detect_ext must include initial '.'"))
		end
	end
    # pack file paths into a vector
    filepaths = Vector{String}()
    for (root, dirs, files) in walkdir(begin_dir)
        for file in files
            if !isnothing(detect_exts)
                splitext(file)[end] ∈ detect_exts && push!(filepaths, joinpath(root, file))
            elseif !isnothing(ignore_exts)
                splitext(file)[end] ∉ ignore_exts && push!(filepaths, joinpath(root, file))
            else
                push!(filepaths, joinpath(root, file))
            end
        end
    end
    return filepaths
end

function filepicker(target_files::Vector{String}, searchStrs::Union{Nothing, String, Regex, Vector{String}, Vector{Regex}})
	if typeof(searchStrs) == String || typeof(searchStrs) == Regex
		searchStrs = [searchStrs]
	end
	matchedStrs = Vector{String}(undef, 0)
	isnothing(searchStrs) && return matchedStrs
	for txtfile in target_files	
		map(x -> occursin(x, txtfile) ? push!(matchedStrs, txtfile) : nothing, searchStrs) 
	end
	return matchedStrs
end
