

#----------------------------------------------------------
# BASIC EXAMPLE
skewness(food$Income)
kurtosis(food$Income)

library(moments)

moments::skewness(df2$L_Ratio)
moments::kurtosis(df2$L_Ratio)


#----------------------------------------------------------
# EXAMPLE 2
# WITH PLOT EXAMPLE
require(moments)

set.seed(123)

normal_x <- rnorm(10000, mean=0, sd=1)

skewness(normal_x)
kurtosis(normal_x)

cells <- seq(-4,4,0.5)
x <- seq(-3.75,3.75,0.5)

hist(normal_x, 
     prob=TRUE, 
     breaks = cells, 
     ylim=c(0.0,0.5), 
     col = "blue")
curve(dnorm(x,mean=0,sd=1),
      add=TRUE, 
      col="orange",
      lwd=2)
