using Test
using LessOLS: Process, make_sample


p = Process(x = n -> collect(1:n),
            y = x -> 2*x,
            e = x -> [0.01 for _ in x]
    )

make_sample(p, 10)            

