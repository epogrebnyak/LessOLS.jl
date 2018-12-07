using Test
import LessOLS: Sample, add_intercept, Process, make_sample

@testset "Sample constructor" begin
    x = [[1,2,3] [4,5,6]]
    y = [1,2,3]
    sam = Sample(x, y)
    @test sam.X == [[1,2,3] [4,5,6]]
    @test sam.Y == [1,2,3]
    @test_throws DimensionMismatch Sample([1,2], [1,2,3])
    @test_throws DimensionMismatch Sample(y, x)
end

@testset "add_intercept() works on array and Sample" begin
    @test add_intercept([1,2,3]) == [[1,1,1] [1,2,3]]
    sam = Sample([1,2], [3,4])
    @test add_intercept(sam).X == [[1,1] [1,2]]
    @test add_intercept(sam).Y == sam.Y
end

@testset "data generating process" begin
    p = Process(x = n->collect(1:n),
                y = x->2*x,
                e = x->[0.01 for _ in x])    
    @test_broken make_sample(p, 3) == Sample([1, 2, 3], [2.01, 4.01, 6.01]) # equality not defined
    @test make_sample(p, 3).X == [1, 2, 3]
    @test make_sample(p, 3).Y == [2.01, 4.01, 6.01]
end