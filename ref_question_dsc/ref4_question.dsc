simulate: simulate.R
    @CONF: R_libs = (Matrix, MASS)
    n: 600
    p: 2000
    b5: 0, 1
    # total PVE by all variables
    pve: 0.2
    $X: X
    $y: y
    $b: b

susie: R(res <- susieR::susie(X,y,L=L,estimate_prior_method="simple",max_iter=1000))
    @CONF: R_libs = susieR
    X: $X
    y: $y
    L: 8
    $cs: res$sets
    $elbo: susieR::susie_get_objective(res)

susie_true_init(susie): R(s_init = susieR::susie_init_coef(which(b!=0), b[which(b!=0)], ncol(X));
                          res <- susieR::susie(X,y,L=L,s_init=s_init,estimate_prior_method="simple",max_iter=1000))
    b: $b

DSC:
    define:
        analyze: susie, susie_true_init
    run: simulate * analyze
    replicate: 500