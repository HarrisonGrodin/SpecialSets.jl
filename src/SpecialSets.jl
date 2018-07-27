module SpecialSets

export SpecialSet, InfiniteSet
export ∅


abstract type SpecialSet end
Base.in(x, ::SpecialSet) = false
Base.issubset(::SpecialSet, ::SpecialSet) = false
Base.issubset(s, t::SpecialSet) = all(in(t), s)


const ∅ = Set()
Base.intersect(a::AbstractSet, b::SpecialSet) = Set([x for x ∈ a if x ∈ b])
Base.intersect(b::SpecialSet, a::AbstractSet) = Base.intersect(a, b)

"""
    InfiniteSet <: SpecialSet

Set of infinite size.
"""
abstract type InfiniteSet <: SpecialSet end
Base.eltype(::InfiniteSet) = Any


include("operations.jl")

include("interval.jl")
include("step.jl")

include("show.jl")

end # module
