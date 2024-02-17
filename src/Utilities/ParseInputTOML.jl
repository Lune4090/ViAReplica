using FileIO, TOML

include("FileManager.jl")

"""
read toml file from given folder and return vector of inputfiles dict
"""
function read_inputfiles(root; file_ext = [".toml"], filename = nothing)

    path_inputfile = joinpath(joinpath(splitpath(@__DIR__)[1:end-1]), joinpath(root))

    if !isnothing(filename)
        inputfiles = (filecollector(path_inputfile, detect_exts = file_ext)|> x -> filepicker(x, filename))
    else 
        inputfiles = filecollector(path_inputfile, detect_exts = file_ext)
    end

    read_templates = Vector{Dict}(undef, length(inputfiles))

    for (idx, input) in enumerate(inputfiles)
        read_templates[idx] = TOML.parsefile(input)
    end
    return read_templates 
end
