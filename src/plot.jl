using LaTeXStrings, Plots, Makie

series_attribute(attribute) =
    reshape(attribute, 1, length(attribute))    

function series_attributes(; attributes...)
    nt = (; attributes...)
    names = keys(nt)
    vals = map(x->series_attribute(x), nt |> collect)
    NamedTuple(names .=> vals)
end

label = ["add", "mul", "fma", "add", "mul", "fma", "add"]
labels = series_attributes(; label)


legends = (legend = :topleft, foreground_color_legend = :grey98, background_color_legend = :grey96, legend_font_pointsize = 9)

marker=[:cross, :star, :rtriangle] # , :circle, :utriangle, :vline, :diamond]  #:dtriangle]
markersize = [7, 8, 8] # 6, 5, 5, 5]
markercolor = [:DarkOrange3, :indigo, :mediumseagreen] # , :deepskyblue, :black, :black, :black, :black]
markercolor = [:VioletRed4, :indigo, :mediumseagreen] #, :deepskyblue, :black, :black, :black, :black]
markers = series_attributes(; marker, markersize, markercolor)

linestyle = [:dot, :dot, :dot] # , :dot, :dot, :dot, :dot]
linewidth = [3, 3, 3] # , 2, 2, 2, 2]
linecolor = [:skyblue, :Palevioletred, :cadetblue] #, :lightskyblue, :black, :black, :black, :black]
linecolor = [:Pink4,:RoyalBlue2, :DarkSeaGreen] #, :cadetblue, :lightskyblue, :black, :black, :black, :black]
linealpha = [0.75, 0.75, 0.75] # , 0.5, 0.5, 0.5, 0.5]
lines = series_attributes(; linestyle, linewidth, linecolor, linealpha)

maxproportion = round.(maximum.(amfmatrix(i) for i=3:8), base=10, digits=3)
ymax = [0.25, 0.25, 0.2125, 0.2125, 0.2125, 0.2125]

amfplot(bits) = Plots.plot(amfmatrix(bits); markers..., lines..., labels..., legends...,
                xaxis=("precision (bits)", (1-1//4,bits-3//4), 1:bits-1), 
                yaxis=("proportion exactly halfway", (0, ymax[bits-2]), 0:0.05:ymax[bits-2]),
                title="$bits-bit finite floats")


# test
# ys = cumsum(randn(8, 3), dims=1)
# zs = cumsum(randn(8, 7), dims=1)
# Plots.plot(ys; markers..., lines..., labels..., legends...)


BitsMin = 2
BitsMax = 8

bitprecisions =[(bits, precision) for bits in BitsMin:BitsMax for precision in 1:bits-1]
finites = map(x->finite_values(SFiniteFloats,x...), bitprecisions)
dict = Dict(bitprecisions .=> finites)

# import ARITH2025: add_exactly_halfway, mul_exactly_halfway, fma_exactly_halfway

add_ratios = Dict(bitprecisions .=> [add_exactly_halfway(dict[bp]) for bp in bitprecisions])
mul_ratios = Dict(bitprecisions .=> [mul_exactly_halfway(dict[bp]) for bp in bitprecisions])
fma_ratios = Dict(bitprecisions .=> [fma_exactly_halfway(dict[bp]) for bp in bitprecisions])
fma_ratios1 = [fma_exactly_halfway(dict[bp]) for bp in bitprecisions];
fma_ratios = Dict(bitprecisions .=> fma_ratios1)

bits_adds_halfway(bits) = map(key->add_ratios[key],bits_precisions(bits))
bits_muls_halfway(bits) = map(key->mul_ratios[key],bits_precisions(bits))
bits_fmas_halfway(bits) = map(key->fma_ratios[key],bits_precisions(bits))

adds(bits) = [add_ratios[(bits, i)] for i=1:bits-1]
muls(bits) = [mul_ratios[(bits, i)] for i=1:bits-1]
fmas(bits) = [fma_ratios[(bits, i)] for i=1:bits-1]

amf(bits) = (add=adds(bits), mul=muls(bits), fma=fmas(bits))
amff(bits) = map(x->Float16.(x), amf(bits))

# columns = "add", "mul", "fma" rows = precisions
function amfmatrix(bits)
    vec = collect(Iterators.flatten([Tuple(amff(bits))...]))
    n = length(vec)
    rows = 3
    cols = fld(n, rows)
    reshape(vec, cols, rows)
end


tramfmatrix(bits) = collect(transpose(amfmatrix(bits)))


#=
Plots.plot(amfmatrix(5); markers..., lines..., labels..., legends...,xaxis="precision", yaxis="proportion halfway",title="5 bit floats")

series_attribute(attribute) =
    reshape(attribute, 1, length(attribute))    

function series_attributes(; attributes...)
    nt = (; attributes...)
    names = keys(nt)
    vals = map(x->series_attribute(x), nt |> collect)
    NamedTuple(names .=> vals)
end


y = cumsum(randn(8, 3), dims=1)

marker=[:cross, :star, :rtriangle, :hexagon, :vline, :octagon, :rtriangle]
markersize = [6, 6, 6, 6, 6, 6, 6]
markercolor = [:black, :black, :black, :black, :black, :black, :black]
markers = series_attributes(marker, markersize, markercolor)

linestyle = [:dot, :dot, :dot, :dot, :dot, :dot, :dot][1:3]
linewidth = [2, 2, 2, 2, 2, 2, 2][1:3]
linecolor = [:black, :black, :black, :black, :black, :black, :black]
linealpha = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
lines = series_attributes(; linestyle, linewidth, linecolor, linealpha)


styles = reshape(styles, 1, length(styles))
markers = reshape(markers, 1, length(markers))
linealphas = reshape(linealphas, 1, length(linealphas))
Plots.plot(y, line=(2, styles, linealphas),markers=(6,markers), label=map(string, styles), legendtitle="linestyle")
=#