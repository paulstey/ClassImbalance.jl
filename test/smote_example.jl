using Distributions

include("./src/smote_exs.jl")
include("./src/ub_smote.jl")


m = 150
X = rand(m, 10)
y = ones(m)
X = hcat(X, y)

smote_exs(X, 11)


w1 = [1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]

cases_needed(w1)
pct_needed(w1)



X = randn(150, 10);
y = vcat(zeros(140), ones(10));
X2, y2 = smote(X, y, 5);

length(y2)
countmap(y2)




X = randn(150, 10);
y = vcat(zeros(130), ones(20));
X2, y2 = smote(X, y, 5)

length(y2)
countmap(y2)
