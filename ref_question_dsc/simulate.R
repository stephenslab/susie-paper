h = 0.92
l = 0.7
cormat = rbind(c(1.0, h,   l,   l,   0.9),
               c(h,   1.0, l,   l,   0.7),
               c(l,   l,   1.0, h,   0.8),
               c(l,   l,   h,   1.0, 0.8),
               c(0.9, 0.7, 0.8, 0.8, 1.0))
covmat = as.matrix(Matrix::nearPD(cormat)$mat)
X = MASS::mvrnorm(n=n, rep(0,nrow(covmat)), covmat)
X = cbind(X, matrix(rnorm(n * (p - ncol(X))), nrow=n, ncol=(p - ncol(X))))
b = rep(0,p)
b[c(2,3)] = rnorm(2)
b[5] = b5 * rnorm(1)
y = X %*% b
sigma = sqrt(var(y)*(1-pve)/pve)
epsilon = rnorm(n, mean = 0, sd = sigma)
y = y + epsilon