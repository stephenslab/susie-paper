# This script implements a small numerical experiment to respond to a
# question from Reviewer 4.
library(Matrix)
library(mvtnorm)
library(susieR)

# Script parameters
ns <- 1000          # Number of simulations.
n  <- 600           # Number of samples.
b  <- c(0,1,1,0,0)  # True effects.
se <- 3             # residual s.d.

# Correlation among variables x1 through x5.
S  <- rbind(c(1.0,  0.92, 0.7,  0.7,  0.9),
            c(0.92, 1.0,  0.7,  0.7,  0.7),
            c(0.7,  0.7,  1.0,  0.92, 0.8),
            c(0.7,  0.7,  0.92, 1.0,  0.8),
            c(0.9,  0.7,  0.8,  0.8,  1.0))
S <- as.matrix(nearPD(S)$mat)

# Initiialize the sequence of pseudorandom numbers.
set.seed(1)

# Repeat for each simulation.
cs  <- vector("list",ns)
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
  cs[[i]]  <- fit$sets$cs
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

# Summarize the susie posterior inclusion probabilities (PIPs) across all
# simulations.
cat("PIPs averaged across all simulations:\n")
pip           <- do.call(rbind,pip)
colnames(pip) <- c("x1","x2*","x3*","x4","x5")
print(colMeans(pip))
cat("* indicates that the variable affects the outcome (Y) in the",
    "simulations.\n")
