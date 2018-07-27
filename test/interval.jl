using SpecialSets: SetIntersection


standard(a, b) = a ∩ b == SetIntersection(a, b)

@testset "Interval" begin
    @testset "TypeSet" begin
        @test TypeSet(Int) == TypeSet{Int}()
        @test eltype(TypeSet(Int)) == Int
        @test 3 ∈ TypeSet(Int)
        @test 3.0 ∉ TypeSet(Int)

        @test TypeSet(Int) ∩ TypeSet(Float64) == ∅
        @test TypeSet(Int) ∩ TypeSet(Int) == TypeSet(Int)
        @test TypeSet(Integer) ∩ TypeSet(Number) == TypeSet(Integer)
        @test standard(TypeSet(Int), NotEqual(0))
    end

    @testset "LessThan" begin
        @test LessThan(3) == LessThan(3, false)
        @test LessThan(3, true) == LessThan(3, true)
        @test LessThan(3, true) ≠ LessThan{Float64}(3, true)
        @test eltype(LessThan(3)) == Int
        @test eltype(LessThan{Number}(3)) == Number
        @test 2 ∈ LessThan(3)
        @test 3 ∉ LessThan(3)
        @test 3 ∈ LessThan(3, true)
        @test 2.0 ∉ LessThan(3)
        @test 2.0 ∈ LessThan{Number}(3)

        @test LessThan(3) ∩ LessThan(5) == LessThan(3)
        @test LessThan(3) ∩ LessThan(3) == LessThan(3)
        @test LessThan(3) ∩ LessThan(3, true) == LessThan(3)
        @test LessThan(3, true) ∩ LessThan(3, true) == LessThan(3, true)
        @test LessThan(3) ∩ LessThan(3.5, true) == ∅
        @test LessThan{Number}(3) ∩ LessThan(3.5, true) == LessThan(3.0)
    end

    @testset "GreaterThan" begin
        @test GreaterThan(-1) == GreaterThan(-1, false)
        @test GreaterThan(-1, true) == GreaterThan(-1, true)
        @test GreaterThan(-1, true) == GreaterThan(-1, true)
        @test eltype(GreaterThan(-1)) == Int
        @test eltype(GreaterThan{Any}(-1)) == Any
        @test 1 ∈ GreaterThan(0)
        @test 0 ∉ GreaterThan(0)
        @test 0 ∈ GreaterThan(0, true)
        @test 0.0 ∉ GreaterThan(0, true)
        @test 0.0 ∈ GreaterThan{Real}(0, true)

        @test GreaterThan(0) ∩ GreaterThan(12) == GreaterThan(12)
        @test GreaterThan(1) ∩ GreaterThan(1) == GreaterThan(1)
        @test GreaterThan(1, true) ∩ GreaterThan(1) == GreaterThan(1)
        @test GreaterThan(1, true) ∩ GreaterThan(1, true) == GreaterThan(1, true)
        @test GreaterThan(3) ∩ GreaterThan(3.5, true) == ∅
        @test GreaterThan{Number}(3) ∩ GreaterThan(3.5, true) == GreaterThan(3.5, true)
    end

    @testset "LessThan ∩ GreaterThan" begin
        @test standard(LessThan(1), GreaterThan(0))
        @test LessThan(1) ∩ GreaterThan(1) == ∅
        @test LessThan(1, true) ∩ GreaterThan(1) == ∅
        @test LessThan(1) ∩ GreaterThan(1, true) == ∅
        @test LessThan(1, true) ∩ GreaterThan(1, true) == Set([1])

        @test GreaterThan(3) ∩ LessThan(4.0) == ∅
        @test standard(GreaterThan(3.0), LessThan(4.0))
        @test GreaterThan{Number}(3) ∩ LessThan(4.0) ==
            SetIntersection(GreaterThan(3.0), LessThan(4.0))
    end

    @testset "NotEqual" begin
        @test NotEqual(3) ∩ NotEqual(5) == NotEqual(3, 5)
        @test standard(GreaterThan(3), NotEqual(4))
        @test_skip LessThan(5, true) ∩ NotEqual(5) == LessThan(5)
        @test_skip GreaterThan(3, true) ∩ NotEqual(3) == GreaterThan(3)
    end
end
