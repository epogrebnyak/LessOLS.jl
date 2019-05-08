using Test
import LessOLS: Sample, add_intercept, sample_factory#, Process, make_sample

@testset "Sample struct - constructor" begin
    x = [[1,2,3] [4,5,6]]
    y = [1,2,3]
    sam = Sample(x, y)
    @test sam.X == x
    @test sam.Y == y
    @test_throws DimensionMismatch Sample([1,2], [1,2,3])
    @test_throws DimensionMismatch Sample(y, x)
end

@testset "add_intercept() works on array and Sample" begin
    @test add_intercept([1,2,3]) == [[1,1,1] [1,2,3]]
    sam = Sample([1,2], [3,4])
    @test add_intercept(sam).X == [[1,1] [1,2]]
    @test add_intercept(sam).Y == sam.Y
end

@testset "data generating process make_sample()" begin
    fct = sample_factory(x_process = n->collect(1:n),
                         y_process = x->2*x,
                         error_process = x->[0.1 for _ in x]
                         )    
    sam = fct(3)
    @test sam.X == [1, 2, 3]
    @test sam.Y == [2.1, 4.1, 6.1]
end