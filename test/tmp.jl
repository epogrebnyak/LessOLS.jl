using Test
import LessOLS: Process, make_sample, sampler_normal, ols, desc, show, yhat, equation

# # use profiler
# # https://thirld.com/blog/2015/05/30/julia-profiling-cheat-sheet/

gen = sampler_normal(a=0, b=20, β_0=5, β=[1, 2.5], sd_e=0.5)
sam = gen(100)
lm = ols(sam, intercept=true)
show(lm)

@assert equation([-1/3, -2/7, 1/29],true,4) == "Y = -0.3333 - 0.2857*X1 + 0.0345*X2"
