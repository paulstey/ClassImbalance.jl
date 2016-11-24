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
    unique_cats = levels(v)         # unique categories
    sort!(unique_cats)
    cat_dictionary = Dict{Nullable{String}, Float64}()
    val = 1.0
    for k in unique_cats 
        cat_dictionary[Nullable(k)] = val 
        val += 1.0 
    end 
    out = map(x -> cat_dictionary[x], v)
    out 
end 


function float_to_factor(v, levels)
    sort!(levels)
    out = map(x -> levels[Int(round(x))], v)
    return out 
end 


# This function behaves a bit like R's scale() 
# function when it's call with MARGIN = 2.
function rscale(X, center, scale) 
    n, p = size(X)
    out = Array{Float64, 2}(n, p)
    for i = 1:n 
        for j = 1:p 
            out[i, j] = (X[i, j] - center[j])/scale[j]
        end 
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

    n_exs = Int(round(N/100))   # num. of artificial ex for each member of T
    xnew = Array{Float64, 2}(n_exs*n, p)

    for i = 1:n 

        # the k nearest neighbors of case T[i, ]
        xd = rscale(T, T[i, :], ranges)
        
        for col in factor_indcs 
            xd[:, col] = map(x -> x == 0.0 ? 1.0 : 0.0, xd[:, col])
        end 

        dd = xd.^2 * ones(p)
        kNNs = sortperm(dd)[2:(k+1)]

        for l = 1:n_exs
            neighbor = sample(1:k)
            ex = Array{Float64, 1}(p)

            # the attribute values of generated case
            difs = T[kNNs[neighbor], :] - T[i, :]
            xnew[(i - 1)*n_exs + l, :] = T[i, :] + rand()*difs

            # For each of factor variable, sample at random the original value 
            # of Person i or the value that one of Person i's nearest neighbors has.
            for col in factor_indcs
                xnew[(i - 1)*n_exs + l, col] = sample(vcat(T[kNNs[neighbor], col], T[i, col]))
            end 
        end 
    end 

    new_cases = DataFrame()
    for j = 1:p
        if j ∈ factor_cols
            new_cases[:, j] = 
        else 
            new_cases[:, j] = xnew[:, j]
        end 
    end 





















