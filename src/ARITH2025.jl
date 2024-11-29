module ARITH2025

export ratio_exactly_halfway, add, mul, fusedmuladd,
       SFiniteFloats, SExtendedFloats

using Combinatorics
using MiniFloatModels: SExtendedFloats, SFiniteFloats

include("combinatorics.jl")
include("halfway.jl")
include("arithmetic.jl")

include("calculate.jl")
include("plot.jl")

end # module
