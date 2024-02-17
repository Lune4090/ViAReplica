# Initial setting---------------------------------------

using CairoMakie
using CSVFiles, FileIO, DataFrames

include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "DataTrimmer.jl"))
include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "FileManager.jl"))
include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "FitCurve.jl"))

set_theme!(Theme(font = "Arial")) # set all font to Arial

# User Control parameters-------------------------------

Search_scope	= ["Data"]
data_folder		= "Ref_GO_SiO2"
data_type		= "xrd"
data_foldername	= [data_folder*"/"*data_type]
peakfit_data = nothing
normalized_val = nothing


#= filepicker do pattern matching based on Regex !=#

if data_type == "xrd"
	data_ext		= [".ras"]
	filter_name		= [".ras"]
	xlabel = "2θ (deg)"
	ylabel = "Intensity (cps)"
	ignore_flag = "*"
else
	throw(ErrorException("!!! data_type should be chosen from raman/xrd/xps !!!"))
end

savename = nothing
savename = "/home/lune/BachelorPaper/fig_chap03/"*data_folder*"_"*data_type*".png"
@show savename

# Collect data------------------------------------------

function show_description(
		Search_scope::Union{Nothing, Vector{String}},
		data_ext::Union{Nothing, Vector{String}},
		data_foldername::Union{Nothing, Vector{String}},
		xlabel,
		ylabel,
		data_type,
		ignore_flag,
		filter_name,
		xps_peakfit_data,
		xps_normalized_val
	)

	path_data		= joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), joinpath(Search_scope))
	
	filepaths_data	= (filecollector(path_data, detect_exts = data_ext)
	|> x -> filepicker(x, data_foldername)
	|> x -> filepicker(x, filter_name))

	println("### filenames ###\n")
	if filepaths_data != []
		@show filenames_data	= filepaths_data	.|> basename .|> x -> splitext(x)[1]
		results	= filepaths_data	.|> x -> wavedatapacker(x; ignore_icon = ignore_flag)
		# is_linear_to_log10 = true 
		# is_linear_to_log10 ? results = results .|> x -> [x[1], log10.(abs.(x[2]))] : 0
	end

	
	# Draw figure-------------------------------------------

	fig	= Figure( #= size = (600, 450) =# )

	ax = Axis(fig[1, 1],titlesize = 30.0f0, xlabel=xlabel, ylabel=ylabel, xlabelsize=30.0f0, ylabelsize=30.0f0, xticklabelsize=30.0f0, yticklabelsize=30.0f0, xgridvisible=false, ygridvisible=false, xticksmirrored=true, xminorticksvisible=true, yticksmirrored=true, yminorticksvisible=true, xtickalign=1, xminortickalign=1, ytickalign=1, yminortickalign=1, xticksize = 16, xminorticksize = 8, yticksize = 16, yminorticksize = 8, xticklabelpad = 6.0, yticklabelpad = 6.0)

	num_data = 0

	if filepaths_data != []
		num_data	= length(filenames_data)
	end

	if num_data > 1
		colors = 1:num_data

		for idx in 1:num_data
			lines!(ax,
				   results[idx][1], results[idx][2];
				   label = filenames_data[idx],
				   color = colors[idx],
				   colormap = :viridis,
				   colorrange = (1, length(colors)))
		end
	else
		lines!(ax, results[1][1], results[1][2];
				label = filenames_data[1],
				color = :black)
	end


	# temp

	peak_pos = (26.5, 2800)
	gap = (3.0, -300)	
	text!(ax, peak_pos[1] + gap[1], peak_pos[2] + gap[2], text = "(002)", align = (:center, :center))
	
	display(fig)	
	return fig
end


# Draw figure & save it-------------------------------------

figure = show_description(
	Search_scope, 
	data_ext, 
	data_foldername, 
	xlabel, 
	ylabel, 
	data_type, 
	ignore_flag, 
	filter_name, 
	peakfit_data,
	normalized_val
)

!isnothing(savename) ? save(savename, figure) : nothing
