all_unique_pairs(xs) = unique_tuples(xs, 2)
all_unique_triples(xs) = unique_tuples(xs, 3)

self_tuples(xs, n) = [fill(x,n) for x in xs]

function unique_tuples(xs, n)                     
    idxs = unique_ntuples(length(xs), n)
    map(idx->xs[idx], idxs)
end

function unique_ntuples(nxs, n)
    xs = collect(1:nxs) 
    selfxs = self_tuples(xs, n)
    xxs = collect(Iterators.flatten(selfxs))  
    unique(permutations(xxs,n))
end 

