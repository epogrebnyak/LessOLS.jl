import LessOLS: normal_sampler, ols, show, betas, equation

ns = normal_sampler(a=0, b=20, β_0=5, β=[1, 2.5], sd_e=0.5)
sample1 = ns(100)
lm1 = ols(sample1, intercept=false)
show(lm1)
#@assert equation([-1/3, -2/7, 1/29],true,4) == "Y = -0.3333 - 0.2857*X1 + 0.0345*X2"
# TODO  use approx(a, b)
betas(lm1)
