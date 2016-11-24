# ubSmoteExs.R
using DataFrames 

d = readtable("people.csv", makefactors = true)

function factor_cols(dat::DataFrame)
    p = size(dat, 2)
    are_factors = falses(p)
    for j = 1:p 
        if isa(dat[:, j], NullableCategoricalArray)
            are_factors[j] = true 
        end 
    end 
    indcs = find(are_factors)
    return indcs 
end 

factor_cols(d)

function factor_to_float(v)
    unique_cats = unique(v)         # unique categories
    sort!(unique_cats)
    cat_dictionary = Dict{String, Float64}()
    val = 1.0
    for k in unique_cats 
        cat_dictionary[k] = val 
        val += 1.0 
    end 

    n = length(v)
    out = zeros(n)
    for i = 1:n 
        out[i] = cat_dictionary[v[i]]
    end 
    out 
end 



function smote_exs(dat::DataFrame, tgt::Symbol, N = 200, k = 5)
    n, p = size(dat)
    T = Array{Float64, 2}(n, p-1)
    factor_indcs = factor_cols(dat)
    
    for j = 1:size(T, 2)
        if j ∈ factor_indcs
            T[:, j] = factor_to_float(dat[:, j])
        else 
            T[:, j] = dat[:, j]
        end 
    end 

    # when N < 100, only a percentage of cases will be SMOTEd 
    if N < 100
        idx = sample(1:n, Int(round(N/100)*n))
        T = T[idx, :]
    end 

    n, p = size(T)
    ranges = zeros(p)
    for j = 1:p 
        ranges[j] = maximum(T[:, j]) - minimum(T[:, j])
    end 

    n_exs = Int(round(N/100))
    xnew = Array{Float64, 2}(n_exs*n, p)

    for i = 1:n 
        xd = 























