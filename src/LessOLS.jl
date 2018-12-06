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

function add_intercept(X::Array)
    nrows = size(X, 1)
    X0 = ones(nrows, 1)
    return [X0 X]
end    

function add_intercept(sample::Sample)
    return Sample(add_intercept(sample.X), sample.Y)
end  

# Create a function that will return a sample of normal observations
# function dgp_normal(;β_0, β, sd_e)
#     y_process(X) = β_0 .+ X * β
#     dist_e = Normal(0, sd_e)
#     k = size(β, 1)
#     noise_process(X) = rand(dist_e, size(X, 1), 1)
#     # vec reshapes Array{T, 2} to Vector
#     return X -> vec(y_process(X) + noise_process(X))
# end

struct Process
    x # of n, k 
    y # of x
    e # of x
    Process(;x,y,e) = new(x, y, e)
end

function make_sample(p::Process, n::Int)
        X = p.x(n)
        Y = vec(p.y(X) + p.e(X))
        return Sample(X, Y)
end  

include("lm.jl")


end # module
