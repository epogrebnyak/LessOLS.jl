import LessOLS: normal_sampler, ols, show, desc, yhat, r2, equation

function almost_equals(a, b, threshold)
    diff = map(abs, (a-b))
    return all(diff .< threshold)
end    

function one_lm_normal(n=100)
    gen = normal_sampler(a=0, b=50, β_0=5, β=[1, 2.5], sd_e=0.1)
    sam = gen(n)
    return ols(sam, intercept=true)
end

@testset "sampler_normal: estimated coef are close to true values" begin
    lm = one_lm_normal()
    @test almost_equals(lm.beta, [5, 1, 2.5], 0.1)
end

@testset "methods yhat(), r2() and desc() are callable" begin
    lm = one_lm_normal()
    @test isa(yhat(lm), Vector)
    @test 0<r2(lm)<1
    @test occursin("Linear model", desc(lm))
end

@testset "equation formatter returns spaced string" begin
    text = equation(true, [-1/3, -2/7, 1/29]) 
    @test text == "Y = - 0.333 - 0.286*X1 + 0.034*X2"
end    

@testset "values of beta, ols without intercept " begin
    ns = normal_sampler(a=0, b=20, β_0=5, β=[1, 2.5], sd_e=0.5)
    sample1 = ns(100000)
    lm1 = ols(sample1, intercept=false)
    @test almost_equals(lm1.beta, [1.2143, 2.713], 0.01)
end
