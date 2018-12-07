__precompile__(false)
module LessOLS
using Distributions: Normal, Uniform
using Statistics: mean

include("sample.jl")
include("lm.jl")

end # module