simulate: simulate.R
    @CONF: R_libs = (Matrix, MASS)
    n: 1000
    p: 2000
    b5: 0, 1
    $X: X
    $y: y

susie: R(res <- susieR::susie(X,y,L=L,estimate_prior_method="simple",max_iter=1000))
    @CONF: R_libs = susieR
    X: $X
    y: $y
    L: 8
    $cs: res$sets

evaluate: evaluate.R
    cs: $cs
    $has_2: has_2
    $has_3: has_3
    $has_5: has_5
    $in_12: in_12
    $in_34: in_34
    $own: own
    $mixed: mixed

DSC:
    run: simulate * susie * evaluate
    replicate: 500
