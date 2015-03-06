import Base: promote_rule, promote_type, cat_t, hcat, vcat, hvcat

type DummyJuMPArray end
typealias JuMPOneArray{T,N} JuMPArray{T,N,true}

Base.promote_rule{T<:JuMPOneArray}(::Type{T},::Type{Union()}) = DummyJuMPArray
Base.promote_rule{T<:JuMPOneArray,S<:JuMPOneArray}(::Type{T},::Type{S}) = DummyJuMPArray
Base.promote_rule{T<:JuMPOneArray,S}(::Type{T},::Type{S}) = DummyJuMPArray

Base.promote_type{T<:JuMPOneArray}(::Type{T},::Type{Union()}) = DummyJuMPArray
Base.promote_type{T<:JuMPOneArray}(::Type{Union()},::Type{T}) = DummyJuMPArray
Base.promote_type{T<:JuMPOneArray}(::Type{T},::Type{T}) = DummyJuMPArray
Base.promote_type{T<:JuMPOneArray,S<:JuMPOneArray}(::Type{T},::Type{S}) = DummyJuMPArray
Base.promote_type{T<:JuMPOneArray,S}(::Type{T},::Type{S}) = DummyJuMPArray

_tofull(x) = x
_tofull{T,N}(x::JuMPArray{T,N,true}) = x.innerArray

function Base.cat_t(catdims, ::Type{DummyJuMPArray}, X...)
    Y = map(_tofull, X)
    T = promote_type(map(x->isa(x,AbstractArray) ? eltype(x) : typeof(x), X)...)
    cat_t(catdims, T, Y...)
end

Base.hcat(X::JuMPOneArray...) = hcat([_tofull(x) for x in X]...)
Base.vcat(X::JuMPOneArray...) = vcat([_tofull(x) for x in X]...)
Base.hvcat(rows::(Int...), X::JuMPOneArray...) = hvcat(rows, [_tofull(x) for x in X]...)
