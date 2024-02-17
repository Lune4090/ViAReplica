function xrd_data_packer(file)
    packeddata = []
    for line in eachline(file)
	str_vec =  split(line, " ")
        if str_vec[1][1] != '*'
            push!(packeddata, (parse(Float64, str_vec[1]), parse(Float64, str_vec[2])))
        end
    end
    return packeddata
end
