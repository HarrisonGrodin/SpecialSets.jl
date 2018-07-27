using SpecialSets
using Test

_std_intersect(xs...) = intersect(xs...) == SetIntersection(xs...)


include("interval.jl")
include("step.jl")

@testset "intersect" begin
    @test _std_intersect(GreaterThan(0), LessThan(3), NotEqual(1))
    @test _std_intersect(GreaterThan(-4), LessThan(10), Even)

    @test (GreaterThan(0) ∩ LessThan(10) ∩ Even) ⊆ LessThan(12)
    @test (GreaterThan(0) ∩ LessThan(10) ∩ Even) ⊆ (LessThan(12) ∩ GreaterThan(0))
    @test (GreaterThan(0) ∩ LessThan(10) ∩ NotEqual(3)) ⊆ GreaterThan(-5)
    @test (GreaterThan(0) ∩ NotEqual(3, 4) ∩ LessThan(10)) ⊆ (NotEqual(3) ∩ GreaterThan(-5))

    xs = [GreaterThan(0), LessThan(8), Even, NotEqual(4)]
    for perm ∈ permutations(xs)
        @test intersect(xs...) ⊆ intersect(perm...)
    end
end
