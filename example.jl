import LessOLS: normal_sampler, ols, show, betas, equation

ns = normal_sampler(a=0, b=20, β_0=5, β=[1, 2.5], sd_e=0.5)
sample1 = ns(100000)
lm1 = ols(sample1, intercept=false)
show(lm1)
function almost_equals(a, b, threshold)
    diff = map(abs, (a-b))
    return all(diff .< threshold)
end    
@assert almost_equals(lm1.beta, [1.2143, 2.713], 0.01)

