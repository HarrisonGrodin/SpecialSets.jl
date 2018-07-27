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

        @test TypeSet(Int) ⊆ TypeSet(Int)
        @test TypeSet(Int) ⊆ TypeSet(Number)
        @test TypeSet(Number) ⊈ TypeSet(Int)
        @test TypeSet(Float64) ⊈ TypeSet(Int)
        @test LessThan(3) ⊆ TypeSet(Int)
        @test (GreaterThan(3) ∩ LessThan(12, true)) ⊆ TypeSet(Int)
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

        @test LessThan(0) ⊆ LessThan(0)
        @test LessThan(0) ⊆ LessThan(0, true)
        @test LessThan(0, true) ⊈ LessThan(0)
        @test LessThan(0, true) ⊆ LessThan(0, true)
        @test LessThan(0) ⊆ LessThan(9)
        @test LessThan(0) ⊈ LessThan(8.7)
        @test LessThan{Number}(0) ⊈ LessThan(8.7)
        @test LessThan{Float64}(0) ⊆ LessThan(8.7)
        @test LessThan{Number}(0) ⊆ LessThan{Number}(8.7)
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

        @test GreaterThan(-5) ⊆ GreaterThan(-5)
        @test GreaterThan(-5) ⊆ GreaterThan(-5, true)
        @test GreaterThan(-5, true) ⊈ GreaterThan(-5)
        @test GreaterThan(-5, true) ⊆ GreaterThan(-5, true)
        @test GreaterThan(-5) ⊆ GreaterThan(-7)
        @test GreaterThan(-5) ⊈ GreaterThan(3)
        @test GreaterThan(4) ⊈ GreaterThan(4.0)
        @test GreaterThan{Float64}(4) ⊆ GreaterThan(4.0)
        @test GreaterThan{Real}(4) ⊈ GreaterThan(4.0)
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

        @test (GreaterThan(3) ∩ LessThan(5)) ⊆ (GreaterThan(3) ∩ LessThan(5))
        @test (GreaterThan(3) ∩ LessThan(5, true)) ⊆ (GreaterThan(0, true) ∩ LessThan(6, true))
        @test (GreaterThan(0) ∩ LessThan(2)) ⊆ (GreaterThan(0) ∩ LessThan(3))
        @test (GreaterThan(0) ∩ LessThan(2)) ⊈ (GreaterThan(1) ∩ LessThan(3))
        @test (GreaterThan(0) ∩ LessThan(2)) ⊈ (GreaterThan(3) ∩ LessThan(10))
    end

    @testset "NotEqual" begin
        @test NotEqual(0) ∩ NotEqual(0) == NotEqual(0)
        @test NotEqual(3) ∩ NotEqual(5) == NotEqual(3, 5)

        @test standard(GreaterThan(3), NotEqual(4))
        @test LessThan(3) ∩ NotEqual(5) == LessThan(3)
        @test GreaterThan(0, true) ∩ NotEqual(-1) == GreaterThan(0, true)
        @test standard(LessThan(3), NotEqual(0))
        @test standard(NotEqual(7.2), GreaterThan(5.5))
        @test_skip LessThan(5, true) ∩ NotEqual(5) == LessThan(5)
        @test_skip GreaterThan(3, true) ∩ NotEqual(3) == GreaterThan(3)

        @test standard(Even, NotEqual(2))
        @test Even ∩ NotEqual(5) == Even
        @test standard(Step(5, 2), NotEqual(7))
        @test Step(5, 2) ∩ NotEqual(1) == Step(5, 2)
    end
end
