module ARITH2025

export finite_values, SFiniteFloats, SExtendedFloats,
       add_ratios, mul_ratios, fma_ratios, 
       finite_add_ratios, finite_mul_ratios, finite_fma_ratios, 
       bitprecisions

using Combinatorics, JLD2, Plots, LaTeXStrings

using MiniFloatModels: SExtendedFloats, SFiniteFloats

SaveData = false

include("combinatorics.jl")
include("halfway.jl")

include("round.jl")
include("arithmetic.jl")

include("ratiocalcs.jl")
include("calculate.jl")

if SaveData
    include("plot.jl")
else
    include("simpleplot.jl")
end

# reload data
end # module
