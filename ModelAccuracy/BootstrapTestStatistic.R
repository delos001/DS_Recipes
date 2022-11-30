


library(boot)
alpha.fn=function (data ,index){    # create object called alpha.fn, assign it as a function
  X=data$X[index]   # takes an an input X value and index on which alphas should be used
  Y=data$Y[index]   # takes an an input Y value and index on which alphas should be used
  return ((var(Y)-cov(X,Y))/(var(X)+var(Y) -2*cov(X,Y)))
}

# in this line, we tell the function to use portfolio data and use observations 1:100.
alpha.fn(Portfolio, 1:100)


# this is similar except uses the sample function to randomly select 
#     100 observations from the 100 of the observations.  
#     - Equivalent to constructing a new bootstrap data set and recomputing 
#           alpha based on the new data set.
# You perform bootstrap methods by performing this command many times
set.seed(1)
alpha.fn(Portfolio, sample(100, 100, replace=T))


# performs the replace function line above 1000 times and outputs the alpha value, 
#   the bias of alpha, and the std error of alpha
boot(Portfolio, alpha.fn, R=1000)
