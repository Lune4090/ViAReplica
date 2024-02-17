using CairoMakie

function Gaussian(input_vec::Vector{Float64}, 
    a::Float64, σ::Float64, mean::Float64;
    instant_drawing = false)

    output_vec = (a/(σ*sqrt(2π))).*exp.((-1/2).*(((input_vec .- mean) /σ).^2))

    if instant_drawing
        fig = Figure()
        ax = Axis(fig[1, 1])
        lines!(ax, input_vec, output_vec)
        display(fig)
    end
    return output_vec   
end

function gaussian1D(input_x::Vector{Float64}, 
    a::Float64, σ::Float64, mean::Float64;)

    return (a/(σ*sqrt(2π))).*exp.((-1/2).*(((input_x .- mean) /σ).^2))
end

function gaussian2D(input_xy::Vector{Vector{Float64}}, 
    amp::Float64, σx::Float64, σy::Float64, mean_x::Float64, mean_y::Float64, θ::Float64, offset;)

    a = (cos(θ)^2)/(2*σx^2) + (sin(θ)^2)/(2*σy^2)
    b = -(sin(2*θ))/(4*σx^2) + (sin(2*θ))/(4*σy^2)
    c = (sin(θ)^2)/(2*σx^2) + (cos(θ)^2)/(2*σy^2)

    # creating linear meshgrid from xy
    x = input_xy[:, 1]
    y = input_xy[:, 2]
    g = offset .+ amp .* exp.( - (a.*((x .- mean_x).^2) + 2 .* b .* (x .- mean_x) .* (y .- mean_y) + c * ((y .- mean_y).^2)))
    return g
end
