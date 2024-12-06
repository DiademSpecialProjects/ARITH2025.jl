add2(x,y,xs, mode) = round(Float64(x)+Float64(y), xs, mode)
add2(xy, xs, mode) = add2(xy[1], xy[2], xs, mode)
sub2(x,y,xs, mode) = round(Float64(x)-Float64(y), xs, mode)
mul2(x,y,xs, mode) = round(Float64(x)*Float64(y), xs, mode)
fma3(x,y,z, xs, mode) = round(fma(Float64(x), Float64(y), Float64(z)), xs, mode)
faa3(x,y,z, xs, mode) = round((Float64(x) + Float64(y) + Float64(z)), xs, mode)

add3(a,b,c,d, xs, mode) = round(Float64(a)+Float64(b)+Float64(c)+Float64(d), xs, mode)
mul3(a,b,c,d, xs, mode) = round(Float64(a)*Float64(b)*Float64(c)*Float64(d), xs, mode)
add4(a,b,c,d, xs, mode) = round(Float64(a)+Float64(b)+Float64(c)+Float64(d), xs, mode)
mul4(a,b,c,d, xs, mode) = round(Float64(a)*Float64(b)*Float64(c)*Float64(d), xs, mode)

function addscaled(v, xs, scaleby, mode)
    ys = map(x->Float64(x) * scaleby, v)
    yspaired = adjacentpairs(ys)
    z = foldl(x->add2(x, xs, mode), yspaired)
    round(z, xs, mode)
end

#=
 ys = map(x->Float64(x) * scaleby, v);
 ys = map(Float64, v);
 
 yspaired = adjacentpairs(ys);
 pairsums = map(xy->+(xy...), yspaired);

=#

function adjacentpairs(xs)
    n = length(xs)
    halfn = n >> 1
    if !iseven(n)
        throw(DomainError("n ($(length(n))) must be even"))
    end
    xys = reshape(xs, 2, halfn)
    [xys[:,i] for i=1:halfn]
end

