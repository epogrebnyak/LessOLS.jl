using LessOLS: Process, make_sample, sampler_normal, equation
using LessOLS: uniform, linear, normal_noise

@testset "make_sample(p,n) and sampler_normal() return similar values" begin
    p=Process(x=uniform(0, 20, 2),
              y=linear(0, [1.25, 6.3]),
              e=normal_noise(0.2)) 
    sam1 = make_sample(p, 1000)
    gen = sampler_normal(a=0, b=20, β_0=5, β=[1.25, 6.3], sd_e=0.2)
    sam2 = gen(1000)
    @test_skip true # how to compare distributions of sam1 and sam2?    
end

@testset "sampler_normal: estimated coef are close to true values" begin
    gen = sampler_normal(a=0, b=50, β_0=5, β=[1, 2.5], sd_e=0.1)
    sam = gen(100)
    lm = ols(sam, intercept=true)
    cd = lm.beta - [5, 1, 2.5]
    @test all(map(abs, cd) .< 0.1)
end

@testset "methods yhat(), r2() and desc() are callable" begin
    gen = sampler_normal(a=0, b=50, β_0=5, β=[1, 2.5], sd_e=0.1)
    sam = gen(100)
    lm = ols(sam, intercept=true)
    @test isa(yhat(lm), Vector)
    @test 0<r2(lm)<1
    @test occursin("Linear model", desc(lm))
end

@testset "equation formatter returns spaced string" begin
    gen = sampler_normal(a=0, b=20, β_0=5, β=[1, 2.5], sd_e=0.5)
    sam = gen(100)
    lm = ols(sam, intercept=true)
    @test equation([-1/3, -2/7, 1/29],true,4) == "Y = -0.3333 - 0.2857*X1 + 0.0345*X2"
end    