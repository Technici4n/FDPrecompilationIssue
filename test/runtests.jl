using FDPrecompilationIssue
using ForwardDiff

@assert FDPrecompilationIssue.compute_derivative(1, 0) == 2