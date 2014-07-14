module _

import Base.map
import Base.reduce

# Collection functions
function each(a::Array, iterator::Function)
    for item in a
        iterator(item)
    end
end

# Array functions
function difference(a::Array, rest...)
    rest = vcat(rest...)
    filter((value) -> !in(value, rest), a)
end

without(a::Array, values...) = difference(a, values...)


# Function functions
partial(func::Function, args...) = (bargs...) -> func(args..., bargs...)

function memoize(func::Function, hasher)
    memo = Dict()
    function(args...)
        key = hasher(args...)
        has(memo, key) ? memo[key] : (memo[key] = func(args...))
    end
end

function memoize(func::Function)
    memo = Dict()
    function(args...)
        key = identity(args...)
        has(memo, key) ? memo[key] : (memo[key] = func(args...))
    end
end

function compose(funcs::Function...)
    return function(args...)
        for func in reverse(funcs)
            args = func(args...)
        end
        args
    end
end

end
