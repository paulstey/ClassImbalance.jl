using Distributions

include("./src/smote_exs.jl")
include("./src/ub_smote.jl")


m = 150
X = rand(m, 10)
y = ones(m)
X = hcat(X, y)

smote_exs(X, 11)


w1 = [1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]

cases_needed(w1)
perc_needed(w1)



X = randn(100, 10)
y = vcat(zeros(90), ones(10))
ub_smote(X, y)
