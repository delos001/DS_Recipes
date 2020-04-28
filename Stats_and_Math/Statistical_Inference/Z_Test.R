

# find z-score given a probability
# We already know the z-score is 0.6744898.
qnorm(p, 0, 1, lower.tail = TRUE)    # gives the zscore

# gives filled in plot up to 75% (specified p value) under standard normal density
cord.x <- c(-3, seq(-3, 0.67, 0.01), 0.67)
cord.y <- c(0, dnorm(seq(-3, 0.67, 0.01),0,1), 0)
curve(dnorm(x,0,1),xlim=c(-3,3),main="Standard Normal Density", ylab = "density")
polygon(cord.x,cord.y,col="skyblue")
