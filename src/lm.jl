struct LinearModel
    observed::Sample
    has_intercept::Bool
    beta::Vector #of Real
end    

# OLS estimation using (\)
# https://github.com/giob1994/Alistair.jl/blob/3a11c19150169695581b46e4d1895f0641a4c29d/src/linregress.jl#L38-L41
function ols(X::Array, Y::Array)::Array
    return (X' * X) \ (X' * Y)
end 

"""Fit simple linear regression for observations."""
function ols(sample::Sample; intercept::Bool=false)::LinearModel
    f = intercept ? add_intercept : identity
    sample_ = f(sample)
    beta_hat = ols(sample_.X, sample_.Y)
    return LinearModel(sample, intercept, beta_hat)
end

"""Return fitted dependent variable Y."""
function yhat(lm::LinearModel)
    f = lm.has_intercept ? add_intercept : identity
    return f(lm.observed.X) * lm.beta 
end    

function repr(lm::LinearModel)::String
    quack = lm.has_intercept ? "" : "no"
    return ("Linear model with $quack intercept and coefficients $(lm.beta)\n" *
            "R-squared $(r2(lm))")
end    

show(lm::LinearModel) = println(repr(lm))

sum_of_squares(x::Vector)::Real = sum(x .^ 2) 

"""Residual sum of squares."""
rss(lm::LinearModel) = sum_of_squares(yhat(lm) - lm.observed.Y)

"""Total sum of squares for Y - mean.
   Also equals var(Y)*n.
"""
tss(lm::LinearModel) = sum_of_squares(lm.observed.Y .- mean(lm.observed.Y)) # 

"""R2 (unadjusted) = 1-(RSS/TSS)""" 
r2(lm::LinearModel) = 1 - rss(lm)/tss(lm)