function HistogramMaker(fig::Figure, dfVec::Vector{DataFrame}, DataName::String, numgrids::Int; ScreenHeight=1200, GridWidth=300, ColorVec=[], xlabel = "ParticleSize (μm²)", ylabel = "counts", is_zero_start=true, is_interactive=true)
    ScreenWidth = GridWidth * length(dfVec)

    #colorbar = [:blue, :lightgreen, :orange]

    AxVec = []
    SliderVec = []
    NumOfParicles = []
    ParticleAreas = []

    for i in eachindex(dfVec)
        # Make Axis
        push!(AxVec, Axis(fig[1, i], xlabel=xlabel, ylabel=ylabel, xlabelsize=20.0f0, ylabelsize=20.0f0, xticklabelsize=20.0f0, yticklabelsize=20.0f0, xgridvisible=false, ygridvisible=false, xticksmirrored=true, xminorticksvisible=true, yticksmirrored=true, yminorticksvisible=true, xtickalign=1, xminortickalign=1, ytickalign=1, yminortickalign=1, xticksize = 8, xminorticksize = 4, yticksize = 8, yminorticksize = 4, xticklabelpad = 3.0, yticklabelpad = 3.0 ))
        # Get Dataframe and sets basic parameter to draw graph
        df = dfVec[i]
        data = df[!, DataName]
        Max = findmax(identity, df[:, DataName])[1]
        Min = is_zero_start ? 0 : findmin(identity, df[:, DataName])[1]
        gridwidth = (Max - Min) / numgrids

        # Draw Histogram
        if length(ColorVec) == length(dfVec)
            hist!(AxVec[i], data, strokewidth=0.5, bins=numgrids, color=ColorVec[i])
        elseif length(ColorVec) != 0
            error("ColorVec Length should be same to dfVec")
        else
            hist!(AxVec[i], data, strokewidth=0.5, bins=numgrids, color=:lightblue)
        end

        if is_interactive
            # Add Interactive Slider
            push!(SliderVec, Slider(fig[2, i], range=0:gridwidth:Max, startvalue=Min))

            # Show paricle num
            num_particles = lift(CountDataInGivenGrid, SliderVec[i].value, data, gridwidth)
            num_particles_str = lift(StringDecorator, num_particles, "The number of particles : ")
            push!(NumOfParicles, Label(fig[3, i], num_particles_str, width=GridWidth))

            # Show Current Diameter
            Areas_str = lift(StringDecorator, SliderVec[i].value, "Areas[μm^2] : ")
            push!(ParticleAreas, Label(fig[4, i], Areas_str, width=GridWidth))
        end

    	colsize!(fig.layout, i, Fixed(GridWidth))
    end

    
	

    display(fig)
    return fig
end
    
