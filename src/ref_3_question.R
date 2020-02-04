library(Matrix)
library(mvtnorm)
library(susieR)

# SCRIPT PARAMETERS
ns <- 1000          # Number of simulations.
n  <- 600           # Number of samples.
b  <- c(1,0)  # True effects.
se <- 3             # residual s.d.
r <- 0.9
S <- rbind(c(1.0,  r),
           c(r, 1.0))
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
out

print('X2 pip mean and median')
non_effect_pip = do.call(cbind,lapply(1:length(pip), function(i) pip[[i]][c(2)]))
print(apply(non_effect_pip, 1, mean))
print(apply(non_effect_pip, 1, median))


print('X1 pip mean and median')
effect_pip = do.call(cbind,lapply(1:length(pip), function(i) pip[[i]][c(1)]))
print(apply(effect_pip, 1, mean))
print(apply(effect_pip, 1, median))


two_var_cs = sapply(1:length(cs), function(i) length(cs[[i]][[1]])==2)
print(length(which(two_var_cs)))
if (length(which(two_var_cs))>0) {
	print('X2 pip for CS 1:2 mean and median')
	print(apply(non_effect_pip[,which(two_var_cs),drop=F], 1, mean))
	print(apply(non_effect_pip[,which(two_var_cs),drop=F], 1, median))
	print('X1 pip for CS 1:2 mean and median')
	print(apply(effect_pip[,which(two_var_cs),drop=F], 1, mean))
	print(apply(effect_pip[,which(two_var_cs),drop=F], 1, median))
}
                                  
b_lasso = matrix(b_lasso, ns,length(b),byrow=T)    
print('lasso false negative')
print(length(which(b_lasso[,1]==0)))
print('lasso false positive')
print(length(which(b_lasso[,2]!=0)))
