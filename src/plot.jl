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

marker=[:cross, :star, :rtriangle, :circle, :utriangle, :vline, :diamond]  #:dtriangle]
markersize = [7, 8, 8, 6, 5, 5, 5]
markercolor = [:mediumblue, :indigo, :mediumseagreen, :deepskyblue, :black, :black, :black, :black]
markercolor = [:brown, :indigo, :mediumseagreen, :deepskyblue, :black, :black, :black, :black]
markers = series_attributes(; marker, markersize, markercolor)

linestyle = [:dot, :dot, :dot, :dot, :dot, :dot, :dot]
linewidth = [3, 3, 3, 2, 2, 2, 2]
linecolor = [:skyblue, :Palevioletred, :cadetblue, :lightskyblue, :black, :black, :black, :black]
linecolor = [:Coral2, :RoyalBlue2, :DarkSeaGreen, :cadetblue, :lightskyblue, :black, :black, :black, :black]
linealpha = [0.75, 0.75, 0.75, 0.5, 0.5, 0.5, 0.5]
lines = series_attributes(; linestyle, linewidth, linecolor, linealpha)

# test
ys = cumsum(randn(8, 3), dims=1)
zs = cumsum(randn(8, 7), dims=1)
Plots.plot(ys; markers..., lines..., labels..., legends...)


bits_precisions(bits) = [(bits, precision) for precision in 1:bits-1]

bits_adds_halfway(bits) = map(key->add_ratios[key],bits_precisions(bits))
bits_muls_halfway(bits) = map(key->mul_ratios[key],bits_precisions(bits))
bits_fmas_halfway(bits) = map(key->fma_ratios[key],bits_precisions(bits))

bits_ratios(bits) = [add = bits_p]

#=

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

linestyle = [:dot, :dot, :dot, :dot, :dot, :dot, :dot]
linewidth = [2, 2, 2, 2, 2, 2, 2]
linecolor = [:black, :black, :black, :black, :black, :black, :black]
linealpha = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
lines = series_attributes(; linestyle, linewidth, linecolor, linealpha)


styles = reshape(styles, 1, length(styles))
markers = reshape(markers, 1, length(markers))
linealphas = reshape(linealphas, 1, length(linealphas))
Plots.plot(y, line=(2, styles, linealphas),markers=(6,markers), label=map(string, styles), legendtitle="linestyle")
=#