abstract type Operation <: SpecialSet end


Base.intersect(x::SpecialSet, xs::SpecialSet...) = foldl(Base.intersect, xs; init=x)
function Base.intersect(a::SpecialSet, b::SpecialSet)
    res = intersect(a, b)
    res == nothing && return _intersect(a, b)
    res
end


"""
    intersect(::SpecialSet, t::SpecialSet) -> Union{SpecialSet, Nothing}

Overloadable method to determine the intersection of two `SpecialSet`s. If no special facts
about the given sets can be deduced, return `nothing`.

!!! note

    The `intersect` function within SpecialSets should never be called directly.
    Instead, call [`Base.intersect`](@ref).
"""
function intersect(::SpecialSet, ::SpecialSet) end


"""
    SetIntersection <: SpecialSet

Represents the intersection of its contained sets. Automatically flattens nested
instances of `SetIntersection`.

!!! warning

    Requires at least two unique `SpecialSet`s to construct. The intersection of one set is
    itself and should be represented as such; the meaning of the intersection of zero sets
    is unclear.
"""
struct SetIntersection <: Operation
    sets::Set{SpecialSet}

    function SetIntersection(sets::SpecialSet...)
        data = _flatten!(Set{SpecialSet}(), sets...)

        isempty(data) && throw(ArgumentError("Unable to construct intersection with no sets"))
        length(data) == 1 && throw(ArgumentError("Intersection with one set is invalid; use $(first(data))"))
        new(data)
    end
end
Base.get(s::SetIntersection) = s.sets
Base.eltype(s::SetIntersection) = mapfoldl(eltype, typeintersect, get(s))
Base.in(x, s::SetIntersection) = all(set -> x ∈ set, get(s))
function intersect(s::SetIntersection, t::SpecialSet)
    xs = collect(get(s))

    new = nothing
    for (i, q) ∈ enumerate(ss)
        new = intersect(q, t)
        new == nothing || (deleteat!(ss, i); break)
    end
    new == nothing && return SetIntersection(xs..., t)

    result = intersect(_intersect(xs...), new)
    result == nothing && return _intersect(xs..., new)
    result
end
intersect(t::SpecialSet, s::SetIntersection) = intersect(s, t)
intersect(a::SetIntersection, b::SetIntersection) = foldl(intersect, get(b); init=a)
condition(var, s::SetIntersection) = join([condition(var, set) for set ∈ s.sets], ", ")


function _intersect(xs...)
    uniques = _flatten!(Set(), xs...)
    length(uniques) == 1 && return first(uniques)
    SetIntersection(uniques...)
end
function _flatten!(data, s::SetIntersection)
    for el ∈ get(s)
        push!(data, el)
    end
    data
end
_flatten!(data, x) = push!(data, x)
_flatten!(data, xs...) = foldl(_flatten!, xs; init=data)
