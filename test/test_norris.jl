# Observations from https://www.itl.nist.gov/div898/strd/lls/data/LINKS/DATA/Norris.dat
__precompile__(false)
using CSV

doc = """y,   x
0.1,        0.2
338.8,      337.4
118.1,      118.2
888.0,      884.6
  9.2,       10.1
228.1,      226.5
668.5,      666.3
998.5,      996.3
449.1,      448.6
778.9,      777.0
559.2,      558.2
  0.3,        0.4
  0.1,        0.6
778.1,      775.5
668.8,      666.9
339.3,      338.0
448.9,      447.5
 10.8,       11.6
557.7,      556.0
228.3,      228.1
998.0,      995.8
888.8,      887.6
119.6,      120.2
  0.3,        0.3
  0.6,        0.3
557.6,      556.8
339.3,      339.1
888.0,      887.2
998.5,      999.0
778.9,      779.0
 10.2,       11.1
117.6,      118.3
228.9,      229.2
668.4,      669.1
449.2,      448.9
  0.2,        0.5"""
doc = replace(doc," " => "")
df = CSV.read(IOBuffer(doc))
reference = (b0=-0.262323073774029, b1=1.00211681802045,r2=0.999993745883712)


@testset "Norris linear regression with intercept" begin
   norris = ols(Sample(df.x, df.y), intercept=true)
   approx(a, b, d)::Bool = (round(a, digits=d) == round(b, digits=d))
   @test approx(reference.b0, norris.beta[1], 12)
   @test approx(reference.b1, norris.beta[2], 12)
   @test approx(reference.r2, r2(norris), 15)
end