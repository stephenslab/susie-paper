library(Matrix)
library(mvtnorm)
library(susieR)

# SCRIPT PARAMETERS
ns <- 1000          # Number of simulations.
n  <- 600           # Number of samples.

# Ref 4
b  <- c(0,1,1,0,0)  # True effects.
se <- 3             # residual s.d.

# S  <- rbind(c(   1, 0.99,  0.7,  0.7, 0.9),
#             c(0.99,    1,  0.7,  0.7, 0.9),
#             c( 0.7,  0.7,    1, 0.99, 0.8),
#             c( 0.7,  0.7, 0.99,    1, 0.8),
#             c( 0.9,  0.9,  0.8,  0.8,   1))
S <- rbind(c(1.0,  0.92, 0.7,  0.7,  0.9),
           c(0.92, 1.0,  0.7,  0.7,  0.7),
           c(0.7,  0.7,  1.0,  0.92, 0.8),
           c(0.7,  0.7,  0.92, 1.0,  0.8),
           c(0.9,  0.7,  0.8,  0.8,  1.0))
S <- as.matrix(nearPD(S)$mat)
set.seed(1)

# Repeat for each simulation.
cs <- vector("list",ns)
pip <- vector("list",ns)
for (i in 1:ns) {
  cat("*")

  # Simulate data.
  X <- rmvnorm(n,sigma = S)
  y <- drop(X %*% b + se*rnorm(n))

  # Fit the susie model, and store the inferred CS's.
  fit <- susie(X,y,L = 2,
               standardize = FALSE,
               estimate_prior_variance = FALSE,
               scaled_prior_variance = 1,
               min_abs_corr = 0)
  cs[[i]] <- fit$sets$cs
  pip[[i]] <- fit$pip

}
cat("\n")

# Summarize the inferred CSs across all simulations.
out <- sapply(cs,function (x) paste(as.character(x),collapse = ","))
out <- table(factor(out))
out <- sort(out,decreasing = TRUE)
out <- as.data.frame(out)
names(out) <- c("CSs","count")
print(out)

non_effect_pip = do.call(cbind,lapply(1:length(pip), function(i) pip[[i]][c(1,4,5)]))
apply(non_effect_pip, 1, mean)

effect_pip = do.call(cbind,lapply(1:length(pip), function(i) pip[[i]][c(2,3)]))
apply(effect_pip, 1, mean)