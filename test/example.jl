using Combinatorics,JLD2, LaTeXStrings, Plots, ARITH2025

import MiniFloatModels: SFiniteFloats, SExtendedFloats
import ARITH2025: values_halfway_between

function addmul_ratios(bits, sigbits; constructor=SExtendedFloats)
    T = constructor(bits, sigbits)
    S = filter(isfinite,[T.floats...])
    Shalfway = values_halfway_between(S)
    
    fwdtwos = collect(combinations(S,2))
    revtwos = map(reverse,fwdtwos)
    selftwos = ARITH2025.self_tuples(S,2)
    append!(fwdtwos,revtwos,selftwos)
    Spairs = sort(fwdtwos)
    
    Sadds = map(ab->ab[1]+ab[2],Spairs)
    Sadds_halfway = 0
 
    Smuls = map(ab->ab[1]*ab[2],Spairs)
    Smuls_halfway = 0
 
    for x in Sadds
        Sadds_halfway +=  any(x .== Shalfway)
    end
    
    for x in Smuls
        Smuls_halfway +=  any(x .== Shalfway)
    end

    Sadds_proportion = Sadds_halfway // length(Sadds)
    Sadds_percent = round(100*Sadds_proportion; sigdigits=3)
    
    Smuls_proportion = Smuls_halfway // length(Smuls)
    Smuls_percent = round(100*Smuls_proportion; sigdigits=3)

    (add=(Sadds_proportion, Sadds_percent), mul=(Smuls_proportion, Smuls_percent))
end

addmul_ratios(bits;constructor=SExtendedFloats) = [addmul_ratios(bits, i ;constructor) for i=1:bits-1]

addmul_dict = Dict{Int, Any}()

for i in 3:5
    addmul_dict[i] = addmul_ratios(i;constructor=SFiniteFloats)
end
for i in 6:8
    addmul_dict[i] = addmul_ratios(i;constructor=SExtendedFloats)
end
for i in 9:10
    addmul_dict[i] = addmul_ratios(i;constructor=SExtendedFloats)
end

cd("data")
save_object("addmul_dict.jld2", addmul_dict)

i=11;addmul_dict[i] = addmul_ratios(i;constructor=SExtendedFloats);
save_object("addmul_dict.jld2", addmul_dict)

i=12;addmul_dict[i] = addmul_ratios(i;constructor=SExtendedFloats);
save_object("addmul_dict.jld2", addmul_dict)

#>>> save_object("addmul_dict_3to12.jld2", addmul_dict)

#=
for i in 13:14
    addmul_dict[i] = addmul_ratios(i;constructor=SExtendedFloats)
end
for i in 15:16
    addmul_dict[i] = addmul_ratios(i;constructor=SExtendedFloats)
end
=#

#=

julia> [addmul_dict[i][i-2].add for i=3:12]
10-element Vector{Tuple{Rational{Int64}, Float64}}:
 (8//49, 16.3)
 (8//45, 17.8)
 (184//961, 19.1)
 (724//3721, 19.5)
 (3108//15625, 19.9)
 (12868//64009, 20.1)
 (52356//259081, 20.2)
 (211204//1042441, 20.3)
 (848388//4182025, 20.3)
 (3400708//16752649, 20.3)

julia> [addmul_dict[i][3].mul for i=4:12]
9-element Vector{Tuple{Rational{Int64}, Float64}}:
 (16//75, 21.3)
 (172//961, 17.9)
 (604//3721, 16.2)
 (2332//15625, 14.9)
 (9244//64009, 14.4)
 (36892//259081, 14.2)
 (147484//1042441, 14.1)
 (589852//4182025, 14.1)
 (2359324//16752649, 14.1)
 
[addmul_dict[i][5].mul for i=6:12]
7-element Vector{Tuple{Rational{Int64}, Float64}}:
 (408//3721, 11.0)
 (1388//15625, 8.88)
 (4908//64009, 7.67)
 (17716//259081, 6.84)
 (67508//1042441, 6.48)
 (52772//836405, 6.31)
 (1043636//16752649, 6.23)
 
[addmul_dict[i][5].add for i=6:12]
7-element Vector{Tuple{Rational{Int64}, Float64}}:
 (0, 0.0)
 (3108//15625, 19.9)
 (10276//64009, 16.1)
 (24612//259081, 9.5)
 (53284//1042441, 5.11)
 (110628//4182025, 2.65)
 (225316//16752649, 1.34) 
=#

