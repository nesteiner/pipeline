#=
@pipeline variable begin
    x -> x + 1
    x -> x * 2
    x -> x / 3
end

=#

# 1 |>
#     x -> x + 1 |>
#     x -> x * 2 |>
#     x -> x / 3
module Pipeline

export @pipeline
macro pipeline(variable, beginExpr::Expr)
    exprs = filter(x -> isa(x, Expr), beginExpr.args) |>
        nums -> convert(Vector{Expr}, nums)
    firstFunc = first(exprs)
    
    if length(exprs) == 1
        quote
	    @pipeline $firstFunc($variable)
        end
    else
        restFuncs = exprs[2:end]

        quote
	    @pipeline $firstFunc($variable) $restFuncs
        end
    end
end

macro pipeline(variable, funcExprs::Vector{Expr})
    firstFunc = first(funcExprs)
    
    if length(funcExprs) == 1
        quote
	    @pipeline $firstFunc($variable)
        end
    else
        restFuncs = funcExprs[2:end]

        quote
	    @pipeline $firstFunc($variable) $restFuncs
        end
    end
end

macro pipeline(variable)
    variable
end

end