proportion_halfway(xs, ys) = nhalfway(xs, ys) // length(ys)

function nhalfway(xs, ys)
    halfways = halfway(xs)
    sum(map(x->x in halfways, ys))
end

function halfway(xs)
    n = length(xs)
    sxs = map(Float64, sort(xs))
    zipped = zip(sxs[1:end-1], sxs[2:end])
    map(xy->+(xy...) ./2, zipped)
end


