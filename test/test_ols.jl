using LessOLS: make_sample, sampler_normal
using LessOLS: uniform, linear, normal_noise

@testset "make_sample and ols by approx coefficients" begin
    p=Process(x=uniform(0, 20, 2),
            y=linear(0, [1.25, 6.3]),
            e=normal_noise(0.2)) 
    sam = make_sample(p, 100)
    lm = ols(sam)
    @test all(lm.beta - [1.25, 6.3] .< 0.1)
    @test isa(yhat(lm), Vector)
    @test r2(lm)>0
end

@testset "sampler_normal and ols by approx coefficients" begin
    gen = sampler_normal(a=0, b=50, β_0=5, β=[1, 2.5], sd_e=0.1)
    sam = gen(100)
    lm = ols(sam, intercept=true)
    cd = lm.beta - [5, 1, 2.5]
    @test all(map(abs, cd) .< 0.1)
    @test isa(yhat(lm), Vector)
    @test r2(lm)>0
end