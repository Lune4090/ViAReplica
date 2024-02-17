using CairoMakie: draw_single
using CairoMakie
using CSVFiles, FileIO, DataFrames
using TOML

include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Interface", "ParseInputTOML.jl"))
include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "DataTrimmer.jl"))
include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Function", "FileManager.jl"))
include(joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), "Drawer", "DrawFig.jl"))

@show inputfiles = read_inputfiles()

for (idx, input) in enumerate(inputfiles)

    folder_root = ["Data"]
    data_loc = input["datalocation"]
    drawing_info = input["drawinginfo"]
    additional_info = input["additionalinfo"]

    folder_name = data_loc["folder"] 
    data_type = data_loc["datatype"] 
    file_name = data_loc["file"]

    if !haskey(drawing_info, "instant_draw")
     	throw(ErrorException("!!! input toml file have to contain instant_draw !!!"))
    else
        is_instant_draw = drawing_info["instant_draw"]
    end

    if is_instant_draw

        if haskey(drawing_info, "filter")
            filter = drawing_info["filter"]
        else
            filter = nothing
        end 

        data_location = joinpath(
            folder_name,
            data_type,
            file_name
        )

        if data_type == "raman"
        	data_ext		= [".txt"]
        	xlabel = "Wavenumber (cm⁻¹)"
        	ylabel = "Intensity (cps)"
        	ignore_flag = "#"
        elseif data_type == "xrd"
        	data_ext		= [".ras"]
        	xlabel = "2θ (deg)"
        	ylabel = "Intensity (cps)"
        	ignore_flag = "*"
        elseif data_type == "xps"
        	data_ext		= [".txt"]
        	xlabel = "Wavenumber (cm⁻¹)"
        	ylabel = "Intensity (a.u.)"
        	ignore_flag = "#"
        	peakfitdata = haskey(additional_info, "peakfitdata") ? additional_info["peakfitdata"] : nothing
            @show peakfitdata
        else
        	throw(ErrorException("!!! data_type should be chosen from raman/xrd/xps !!!"))
        end

        savename = nothing
        savename = "/home/lune/Downloads/"*folder_name*"_"*data_type*"_"*".png"
        # savename = "/home/lune/BachelorPaper/fig_chap03/"*data_folder*"_"*data_type*".png"
        @show savename

        figure = draw_figure(
        	folder_root,
            data_type, 
        	data_ext, 
        	[data_location], 
        	xlabel, 
        	ylabel, 
        	ignore_flag, 
        	xps_peakfit_data = peakfitdata,
        )

        !isnothing(savename) ? save(savename, figure) : nothing

    else
        
    end

end

# Collect data------------------------------------------

