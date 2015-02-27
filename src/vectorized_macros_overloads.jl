# addToExpression(x, y::Vector{Variable}, z) = addToExpression(x, z, y)
# addToExpression(x, y, z::Vector{Variable}) = addToExpression(x, y, convert(AffExpr,z))

addToExpression{T}(x, y::Real, z::JuMPArray{T,1,true}) = addToExpression(x, y, z.innerArray)

addToExpression{T}(x, y::JuMPArray{T,1,true}, z::Real) = addToExpression(x, y.innerArray, z)

typealias VectTypes Union(JuMPTypes,Real)

addToExpression(x, y, z::SparseMatrixCSC) = addToExpression(x, y, full(z)) # lol
addToExpression(x, y::SparseMatrixCSC, z) = addToExpression(x, full(y), z)

addToExpression{T<:JuMPTypes}(x::Vector{T}, y::Real, z::Real) = (x + y*z)

function addToExpression{T<:JuMPTypes,N}(x::Number, y::Real, z::Array{T,N})
    v = convert(Array{promote_type(T,AffExpr),N}, copy(z)) # lift T=Variable to AffExpr
    return x + y.*v
end

addToExpression{R<:Number}(x::Number, y::Real, z::Array{R}) = x + y.*z

addToExpression{T<:VectTypes}(x::Array{T}, y::Real, z::Real) = x + (y*z)

# function addToExpression{T<:VectTypes}(x, y::Real, z::Array{T})
    # sz = size(z)
    # all(x->(x==1), sz[2:end]) || error("Cannot handle matrix constraints") # trim trailing singleton dimensions
    # addToExpression(x, y, reshape(copy(z), sz[1]))
# end

function addToExpression{T<:VectTypes,S<:VectTypes}(x::Array{T}, y::Real, z::Array{S})
    length(x) == length(z) || throw(DimensionMismatch("+"))
    return x + y.*z
end

function addToExpression{T<:VectTypes}(x::AffExpr, y::Real, z::Array{T})
    (isempty(x.vars) && isempty(x.coeffs)) || error("Cannot add an affine expression to Array{$T}")
    return x.constant + y.*z
end
