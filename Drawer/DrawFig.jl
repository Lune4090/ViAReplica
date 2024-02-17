# Initial setting---------------------------------------

using CairoMakie
using CSVFiles, FileIO, DataFrames

include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "DataTrimmer.jl"))
include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "FileManager.jl"))
include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "FitCurve.jl"))
include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Drawer", "DrawXPS.jl"))

set_theme!(Theme(font = "Arial")) # set all font to Arial

# User Control parameters-------------------------------

#= filepicker do pattern matching based on Regex !=#

function draw_figure(
		Search_scope::Union{Nothing, Vector{String}},
		data_type::String,
		data_ext::Union{Nothing, Vector{String}},
		data_foldername::Union{Nothing, Vector{String}},
		xlabel,
		ylabel,
		ignore_flag;
		xps_peakfit_data = nothing,
		xps_normalized_val = nothing
	)

	if data_type == "xps"
		fig = draw_xps(
			Search_scope::Union{Nothing, Vector{String}},
			data_ext::Union{Nothing, Vector{String}},
			data_foldername::Union{Nothing, Vector{String}},
			xlabel,
			ylabel,
			ignore_flag;
			xps_peakfit_data = xps_peakfit_data,
			xps_normalized_val = xps_normalized_val
		)

		display(fig)
		return fig
	else
	  	throw(ErrorException("!!! data_type should be chosen from raman/xrd/xps !!!"))
	end
end
