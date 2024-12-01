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
                       yaxis=("\nproportion halfway", (0, ymax[bits-2]), 0:0.05:ymax[bits-2]),
                       title="\n$bits-bit finite floats")


plot5,plot6,plot7,plot8 = amfplot.(5:8)
plot5678 = plot(plot5,plot6,plot7,plot8,layout=(2,2),size=(1024,1024), margin=(6.0,:mm))
Plots.savefig(plot5678, "./plot5678.png") 

amfplot2(bits) = Plots.plot(amfmatrix2(bits); markers..., lines..., labels..., legends...,
                       xaxis=("precision (bits)", (2-1//4,bits-3//4), 2:bits-1),
                       yaxis=("\nproportion halfway", (0, ymax[bits-2]), 0:0.05:ymax[bits-2]),
                       title="\n$bits-bit finite floats")

# test
# ys = cumsum(randn(8, 3), dims=1)
# zs = cumsum(randn(8, 7), dims=1)
# Plots.plot(ys; markers..., lines..., labels..., legends...)


BitsMin = 2
BitsMax = 8

bitprecisions =[(bits, precision) for bits in BitsMin:BitsMax for precision in 1:bits-1]
sfinites = map(x->finite_values(SFiniteFloats,x...), bitprecisions)
sextendeds = map(x->finite_values(SExtendedFloats,x...), bitprecisions)

sfdict = Dict(bitprecisions .=> sfinites)
sedict = Dict(bitprecisions .=> sextendeds)

sf_addratios = Dict(bitprecisions .=> [add_exactly_halfway(sfdict[bp]) for bp in bitprecisions])
sf_mulratios = Dict(bitprecisions .=> [mul_exactly_halfway(sfdict[bp]) for bp in bitprecisions])
sf_fmaratios1 = [fma_exactly_halfway(sfdict[bp]) for bp in bitprecisions];
sf_fmaratios = Dict(bitprecisions .=> sf_fmaratios1);

sf_adds(bits) = [sf_addratios[(bits, i)] for i=1:bits-1]
sf_muls(bits) = [sf_mulratios[(bits, i)] for i=1:bits-1]
sf_fmas(bits) = [sf_fmaratios[(bits, i)] for i=1:bits-1]

sf_amf(bits) = (add=sf_adds(bits), mul=sf_muls(bits), fma=sf_fmas(bits))
sf_amff(bits) = map(x->Float16.(x), sf_amf(bits))

function sf_amfmatrix(bits)
    vec = collect(Iterators.flatten([Tuple(sf_amff(bits))...]))
    n = length(vec)
    rows = 3
    cols = fld(n, rows)
    reshape(vec, cols, rows)
end


sf_amfplot2(bits) = Plots.plot(sf_amfmatrix(bits); markers..., lines..., labels..., legends...,
                       xaxis=("precision (bits)", (2-1//4,bits-3//4), 1:bits-1),
                       yaxis=("\nproportion halfway", (0, ymax[bits-2]), 0:0.05:ymax[bits-2]),
                       title="\n$bits-bit finite floats")

# se


se_addratios = Dict(bitprecisions .=> [add_exactly_halfway(sedict[bp]) for bp in bitprecisions])
se_mulratios = Dict(bitprecisions .=> [mul_exactly_halfway(sedict[bp]) for bp in bitprecisions])
se_fmaratios1 = [fma_exactly_halfway(sedict[bp]) for bp in bitprecisions];
se_fmaratios = Dict(bitprecisions .=> se_fmaratios1);

se_adds(bits) = [se_addratios[(bits, i)] for i=1:bits-1]
se_muls(bits) = [se_mulratios[(bits, i)] for i=1:bits-1]
se_fmas(bits) = [se_fmaratios[(bits, i)] for i=1:bits-1]

se_amf(bits) = (add=se_adds(bits), mul=se_muls(bits), fma=se_fmas(bits))
se_amff(bits) = map(x->Float16.(x), se_amf(bits))

function se_amfmatrix(bits)
    vec = collect(Iterators.flatten([Tuple(se_amff(bits))...]))
    n = length(vec)
    rows = 3
    cols = fld(n, rows)
    reshape(vec, cols, rows)
end

se_amfplot2(bits) = Plots.plot(se_amfmatrix(bits); markers..., lines..., labels..., legends...,                    
    xaxis=("\nprecision (bits)\n", (2-1//4,bits-3//4), 1:bits-1),                               
    yaxis=("\nproportion halfway\n", (0, ymax[bits-2]), 0:1/16:ymax[bits-2]),                                                                                                                      
    title="\n$bits-bit floats\n",)

function se_plot(bits)
    plt = se_amfplot2(bits)
    remap_yticks(plt)
    # plot!([1/32,3/32,5/32,7/32,9/32];seriestype=:hline,linecolor=:black, linestyle=:dash, linealpha=0.1)       
end

function remap_yticks(plt)
    old_yticks = yticks(plt)
    old_ytick_values = old_yticks[1][1]
    new_ytick_values = map(nd->latex_frac(nd...), [(0,1),(1,16),(1,8),(3,16),(1,4)])
    new_yticks = (old_ytick_values, new_ytick_values)
    yticks!(new_yticks)
end

latex_frac(n,d=1) = isone(d) ? L"%$(n)" : L"\frac{%$(n)}{%$(d)}"


#=
using Plots
using LaTeXStrings
gr()
t = -π:1e-4:π
y = sin.(t)
plot(t,y,lw=3,legend=false)
plot!(xticks=([-π/2],[L"\frac{(-\pi)}{2}"]))
> plot!(xticks=([-π/2,0,pi/2,pi],[L"0",L"\frac{1}{16}", L"\frac{2}{16}", L"\frac{3}{16}"]))
=#

# import ARITH2025: add_exactly_halfway, mul_exactly_halfway, fma_exactly_halfway
   
#=
amf2(bits) = (add=adds(bits)[2:end], mul=muls(bits)[2:end], fma=fmas(bits)[2:end])
amff2(bits) = map(x->Float16.(x), amf2(bits))

# columns = "add", "mul", "fma" rows = precisions
function amfmatrix2(bits)
    vec = collect(Iterators.flatten([Tuple(amff2(bits))...]))
    n = length(vec)
    rows = 3 
    cols = fld(n, rows)
    reshape(vec, cols, rows)
end
=#


plot52,plot62,plot72,plot82 = se_amfplot2.(5:8)
plot56782 = plot(plot52,plot62,plot72,plot82,layout=(2,2),size=(1024,1024), margin=(6.0,:mm))
Plots.savefig(plot56782, "./se_plot56782.png") 
                       

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