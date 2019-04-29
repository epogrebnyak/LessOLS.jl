is_vector(x) = size(x,2) == 1
nrows(x) = size(x,1)
dim_error(message:: String) = throw(DimensionMismatch(message)) 

"""Sample(X,Y)

Sample holds X array of size n*k (explanatory variables, 
independent variables, features or regressor) and Y, a n*1 sized 
vector, for observed data (response, dependent variable or regressand).    
"""
struct Sample
    X::Array 
    Y::Vector
    function Sample(X, Y)        
        nrows(X) == nrows(Y) || dim_error("X and Y must have same number of rows")
        is_vector(Y) || dim_error("Y must be a vector: $Y")   
        new(X, Y)
    end    
end

function add_intercept(X::Array)::Array
    X0 = ones(nrows(X), 1)
    return [X0 X]
end    

# FIXME: do not add intercept if it is already there.
function add_intercept(sample::Sample)
    return Sample(add_intercept(sample.X), sample.Y)
end

function sample_factory(;x_process, y_process, error_process)
    function sampler(n: Int):
        X = x_process(n)
        Y = vec(y_process(X) + error_process(X))
        return Sample(X, Y)
end

function normal_sampler(;a, b, β_0, β, sd_e)
    k = length(β)
    du = Uniform(a, b) # this is squares only
    dn = Normal(0, sd_e)
    sample_factory(x_process = n -> rand(du, n, k),
                   y_process = X -> β_0 .+ X * β, 
                   error_process = X -> rand(dn, nrows(X), 1)
                   )