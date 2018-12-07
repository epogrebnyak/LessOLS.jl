using Test
using Distributions
import LessOLS: Sample, Process, make_sample, ols, yhat, r2, desc

include("test_sample.jl")
include("test_ols.jl")
include("test_norris.jl")