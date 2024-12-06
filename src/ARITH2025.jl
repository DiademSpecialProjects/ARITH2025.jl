module ARITH2025

export finite_values, SFiniteFloats, SExtendedFloats,
       add_ratios, mul_ratios, fma_ratios, bitprecisions

using Combinatorics, Plots
using MiniFloatModels: SExtendedFloats, SFiniteFloats

include("combinatorics.jl")
include("halfway.jl")

include("round.jl")
include("arithmetic.jl")

include("calculate.jl")
include("plot.jl")

end # module
