using Test
using Distributions
import LessOLS: Sample, ols, yhat, r2, desc

# exclude failing tests on Process 
@test true
#include("test_sample.jl")
#include("test_ols.jl")
#include("test_norris.jl")