struct LinearModel
    observed::Sample
    intercept::Bool
    beta::Vector #of Real
end    

# OLS estimation using (\)
# https://github.com/giob1994/Alistair.jl/blob/3a11c19150169695581b46e4d1895f0641a4c29d/src/linregress.jl#L38-L41
function ols(X::Array, Y::Array)::Array
    return (X' * X) \ (X' * Y)
end 

"""Fit ordinary linear regression for observations."""
function ols(sample::Sample; intercept::Bool=false)::LinearModel
    f = intercept ? add_intercept : identity
    beta_hat = ols(f(sample.X), sample.Y)
    return LinearModel(sample, intercept, beta_hat)
end

"""Return fitted dependent variable Y."""
function yhat(lm::LinearModel)
    f = lm.intercept ? add_intercept : identity
    return f(lm.observed.X) * lm.beta 
end    

function equation(lm::LinearModel, precision::Int)  
    return equation(lm.beta, lm.intercept, precision)  
end    

function equation(beta::Vector, intercept::Bool, precision::Int)
    beta = map(x -> round(x, digits=precision), beta)
    result = "Y = "
    if intercept
        result *= "$(beta[1])"
        beta = beta[2:end]
    end
    for (i,b) in enumerate(beta)
        result *= (b >= 0 ? " + $b" : " - $(abs(b))") * "*X$i"
    end    
    return result
end    

function desc(lm::LinearModel)::String
    quack_ = lm.intercept ? " " : " no "
    r2_ = round(r2(lm), digits=4)
    eq_ = equation(lm, 4)
    join_(args...) = join(args,"\n")
    return join_("Linear model with$(quack_)intercept: $eq_",                 
                 "Coefficients: $(lm.beta)",
                 "R-squared: $(r2_)")
end    

show(lm::LinearModel) = println(desc(lm))

sum_of_squares(x::Vector)::Real = sum(x .^ 2) 

"""Residual sum of squares."""
rss(lm::LinearModel) = sum_of_squares(yhat(lm) - lm.observed.Y)

"""Total sum of squares for Y - mean.
   Also equals var(Y)*n.
"""
tss(lm::LinearModel) = sum_of_squares(lm.observed.Y .- mean(lm.observed.Y)) # 

"""R2 (unadjusted) = 1-(RSS/TSS)""" 
r2(lm::LinearModel) = 1 - rss(lm)/tss(lm)