import LessOLS: normal_sampler, ols, show, equation

# create sample with known properties
ns = normal_sampler(a=0, b=20, β_0=5, β=[1, 2.5], sd_e=0.5)
sample1 = ns(100000)

# attempt a linear model
lm1 = ols(sample1, intercept=false)
show(lm1)

# check the coefficients are about right (for a model with zero intercept)
function almost_equals(a, b, threshold)
    diff = map(abs, (a-b))
    return all(diff .< threshold)
end    
@assert almost_equals(lm1.beta, [1.2143, 2.713], 0.01)

