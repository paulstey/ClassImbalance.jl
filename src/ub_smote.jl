
function ub_smote(X, y, perc_over = 200, k = 5, perc_under = 200)

    dat = hcat(X, y)
    minority_indcs = find(y .== 1.0)

    new_exs = smote_exs(dat[minority_indcs, :], p, perc_over, k)

    majority_indcs = setdiff(1:size(X, 1), minority_indcs)

    # Get the undersample of the "majority class" examples
    sel_majority = sample(majority_indcs,
                          round(Int, (perc_under/100) * size(new_exs, 1)),
                          replace = true)

    # Final dataset (the undersample + the rare cases + the smoted exs)
    newdata = vcat(dat[sel_majority, :], dat[minority_indcs, :], new_exs)
    n = size(newdata, 1)

    # Shuffle the order of instances
    newdata = newdata[sample(1:n, n, replace = false), :]

    X_new = newdata[:, 1:(end-1)]
    y_new = newdata[:, end]

    return (X_new, y_new)
end



# n_change(n, n1) = 0.5n - n1                        # give us number of new positive cases needed for balanced data
