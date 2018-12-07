using Test
using Distributions
import LessOLS: Process, make_sample, ols

include("sample.jl")

    

uniform(a, b, k) = n -> rand(Uniform(a, b), n, k)
linear(β_0, β) = X -> β_0 .+ X * β
normal_noise(sd_e) = X -> rand(Normal(0, sd_e), size(X, 1), 1)
p=Process(x=uniform(0, 20, 2),
          y=linear(0, [1.25, 6.3]),
          e=normal_noise(0.2)) 
sam = make_sample(p, 100)
lm = ols(sam)
@test all(lm.beta - [1.25, 6.3] .< 0.1)