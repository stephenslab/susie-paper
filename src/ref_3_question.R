library(Matrix)
library(mvtnorm)
library(susieR)

# SCRIPT PARAMETERS
ns <- 1000          # Number of simulations.
n  <- 600           # Number of samples.
b  <- c(1,0)  # True effects.
se <- 3             # residual s.d.

S <- rbind(c(1.0,  0.95),
           c(0.95, 1.0))
set.seed(1)

# Repeat for each simulation.
cs <- vector("list",ns)
pip <- vector("list",ns)
b_lasso <- vector()
for (i in 1:ns) {
  cat("*")

  # Simulate data.
  X <- rmvnorm(n,sigma = S)
  y <- drop(X %*% b + se*rnorm(n))

  # Fit the susie model, and store the inferred CS's.
  fit <- susie(X,y,
               estimate_prior_method = 'simple',
               min_abs_corr = 0, max_iter=500)
  cs[[i]] <- fit$sets$cs
  pip[[i]] <- fit$pip
  fit.lasso <- glmnet::cv.glmnet(X,y)
  b_lasso <- append(b_lasso, as.vector(coef(fit.lasso)[-1]))
}
cat("\n")

# Summarize the inferred CSs across all simulations.
out <- sapply(cs,function (x) paste(as.character(x),collapse = ","))
out <- table(factor(out))
out <- sort(out,decreasing = TRUE)
out <- as.data.frame(out)
names(out) <- c("CSs","count")
print(out)

non_effect_pip = do.call(cbind,lapply(1:length(pip), function(i) pip[[i]][c(2)]))
apply(non_effect_pip, 1, mean)
apply(non_effect_pip, 1, median)

effect_pip = do.call(cbind,lapply(1:length(pip), function(i) pip[[i]][c(1)]))
apply(effect_pip, 1, mean)
apply(effect_pip, 1, median)
                                  
b_lasso = matrix(b_lasso, ns,length(b),byrow=T)    
length(which(b_lasso[,1]==0))
length(which(b_lasso[,2]!=0))                                  
