module FDPrecompilationIssue

using ForwardDiff
using PrecompileTools

function print_tagcount(x)
    println("Tag count of $x is ", ForwardDiff.tagcount(ForwardDiff.tagtype(x)))
    x
end

dispatch(::Val{0}, x) = x
dispatch(::Val{1}, x) = ForwardDiff.derivative(z -> x + print_tagcount(z^2), x)

# Use indirection to prevent precompilation of `dispatch`
indirection = dispatch

function compute_derivative(α::Int, y)
    ForwardDiff.derivative(x -> indirection(Val{α}(), print_tagcount(x)), y)
end

@setup_workload begin
    @compile_workload begin
        # Increase FD tag counter to 1
        ForwardDiff.derivative(x -> x^2, 1)
        @assert compute_derivative(0, 0) == 1
        @assert compute_derivative(0, 10) == 1
    end
end

end # module FDPrecompilationIssue
