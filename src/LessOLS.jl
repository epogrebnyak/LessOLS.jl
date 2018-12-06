module LessOLS
export Sample

"""
Sample(X,Y)

Sample holds X array of size n*k (known as explanatory variables, 
independent variables, or features) and Y n*1 sized vector (response or 
dependent variable) for observed data.    
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

end # module
