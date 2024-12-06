import Base: round, trailing_zeros

function Base.round(x, xs, mode::RoundingMode=RoundNearest)
    isnan(x) && return xs[isnan.(xs)]
    idx = searchsortedfirst(xs, x)
    idx === 1 && return xs[1]
    idx >= length(xs) && return xs[end]
    x == xs[idx] && return xs[idx]

    pred = xs[idx-1]
    succ = xs[idx]
    dpred = x - pred
    dsucc = succ - x
    tie = dpred === dsucc

    if mode === RoundNearest # TiesToEven
        !tie && return dpred < dsucc ? pred : succ 
        round_tie_to_even(x, pred, succ)
    elseif mode === RoundNearestTiesAway
        !tie && return dpred < dsucc ? pred : succ 
        signbit(x) ? pred : succ
    elseif mode === RoundNearestTiesUp
        !tie && return dpred < dsucc ? pred : succ 
        succ
    elseif mode === RoundToZero
        signbit(x) ? succ : pred
    elseif mode === RoundFromZero
        signbit(x) ? pred : succ
    elseif mode === RoundUp
        succ
    elseif mode === RoundDown
        pred
    elseif mode === RoundFaithful
        !tie && return dpred < dsucc ? pred : succ 
        round_faithful(x, pred, succ)
    elseif mode === RoundStochastic
        round_stochastic(x, pred, succ)
    elseif mode === RoundOdd
        round_odd(x, pred, succ)
    else
        throw(DomainError(mode, "Invalid rounding mode"))
    end
end

function Base.trailing_zeros(x::F) where {F<:AbstractFloat}
    trailing_zeros(reinterpret(Unsigned, x))
end

# pred < x < succ, they cannot be equal
function round_tie_to_even(x, pred, succ)
    if trailing_zeros(pred) > trailing_zeros(succ)
        pred
    else
        succ
    end
end


function round_faithful(x, pred, succ)
end

function round_stochastic(x, pred, succ)
end

function round_odd(x, pred, succ)
end

function roundkp(x, k, p, isSigned=true, isFinite=false)
    !isfinite(x) && return x
    result = unsafe_roundkp(x, k, p, isSigned, isFinite)
    values = floats(k, p, isSigned, isFinite)
    if !(result in values)
        aresult = abs(result)
        idx = searchsortedfirst([values...], aresult)
        lo,hi = values[idx-1], values[idx]
        dlo, dhi = aresult - lo, hi - aresult
        if dlo < dhi
            result = lo
        elseif dlo > dhi
            result = hi
        else # ties to even
            result = iseven(lo) ? lo : hi
        end
        result = copysign(result, x)
    end
    result
end

function unsafe_roundkp(x, k, p, isSigned=true, isFinite=false)
    mx = normal_max(k, p, isSigned, isFinite)
    # gtmx = mx + 
    mn = subnormal_min(k, p, isSigned)
    abs(x) > mx && return copysign(Inf, x)
    abs(x) < mn/2 && return 0.0
    abs(x) <= mn && return copysign(mn, x)
    y = round(abs(x); base=2, sigdigits=p)
    return copysign(y, x)
end

function floats(k, p, isSigned, isFinite)
    if isSigned
        if isFinite
            return sff_floats(k, p)
        else
            return sef_floats(k, p)
        end
    else
        if isFinite
            return uff_floats(k, p)
        else
            return uef_floats(k, p)
        end
    end
end

