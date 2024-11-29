all_unique_pairs(xs) = unique_tuples(xs, 2)
all_unique_triples(xs) = unique_tuples(xs, 3)

self_tuples(xs, n) = [fill(x,n) for x in xs]

"""
    all_unique(values, n_dims)

uniquely generate all possible value sequences over n_dims

- Technical Note: yields a sorted Vector of n_dim value vectors
# Examples
```
xs = [5, 3, 7]
all_unique(xs, 2)
[[3, 3], [3, 5], [3, 7], [5, 3], [5, 5], [5, 7], [7, 3], [7, 5], [7, 7]]

xs = ['z', 'a']
all_unique(xs,3)
[['a','a','a'], ['a','a','z'], ['a','z','a'], ['a','z','z'],
 ['z','a','a'], ['z','a','z'], ['z','z','a'], ['z','z','z']]
```
""" all_unique

function all_unique(xs, n_dims)                     
    indices = unique_indexing(length(xs), n_dims)
    sort!(map(idx->xs[idx], indices))
end

all_unique(xs::NTuple, n_dims) = all_unique([xs...], n_dims)

"""
    unique_indexing(n_items, n_dims)

uniquely generate all possible index sequences for n_items over n_dims

- yields a sorted Vector of indexing tuples
# Examples
```
unique_indexing(3, 2)
[[1,1], [2,1], [3,1], [1,2], [2,2], [3,2], [1,3], [2,3], [3,3]]
unique_indexing(2, 3)
[[1,1,1], [2,1,1], [1,2,1], [2,2,1], [1,1,2], [2,1,2], [1,2,2], [2,2,2]]
```
""" unique_indexing

function unique_indexing(n_items, n_dims)
    xs = collect(1:n_items)
    twos = collect(combinations(xs, 2))
    revtwos = map(reverse, twos)
    selftwos = self_tuples(xs, 2)
    append!(twos, revtwos, selftwos)
    sort!(twos)
    if n_dims == 2
        return twos
    end
    threes = []
    for xy in twos
        t = map(x->[x[1]...,x[2]], collect(zip(fill(xy, n_items),xs)))
        push!(threes, t)
    end
    if n_dims == 3
        return reduce(append!, threes)
    end

    fours = []
    for xyz in threes
        t = map(x->[x[1]...,x[2]...,x[3]], collect(zip(fill(xyz, n_items), xs)))    
        push!(fours, t)
    end 
    if n_dims == 4
        return reduce(append!, fours)
    end
    throw(ErrorException("n_dims ($(n_dims)) must be 2, 3, or 4"))
end 

