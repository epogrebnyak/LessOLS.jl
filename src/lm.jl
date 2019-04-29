struct LinearModel
    observed::Sample
    modify_x # must change observed.X
    beta::Vector #FIMXE: of Real
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
    return LinearModel(sample, f, beta_hat)
end

"""Return fitted dependent variable Y."""
function yhat(lm::LinearModel)
    X_ = lm.modify_x(lm.observed.X)
    return X_ * lm.beta 
end    

function pretty_round(beta, precision::Int=3)
    map(x -> round(x, digits=precision), beta)
end

function has_intercept(lm::LinearModel)
    false # FIXME: lm.x_modifier != identity
end

function equation(lm::LinearModel):: String
    beta = pretty_round(lm.beta)
    result = "Y = "
    if has_intercept(lm)
        result *= "$(beta[1])"
        beta = beta[2:end]
    end
    for (i,b) in enumerate(beta)
        result *= (b >= 0 ? " + $b" : " - $(abs(b))") * "*X$i"
    end    
    return result
end    

by_line(args...) = join(args,"\n")

function desc(lm::LinearModel)::String
    quack_ = has_intercept(lm) ? " " : " no "
    r2_ = pretty_round(r2(lm))
    eq_ = equation(lm)
    return by_line("Linear model with$(quack_)intercept: $eq_",                 
                   "Coefficients: $(lm.beta)",
                   "Sorry I do not know p-values yet.",
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