function finite_values(representation, bits, precision)
    sort!(filter!(isfinite, [representation(bits, precision).floats...]))
end

BitsMin = 2 
BitsMax = 5

bitprecisions =[(bits, precision) for bits in BitsMin:BitsMax for precision in 1:bits-1]
finitevals = map(x->finite_values(SFiniteFloats,x...), bitprecisions)
extendedvals = map(x->finite_values(SExtendedFloats,x...), bitprecisions)
finites = Dict(bitprecisions .=> finitevals)
extendeds = Dict(bitprecisions .=> extendedvals)

add_ratios = Dict(bitprecisions .=> [add_exactly_halfway(extendeds[bp]) for bp in bitprecisions])
mul_ratios = Dict(bitprecisions .=> [mul_exactly_halfway(extendeds[bp]) for bp in bitprecisions])
fma_ratios = Dict(bitprecisions .=> [fma_exactly_halfway(extendeds[bp]) for bp in bitprecisions])


