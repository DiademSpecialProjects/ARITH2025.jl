proportion_halfway(xs, results) = 
    count_halfway(xs, results) // length(results)

function count_halfway(xs, results)
    halfway_values = values_halfway_between(xs)
    sum(map(x->x in halfway_values, results))
end

function values_halfway_between(xs)
    xs_sorted = map(Float64, sort(xs))
    zipped = zip(xs_sorted[1:end-1], xs_sorted[2:end])
    map(xy->(xy[1]/2 + xy[2]/2), zipped)
end


