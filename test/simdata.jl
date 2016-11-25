# SimData
using Distributions
using DataFrames 
using GLM

n = 500
p = 10
X = hcat(ones(n), randn(n, p-1))

noise_coefs = zeros(p - 5)
β = vcat([1.5, 1.1, -10.5, 4.5, 1.9], noise_coefs)
η = X*β                                                   # linear predictor
pr = 1./(1 + exp(-η))                                     # inv-logit

# simulate outcome variable
y = map(π -> rand(Binomial(1, π)), pr)                    
mean(y)

df = DataFrame(X)
df[:y] = y 

# keep only a sub-sample of positive cases
keep_prop = 0.05
pos_cases = find(y .== 1)
keep_indcs = vcat(sample(pos_cases, Int(round(2 * keep_prop * length(pos_cases)))), find(y .== 0))
df2 = df[keep_indcs, :]

sum(df2[:y]).value/n

glm(y ~ 1 + x2 + x3 + x4 + x5 + x6 + x7, df2, Binomial())
