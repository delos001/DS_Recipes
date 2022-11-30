

# Input:
#    x: linearly separable training data set
#    y: label coding (assumed -1 and +1)
#    beta0: initial beta parameters, can be single number or vector of size ncol(x)
#    tol: tolerance for convergence check
#    minepochs: minimum number of times to cycle all training points
#    maxepochs: maximum number of times to cycle all training points
#    verbose: print messages as iterations go
#
# Output: vector of estimated beta parameters


perceptron <- function(x, y, beta0 = 1, tol = 1e-8, minepochs = 2, maxepochs = 100, verbose = TRUE)
{
  N <- nrow(x)
  p <- ncol(x)
  
  if (length(y) != N) {
    stop("The number of rows in x is not the length of y")
  }
  
  if (length(beta0 == 1))
    beta0 <- rep(beta0, p)
  
  if (length(beta0) != p) {
    stop("The dimension of beta0 is not the number of columns in x")
  }
  
  # Make it stochastic!
  o <- sample(N)
  x <- x[o,]
  y <- y[o]
  
  itlim <- maxepochs * N
  itmin <- minepochs * N
  
  eps <- .Machine$double.xmax
  beta <- beta0
  
  k <- 0; 
  while ((eps > tol && k < itlim) || (k < itmin)) {
    beta0 <- beta
    i <-  (k %% N) + 1
    
    # Check if this point is misclassified
    d <- y[i] * crossprod(beta, x[i,])
    if (d < 0) {
      
      # If it is misclassified then update beta
      beta <- beta0 + y[i] * x[i,]
    }
    
    # Update epsilon
    eps <- sqrt(sum((beta0 - beta)^2))/sqrt(sum(beta0^2))
    
    k <- k + 1
    if (verbose)
      cat(sprintf("It: %d i:%d d:%.4f eps: %.4f\n", k, i, d, eps))
  }
  if (k == itlim)
    warning("Failed to converge")
  
  return(beta)
}
