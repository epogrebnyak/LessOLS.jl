__precompile__(false)
module LessOLS
using Distributions: Normal, Uniform
using Statistics: mean

"""
Sample(X,Y)

Sample holds X array of size n*k (known as explanatory variables, 
independent variables, or features) and Y n*1 sized vector 
(response, dependent variable or regressor) for observed data.    
"""
struct Sample
    X::Array 
    Y::Vector
    function Sample(X, Y)
        td(message:: String) = throw(DimensionMismatch(message)) 
        size(X,1) == size(Y,1) || td("X and Y must have same number of rows")
        size(Y,2) == 1 || td("Y must be a vector: $Y")   
        new(X, Y)
    end    
end

function add_intercept(X::Array)::Array
    nrows = size(X, 1)
    X0 = ones(nrows, 1)
    return [X0 X]
end    

function add_intercept(sample::Sample)
    return Sample(add_intercept(sample.X), sample.Y)
end  

struct Process
    x # function of sample size n 
    y # function of regressors X
    e # function of regressors X
    Process(;x,y,e) = new(x, y, e)
end

function make_sample(p::Process, n::Int)::Sample
        X = p.x(n)
        Y = vec(p.y(X) + p.e(X))
        return Sample(X, Y)
end  

# Normal assumptions case
uniform(a, b, k) = n -> rand(Uniform(a, b), n, k)
linear(β_0, β) = X -> β_0 .+ X * β
normal_noise(sd_e) = X -> rand(Normal(0, sd_e), size(X, 1), 1)

function sampler_normal(;a, b, β_0, β, sd_e)
    k = length(β)
    p = Process(x = uniform(a, b, k),
                y = linear(β_0, β),
                e = normal_noise(sd_e)) 
    return n -> make_sample(p, n)            
end    


include("lm.jl")


end # module