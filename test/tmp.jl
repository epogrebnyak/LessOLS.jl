using Test
using LessOLS: Process, make_sample, sampler_normal, ols, desc, show

gen = sampler_normal(a=0, b=20, β_0=5, β=[1, 2.5], sd_e=0.5)
sam = gen(100)
lm = ols(sam, intercept=true)
show(lm)

