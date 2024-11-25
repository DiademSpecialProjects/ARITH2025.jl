"""
    all_pairs_commutative(xs)

generates commutative pairs with self-pairings

e.g. [1,2] -> [(1,1), (1,2), (2,2)]
"""
function all_pairs_commutative(xs)
    ns = collect(1:length(xs))
    paired_indices = commutative_tuples(ns, 2)
    map(idxs->xs[idxs], paired_indices)
end

"""
    all_triples_firsttwo_commutative(xs)

completes commutative pairs with self-pairings
by postpending each x in xs to successive pairs

e.g. [1,2] -> [(1,1,1), (1,1,2), (1,2,1), (1,2,2),
               (2,2,1), (2,2,2)]
"""
function all_triples_firsttwo_commutative(xs)
    n = length(xs)
    cs = commutative_tuples(collect(1:n), 2)
    zs = map(x->map(i->[x...,i], 1:n), cs)
    tripled_indices = collect(Iterators.flatten(zs))
    map(idxs->xs[idxs], tripled_indices)
end

function commutative_tuples(xs, n)
    cs = collect(combinations(xs, n))     
    cps = append!(cs, self_tuples(xs, n))   
    sort!(cps)
end

all_pairs_unique(xs) = unique_tuples(xs, 2)
all_triples_unique(xs) = unique_tuples(xs, 3)

self_tuples(xs, n) = [fill(x,n) for x in xs]

function unique_tuples(xs, n)                  
    idxs = uniquely_tupled(length(xs), n)
    map(idx->xs[idx], idxs)
end

function uniquely_tupled(nxs, n)
    xs = collect(1:nxs) 
    selfxs = self_tuples(xs, n)
    xxs = collect(Iterators.flatten(selfxs))  
    unique(permutations(xxs,n))
end 

