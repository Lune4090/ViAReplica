function dfloader(path::String)
    return path |> path_to_df -> load(path_to_df) |> df -> DataFrame(df)
end

function Cutoff!(df::DataFrame, upperthreshold::Float64)
    for idx in 1:size(df, 1)
        @show idx, df.Area[idx]
        df.Area[idx] > upperthreshold ? df.Area[idx] = upperthreshold : Nothing
    end
end

function CountDataInGivenGrid(base, vec, step)
    num = 0
    for val in vec
        if base[] <= val < base[] + step
            num += 1
        end
    end
    return num
end

function StringDecorator(decorated, decorator::String)
    return decorator * lift(string, decorated[])
end

function AdjustUnit!(df::DataFrame, row_name::String, coeff::Real)
    df[:, row_name] = df[:, row_name] .* coeff
end

"""
This function can treat only simple Vector{float64}.
Be sure that the data can be converted by this function.
"""
function wavedatapacker(file; ignore_icon::Union{Nothing, String} = nothing)
	# 2列のFloat64であることを仮定
    vec1 = Vector{Float64}(undef, 0)
    vec2 = Vector{Float64}(undef, 0)
    for line in eachline(file)
		if line != "" && line[1] ∉ ignore_icon			# consider only top 1 char
			splitted_line = line |> split .|> string
            if length(splitted_line) == 1
                splitted_line = splitted_line[1] |> x -> split(x, ",") .|> string
            end
            data_line = copy(splitted_line)
			if length(data_line) >= 2
        	    data1 = parse(Float64, data_line[1])
				data2 = parse(Float64, data_line[2])
	            push!(vec1, data1)
    	        push!(vec2, data2)
			end
        end
    end
	return [vec1, vec2]
end
