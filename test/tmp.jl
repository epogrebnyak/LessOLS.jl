using Test
using LessOLS: Process, make_sample


p = Process(x = n->collect(1:n),
            y = x->2*x,
            e = x->[0.01 for _ in x]
    )
@test make_sample(p, 3) = Sample([1, 2, 3], [2.01, 4.01, 6.01])           

