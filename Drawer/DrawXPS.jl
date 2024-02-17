# Initial setting---------------------------------------

using CairoMakie
using CSVFiles, FileIO, DataFrames

include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "DataTrimmer.jl"))
include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "FileManager.jl"))
include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "FitCurve.jl"))

set_theme!(Theme(font = "Arial")) # set all font to Arial

function draw_xps(
		Search_scope::Union{Nothing, Vector{String}},
		data_ext::Union{Nothing, Vector{String}},
		data_foldername::Union{Nothing, Vector{String}},
		xlabel,
		ylabel,
		ignore_flag;
		xps_peakfit_data = nothing,
		xps_normalized_val = nothing
	)

	path_data		= joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), joinpath(Search_scope))
	
	filepaths_data	= (filecollector(path_data, detect_exts = data_ext)
	|> x -> filepicker(x, data_foldername))

	println("### filenames ###\n")
	if filepaths_data != []
		@show filenames_data	= filepaths_data	.|> basename .|> x -> splitext(x)[1]
		results	= filepaths_data	.|> x -> wavedatapacker(x; ignore_icon = ignore_flag)
	end

	# Draw figure-------------------------------------------

	num_data_xps	= 0

	if filepaths_data != []
		num_data_xps	= length(filenames_data)
	end

	colors = [:black]
	is_peakfit = [true]
	len_colors = length(colors)

	figxsize = 600 + 200
	figysize = 450
	fig		= Figure(size = (figxsize, figysize))


	ax = Axis(
				fig[1, 1], titlesize = 30.0f0, yticklabelsvisible = false, xlabel=xlabel, ylabel=ylabel, 
				xlabelsize=30.0f0, ylabelsize=30.0f0, 
				xticklabelsize=30.0f0, yticklabelsize=30.0f0, 
				xgridvisible=false, ygridvisible=false, 
				xticksmirrored=true, xminorticksvisible=true, yticksmirrored=true, yminorticksvisible=true, 
				xtickalign=1, xminortickalign=1, ytickalign=1, yminortickalign=1, 
				xticksize = 16, xminorticksize = 8, yticksize = 8, yminorticksize = 4, 
				xticklabelpad = 3.0, yticklabelpad = 6.0, xreversed = true,
			)

	for i in 1:len_colors
		if !isnothing(xps_normalized_val)
			lines!(ax,
					results[i][1], results[i][2]./xps_normalized_val;
					label = filenames_data[i],
					color = colors[i],
					linewidth = 2.0
					#=color = colors[i],
					colormap = :viridis,
					colorrange = (1, length(colors))=#
			)
		else
			lines!(ax,
					results[i][1], results[i][2];
					label = filenames_data[i],
					color = colors[i],
					linewidth = 2.0
					#=color = colors[i],
					colormap = :viridis,
					colorrange = (1, length(colors))=#
			)
		end

		if !isnothing(xps_peakfit_data)
			for num in 1:length(xps_peakfit_data) 
				curve = Gaussian(
					results[i][1],
					xps_peakfit_data[num][1], 
					xps_peakfit_data[num][2], 
					xps_peakfit_data[num][3]
				)
				
				band!(ax,
					results[i][1],
					results[i][1]*0.0, 
					curve;
					colormap = :viridis,
					colorrange = (1, length(colors))
				)
	
			end
		end
	end

	
	# Draw Legend--------------------------------------------

	elem_ferrocene = [LineElement(color = :black, Linestyle = nothing)]
	elem_peak_1 = [LineElement(color = :blue, Linestyle = nothing)]
	elem_peak_2  = [LineElement(color = :orange, Linestyle = nothing)]
	elem_peak_3  = [LineElement(color = :green, Linestyle = nothing)]
	Legend(fig[:, 2], 
		[elem_ferrocene, elem_peak_1, elem_peak_2, elem_peak_3], 
		[
		"フェロセン",
		"Fe 2p3/2          (Fe3+)", 
		"Fe 2p Satellite (Fe2+)", 
		"Fe 2p1/2          (Fe3+)"
		],
		labelsize = 20.0f0
	)
	return fig
end
