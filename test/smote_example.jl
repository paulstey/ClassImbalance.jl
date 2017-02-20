using Distributions

include("../src/smote_exs.jl")



n = 100
p = 10
# X = hcat(ones(n), randn(n, p-1))

Σ = [1.0 0.8 0.4 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
     0.8 1.0 0.6 0.2 0.0 0.0 0.0 0.0 0.0 0.0;
     0.4 0.6 1.0 0.6 0.4 0.0 0.0 0.0 0.0 0.0;
     0.0 0.2 0.6 1.0 0.8 0.0 0.0 0.0 0.0 0.0;
     0.0 0.0 0.4 0.8 1.0 0.0 0.0 0.0 0.0 0.0;
     0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0;
     0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0;
     0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0;
     0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0;
     0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0]

mvn = MvNormal(ones(p), Σ)

srand(round(Int, time()))

X = rand(mvn, n)'
cor(X)

ϵ = rand(Normal(2, 0.5), n)                                  # gives on average 10% minority class,
# ϵ = rand(Normal(-2.5, 0.5), n)                               # gives 5% minority class,
# ϵ = rand(Normal(4, 0.5), n)                                  # gives 15% minority class,

β = [-3, -4, 1, -5, -4, 0.0, 0.0, 0.0, 0.0, 0.0]
η = X*β + ϵ                                                    # linear predictor w/ error
pr = 1.0 ./ (1.0 + exp(-η))                                    # inv-logit

# simulate outcome variable
y = map(π -> rand(Binomial(1, π)), pr)
mean(y)
