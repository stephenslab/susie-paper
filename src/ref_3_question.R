library(glmnet)
library(mvtnorm)
library(susieR)

# SCRIPT PARAMETERS
ns <- 1000    # Number of simulations.
n  <- 600     # Number of samples.
b  <- c(1,0)  # True effects.
se <- 3       # Residual s.d.
r  <- 0.9     # Correlation between x1 and x2.
S  <- rbind(c(1,r),
            c(r,1))
set.seed(1)

# Repeat for each simulation.
cs      <- vector("list",ns)
pip     <- vector("list",ns)
b_lasso <- matrix(0,ns,2)
for (i in 1:ns) {
  cat("*")

  # Simulate data.
  X <- rmvnorm(n,sigma = S)
  y <- drop(X %*% b + se*rnorm(n))

  # Fit the susie and Lasso models, and store the inferred CS's.
  fit         <- susie(X,y,
                       estimate_prior_method = "simple",
                       min_abs_corr = 0,max_iter = 500)
  cs[[i]]     <- fit$sets$cs
  pip[[i]]    <- fit$pip
  fit.lasso   <- cv.glmnet(X,y)
  b_lasso[i,] <- coef(fit.lasso)[-1]
}
cat("\n")

# Summarize the inferred CSs across all simulations.
out <- sapply(cs,function (x) paste(as.character(x),collapse = ","))
out <- table(factor(out))
out <- sort(out,decreasing = TRUE)
out <- as.data.frame(out)
names(out) <- c("CSs","count")
print(out)

# Summarize the susie posterior inclusion probabilities (PIPs) across all
# simulations.
pip1 <- sapply(1:length(pip),function(i) pip[[i]][1])
pip2 <- sapply(1:length(pip),function(i) pip[[i]][2])
cat("      mean median\n")
cat(sprintf("x1: %0.4f %0.4f\n",mean(pip1),median(pip1)))
cat(sprintf("x2: %0.4f %0.4f\n",mean(pip2),median(pip2)))

# Summarize the susie posterior inclusion probabilities (PIPs) across
# all simulations in which the inferred CS contains both x1 and x2.
non_effect_pip <- do.call(cbind,lapply(1:length(pip),
                                       function(i) pip[[i]][2]))
print(apply(non_effect_pip,1,mean))
print(apply(non_effect_pip,1,median))

# Summarize Lasso results.
cat("Number of Lasso false negatives:",sum(b_lasso[,1] == 0),"\n")
cat("Number of Lasso false positives:",sum(b_lasso[,2] != 0),"\n")
