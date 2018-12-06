using Test
import LessOLS: Sample

x = [[1,2,3] [4,5,6]]
y = [1,2,3]
sam = Sample(x, y)
@test sam.X == [[1,2,3] [4,5,6]]
@test sam.Y == [1,2,3]
@test_throws DimensionMismatch Sample([1,2], [1,2,3])
@test_throws DimensionMismatch Sample(y, x)
