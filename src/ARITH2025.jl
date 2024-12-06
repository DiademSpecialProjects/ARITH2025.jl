module ARITH2025

export finite_values, SFiniteFloats, SExtendedFloats,
       add_ratios, mul_ratios, fma_ratios, bitprecisions

using Combinatorics, JLD2, Plots, LaTeXStrings

using MiniFloatModels: SExtendedFloats, SFiniteFloats

include("combinatorics.jl")
include("halfway.jl")

include("round.jl")
include("arithmetic.jl")

include("ratiocalcs.jl")
include("calculate.jl")
include("plot.jl")

end # module
