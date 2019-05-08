using Test
#using Distributions
#import LessOLS: Sample, ols, yhat, r2, desc

# Testing workflow discovered:
# https://discourse.julialang.org/t/mac-resolving-package-versions-takes-a-long-time/16905/13

include("test_sample.jl")
include("test_ols.jl")
include("test_norris.jl")