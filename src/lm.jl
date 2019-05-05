using Statistics: mean

struct LinearModel
    X::Array 
    Y::Vector
    beta::Vector #FIMXE: of Real
end    

# OLS estimation using (\)
# https://github.com/giob1994/Alistair.jl/blob/3a11c19150169695581b46e4d1895f0641a4c29d/src/linregress.jl#L38-L41
function ols(X::Array, Y::Array)::Array
    return (X' * X) \ (X' * Y)
end 

"""Fit ordinary linear regression for observations."""
function ols(sample::Sample; intercept::Bool=false)::LinearModel
    X = (intercept ? add_intercept : identity)(sample.X)
    beta_hat = ols(X, sample.Y)
    return LinearModel(X, sample.Y, beta_hat)
end


"""Return fitted dependent variable Y."""
function yhat(lm::LinearModel)
    return lm.X * lm.beta 
end    

sum_of_squares(x::Vector)::Real = sum(x .^ 2) 

"""Residual sum of squares."""
rss(lm::LinearModel) = sum_of_squares(yhat(lm) - lm.observed.Y)

"""Total sum of squares for Y - mean.
   Also equals var(Y)*n.
"""
tss(lm::LinearModel) = sum_of_squares(lm.observed.Y .- mean(lm.observed.Y)) # 

"""R2 (unadjusted) = 1-(RSS/TSS)""" 
r2(lm::LinearModel) = 1 - rss(lm)/tss(lm)

betas(lm::LinearModel) = lm.beta

# display LinearModel
function has_intercept(lm::LinearModel)
    return all(lm.X[:,1] .== 1.0) 
end 

function equation(lm::LinearModel):: String
    equation(has_intercept(lm), lm.beta)
end     

function pretty_round(beta, precision::Int=3)
    map(x -> round(x, digits=precision), beta)
end

"""Make string like 3 + 0.5*X1 - 0.1*X2"""
function equation(has_intercept, betas)
    fmt = b -> (b >= 0) ? (" + $b") : (" - $(abs(b))") 
    vars = ["*X$i" for i in 1:length(betas)]
    if has_intercept
        vars = pushfirst!(vars[1:end-1], "")
    end
    gen = zip(map(fmt, pretty_round(betas)), vars)
    return "Y =" * join(["$k$x" for (k, x) in gen], "")    
end

function desc(lm::LinearModel)::String
    by_line(args...) = join(args, "\n")
    quack_ = has_intercept(lm) ? " " : " no "
    return by_line("Linear model with$(quack_)intercept: $(equation(lm))",                 
                   "Coefficients: $(lm.beta)",
                   "Sorry I do not know p-values yet.",
                   "R-squared: $(pretty_round(r2(lm)))")
end    

show(lm::LinearModel) = println(desc(lm))