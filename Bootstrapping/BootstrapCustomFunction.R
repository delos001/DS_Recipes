

alpha=function(x,y){
	vx=var(x)
	vy=var(y)
	cxy=cov(x,y)
	(vy-cxy)/(vx+vy-2*cxy)
}

alpha(Portfolio$X, Portfolio$Y) # using above funct, run x and y on df


# create new function, using index which are numbers assigned 
#   to each observation from 1-n  (
#   index says which observations get represented)
# with takes the data frame then a command: using the data in the data frame, 
#   execute the command (compute alpha X and Y)
alpha.fn=function(data, index){
	with(data[index,], alpha(X,Y))
}

# runs alpha.fn function using Portfolio data: observations 1 to 100
alpha.fn(Portfolio, 1:100)


# Now we run the bootstrap
# we run alpha.fn one more time but instead of using the index numbers, 
#   we take a random sample from numbers 1 to 100 using sample size of 100 
#   and the observations seleted can be replaced
# call boot function using the portfolio data and the alpha.fn function 
#   and we tell it to do it 1000 times
# gives a summary of the bootstrap results: gives estimate, the estimate of 
#   bias and estimate of standard error (stand error is statistic of interest here).  
# Hopefully the bias is negligible,
set.seed(1)
alpha.fn(Portfolio, sample(1:100, 100, replace=True))

boot.out=boot(Portfolio, alpha.fn, R=1000)
boot.out


plot(boot.out)
