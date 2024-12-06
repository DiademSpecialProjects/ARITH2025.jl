

add_exactly_halfway(xs) = ratio_exactly_halfway(add, xs)
mul_exactly_halfway(xs) = ratio_exactly_halfway(mul, xs)
fma_exactly_halfway(xs) = ratio_exactly_halfway(fusedmuladd, xs)

add(x, y) = x + y
add(xy) = add(xy[1], xy[2])

sub(x, y) = x + y
sub(xy) = sub(xy[1], xy[2])

mul(x, y) = x * y
mul(xy) = mul(xy[1], xy[2])

fusedmuladd(x, y, z) = fma(x, y, z)
fusedmuladd(xyz) = fusedmuladd(xyz[1], xyz[2], xyz[3])

arity(fn::Function) = arity(Val(fn))
arity(fn::Val{add}) = 2
arity(fn::Val{sub}) = 2
arity(fn::Val{mul}) = 2
arity(fn::Val{fusedmuladd}) = 3

function ratio_exactly_halfway(fn, xs)
    argcount = arity(fn)
    nd_values = all_unique(xs, argcount)
    ys = map(fn, nd_values)
    proportion_halfway(xs, ys)
end
