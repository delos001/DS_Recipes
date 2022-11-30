

# IN THIS SCRIPT:
# DNORM
# PNORM
# QNORM
# RNORM

# use help() to find out more about each
# reads normAL var x where mean = 3, sd = 2 (variance = 4)
x<-seq(-5,10,by-0.1)
dnorm(x,mean=3,sd=2)
pnorm(x,mean=3,sd=2)
qnorm(x,mean=3,sd=2)
rnorm(x,mean=3,sd=2)

#----------------------------------------------------------
# DNORM: 
# dnorm: gets values on density function, 
dnorm(x, mean=3,sd=2^2): 

dnorm(0,0,1)   # out: 0.39423


# DNORM  to plot normal density curve
set.seed(124)
means<-replicate(1000,mean(sample(Nile,100,replace=TRUE)))
str(means)
mm<-mean(means)
x<-seq(min(means),max(means),1)
std<-sd(means)
hist(means,freq=FALSE, 
     xlab="Nile Flow",
     col='blue',
     main='Nile Flow Means \n1000 samples at n=100')

curve(dnorm(x, mean=mm, sd=std), 
      col = "orange", 
      add=TRUE, 
      lwd = 2)
abline(v=mm,
       col='red',
       lwd=2,
       lty=2)



#----------------------------------------------------------
# PNORM: 
# pnorm: cummulative distribution function (gives probability)

# Data above and below mean---------------------------------
pnorm(-2, 0, 1,lower.tail = TRUE)  # % of data below 2 standard deviations from mean
pnorm(3, 0, 1, lower.tail = FALSE) # % of data above 3 standard deviations from mean
pnorm(-2, 0, 1,lower.tail = TRUE) + 
     pnorm(3, 0, 1, lower.tail = FALSE) # % of data below 2 or above 3 sds from mean


# distribution function at x=2.5, mean=2, and variance= 0.25---
pnorm(2.5, mean=2, sd=sqrt(0.25))

# probability that X is between 1 and 3 -----------------------
#    (subtracts pnorm at 3 from pnorm at 1)
pnorm(3, mean=2, sd=sqrt(0.25)) - pnorm(1, mean=2, sd=sqrt(0.25))


# where 9 = value of interest, 8.25 = population mean, 0.75 = sd: 
#         using zscore formula, z=1.0
pnorm(9, 8.25, 0.75 lower.tail=TRUE)

# probability a randomly selected observation will fall between 3.6 and 5.0 if
#    random variable has a N(4.43, 1.32^2) distribution
pnorm(5.0, 4.43, 1.32) - pnorm(3.6, 4.43, 1.32)


# probability that a standard normal variable is > 1 
#    (zscore: first number in code) using upper
#    tail (concerned about area to right of mean)
pnorm(1,0,1, lower.tail=FALSE)  # out: 0.1586553     

# probability that a standard normal variable is > 1 
#    (zscore: first number in code) using lower 
#    tail but taking 1-pnorm
1-pnorm(1,0,1, lower.tail=TRUE)  # out: 0.1586553


# Using Z-score formula----------------------------------------------
# this is the zscore formula: for mean of 114.8, sd of 13.1, 
# for 36 samples  out: 2.183 (can varify using zscore probability tbl)
z <- (110-114.8)/(13.1/sqrt(36))
pnorm(z,0,1, lower.tail=TRUE)  # out: 0.0139577 

# example 2
z1 <- (5.0 - 4.43)/1.32  # calcluate z score
z2 <- (3.6 - 4.43)/1.32  # calcluate z score
pnorm(z1, 0, 1) - pnorm(z2, 0, 1)  # use pnorm to get probability
    



#----------------------------------------------------------
# QNORM: 
# qnorm (quantile function of normal dist), gives quantiles

qnorm(0.95, mean=2, sd=sqrt(0.25))

# returns the z-score when the probability (or shaded area under the curve) 
#         is given along with the mean and SD.  
#         In this example, the area was on lower tail.  
qnorm(0.4013, 0, 1, lower.tail = TRUE)  # out: -0.2499836

# use concat to produces the zscore of lower tail test:
norm(c(0.25, 0.5, 0.75),   # out: -0.6744898, 0.000000, 0.6744898
     mean=0, sd=1, 
     lower.tail=TRUE)

# calculate z score of two tailed test when alpha is given
# qnorm(1 - 𝜶/𝟐)  gives the z value for two tailed test. z=1.96
qnorm(1-(0.10/2)) 
# calculate z score of one tailed test when alpha is given  (alpha given as 0.1: so 90%)
qnorm(1-0.1)

# calculate z score when percent is used instead of 1-alpha
#  ex: right tailed probability of 0.95 z = 1.645
qnorm(0.9); qnorm(0.95)

# gives both zscores (the positive and negative) for two tailed test 
#    (manually provide the alpha for each end of a 0.05 alpha, 
#    divided by 2 since its two tail)    
qnorm(c(0.025,0.975))  # output: -1.959964, 1.959964


# QNORM: -----------------------------
# example shows qnorm gives typical inputs to pnorm and vice versa
qnorm(c(0.25, 0.5, 0.75),   # out: -0.6744898, 0.000000, 0.6744898
      mean=0, 
      sd=1, 
      lower.tail=TRUE)

pnorm(c(-0.6744898, 0.000000, 0.6744898),0,1,  # out: 0.25, 0.5, 0.75
       lower.tail=TRUE)


# QNORM:
# find z-score given a probability
# We already know the z-score is 0.6744898.
qnorm(p, 0, 1, lower.tail = TRUE)    # gives the zscore

# gives filled in plot up to 75% (specified p value) under standard normal density
cord.x <- c(-3, seq(-3, 0.67, 0.01), 0.67)
cord.y <- c(0, dnorm(seq(-3, 0.67, 0.01),0,1), 0)
curve(dnorm(x,0,1),
      xlim=c(-3,3),
      main="Standard Normal Density", 
      ylab = "density")
polygon(cord.x,cord.y,col="skyblue")


#----------------------------------------------------------
# RNORM: generate random observations
# simulate 100 random observations mean=3, sd=2
rnorm(100,3,2)

prnorm(c(-0.6744898, 0.000000, 0.6744898),0,1,lower.tail=FALSE)
