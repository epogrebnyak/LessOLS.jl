struct LM
    X::Array
    Y::Vector
    beta::Vector #of Real
end    

function has_intercept(lm::LM)
  return all(lm.X[:,1] .== 1.0) 
end  

# OLS estimation 
function ols(X::Array, Y::Array)::Array
    return (X' * X) \ (X' * Y)
end 

"""Fit ordinary linear regression for observations."""
function ols(sample::Sample; intercept::Bool=false)::LM
    f = intercept ? add_intercept : identity
    X = f(sample.X)
    beta_hat = ols(X, sample.Y)
    return LM(X, sample.Y, beta_hat)
end

"""Return fitted dependent variable Y."""
yhat(lm::LM) = lm.X * lm.beta 

sum_of_squares(x::Vector)::Real = sum(x .^ 2) 

"""Residual sum of squares."""
rss(lm::LM) = sum_of_squares(yhat(lm) - lm.Y)

"""Total sum of squares for Y - mean.
   Also equals var(Y)*n.
"""
tss(lm::LM) = sum_of_squares(lm.Y .- mean(lm.Y))

"""R2 (unadjusted) = 1-(RSS/TSS)""" 
r2(lm::LM) = 1 - rss(lm)/tss(lm)

function equation(lm::LM, precision::Int=PRECISION)  
    beta = map(x -> round(x, digits=precision), beta)
    intercept = has_intercept(lm)
    return equation(beta, intercept)  
end    

function equation(beta::Vector, intercept::Bool)
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

PRECISION = 4

function desc(lm::LM)::String
    quack_ = lm.intercept ? " " : " no "
    r2_ = round(r2(lm), digits=PRECISION)
    eq_ = equation(lm, PRECISION)
    join_by_newline(args...) = join(args,"\n")
    return join_by_newline("Linear model with$(quack_)intercept: $eq_",                 
                 "Coefficients: $(lm.beta)",
                 "R-squared: $(r2_)")
end    

show(lm::LM) = println(desc(lm))