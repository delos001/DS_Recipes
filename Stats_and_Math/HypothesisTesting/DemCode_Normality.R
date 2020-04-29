# Predict 401 Demonstration Calculations using R for Week 4

#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# The normal distribution plays an important role in statistical inference.

help(dnorm)

# Generate a plot of the standard normal density function and cdf.

x <- seq(-3.0,3.0,0.1)

par(mfrow = c(2,1))
plot(x, dnorm(x, mean = 0, sd = 1), type = "l", col = "red", ylab = "density",
     xlab = "standard normal variable", main = "Standard Normal Density Function")
plot(x, pnorm(x, mean = 0, sd = 1), type = "l", col = "blue", ylab = "probability",
     xlab = "standard normal variable", main = "Standard Normal cdf Function")
par(mfrow = c(1,1))

# Find quantiles at 5%, 25%, 50%, 75%, 95%.

qnorm(c(0.05, 0.25, 0.50, 0.75, 0.95), 0, 1, lower.tail = TRUE)

plot(x, pnorm(x, mean = 0, sd = 1), type = "l", col = "blue", ylab = "probability",
     xlab = "standard normal variable", main = "Standard Normal cdf Function")
abline(h = c(0.05, 0.25, 0.50, 0.75, 0.95), lty = 2, col = "green")
abline(v = c(-1.64, -0.67,  0.0,  0.67,  1.64), col = "red")

# Find a z-score value given a probability (or percentile) and plot.

p <- 0.75  # We already know the z-score is 0.6744898.
qnorm(p, 0, 1, lower.tail = TRUE)

cord.x <- c(-3, seq(-3, 0.67, 0.01), 0.67)
cord.y <- c(0, dnorm(seq(-3, 0.67, 0.01),0,1), 0)
curve(dnorm(x,0,1),xlim=c(-3,3),main="Standard Normal Density", ylab = "density")
polygon(cord.x,cord.y,col="skyblue")

# Black Demonstration Problem 6.3 done in R. Check Section 6.2, page 196.
# If a random variable has a N(4.43, 1.32^2) distribution, what is the probability
# a randomly selected observation will fall between 3.6 and 5.0?

pnorm(5.0, 4.43, 1.32) - pnorm(3.6, 4.43, 1.32)

z1 <- (5.0 - 4.43)/1.32
z2 <- (3.6 - 4.43)/1.32
pnorm(z1, 0, 1) - pnorm(z2, 0, 1)

#----------------------------------------------------------------------------
# Assessing normality--essential for data analysis
#----------------------------------------------------------------------------

require(moments)

# Set the seed for the random number generator.  Use this so results can be compared.
set.seed(123)

# Generate standard normal random variables using the function rnorm().
normal_x <- rnorm(10000, mean=0, sd=1)

# Check summary statistics.  Skewness is particularly important. Data which
# are skewed present estimation and inference problems.  For a random sample
# from a normal distribution, the values for skewness should be close to zero
# and the kurtosis values produced by R should close to 3.

summary(normal_x)
mean(normal_x)
sd(normal_x)

skewness(normal_x)
kurtosis(normal_x)

# Plot a histogram with density function overlay.
# First define the class intervals for the histogram.
cells <- seq(-4,4,0.5)
x <- seq(-3.75,3.75,0.5)

hist(normal_x, prob=TRUE, breaks = cells, ylim=c(0.0,0.5), col = "blue")
curve(dnorm(x,mean=0,sd=1),add=TRUE, col="orange",lwd=2)


# Demonstrate QQ Plot by comparing two standard normal variables.  A QQ plot
# is a scatterplot of two sets of data.  The values of the quantiles for the 
# two sets are plotted against each other.  If the distributions are the same,
# the resulting plot is a straight line.

# normal_x is one set of data.  Generate a second vector normal_w.
normal_w <- rnorm(10000, mean=0, sd=1)

# Select quantiles for plotting.
quant_x <- quantile(normal_x, probs = c(0.01,0.05,0.25,0.5,0.75,0.95,0.99),type=7)
quant_w <- quantile(normal_w, probs = c(0.01,0.05,0.25,0.5,0.75,0.95,0.99),type=7)

# Plot the quantile values versus each other.

plot(quant_x, quant_w, main = "Scatterplot of two normal random variables")
abline(0, 1, col = "red")

# This can be done for any set of data with supplied functions.
# The unknown distribution is plotted against the standard normal distribution.
# The closer to a straight line, the better the normal approximation.
# qqnorm() and qqline() provide the capability to make this comparison.

mag <- c(0.70, 0.74, 0.64, 0.39, 0.70, 2.20, 1.98, 0.64, 1.22, 0.20, 1.64, 1.02, 
         2.95, 0.90, 1.76, 1.00, 1.05, 0.10, 3.45, 1.56, 1.62, 1.83, 0.99, 1.56,
         0.40, 1.28, 0.83, 1.24, 0.54, 1.44, 0.92, 1.00, 0.79, 0.79, 1.54, 1.00,
         2.24, 2.50, 1.79, 1.25, 1.49, 0.84, 1.42, 1.00, 1.25, 1.42, 1.15, 0.93,
         0.40, 1.39)

cells <- seq(from = 0.0, to = 3.5, by = 0.5)
hist(mag, breaks = cells, col = "red", right = FALSE,
     main = "Histogram of Magnitude", xlab = "Magnitude")

require(moments)

skewness(mag)
kurtosis(mag)

qqnorm(mag, col = "red", pch = 16)
qqline(mag, col = "green", lty = 2, lwd = 2)

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Approximating binomial probabilities using the normal distribution.

# Let p = 0.5 and n = 50.  Plot binomial probabilities with the normal density.

p <- 0.5  # This is the binomial probability.
n <- 50

x <- seq(0,50,1)

plot(x,dbinom(x, n, p),  main = "Binomial Probabilities with Normal Density", 
  type = "h", col = "blue")
points(x,dbinom(x, n, p), pch = 16, cex = 1)
curve(dnorm(x,mean=n*p,sd=sqrt(n*p*(1-p))),add=TRUE, col="orange",lwd=2)
legend("topright", legend=c("binomial probabilities in blue", "normal density in orange",
                            "p = 0.5, n = 50"))


# Let p = 0.1 and n = 25.  Repeat the exercise.

p <- 0.1  # This is the binomial probability.
n <- 25   # This is the number of binomial trials.

x <- seq(0,25,1)

plot(x,dbinom(x, n, p),  main = "Binomial Probabilities with Normal Density", 
     type = "h", col = "blue")
points(x,dbinom(x, n, p), pch = 16, cex = 1)
curve(dnorm(x,mean=n*p,sd=sqrt(n*p*(1-p))),add=TRUE, col="orange",lwd=2)
legend("topright", legend=c("binomial probabilities in blue", "normal density in orange",
                            "p = 0.1, n = 25"))

# It is necessary to follow the rules np > 5 and n(1-p) > 5.  Then the normal
# approximation is adequate with the continuity correction.

dbinom(25, 50, 0.5)
pnorm(25+0.5, 25, sqrt(50*0.5*0.5), lower.tail = TRUE)-
  pnorm(25-0.5, 25, sqrt(50*0.5*0.5), lower.tail = TRUE)

pbinom(25, 50, 0.5, lower.tail = TRUE)
pnorm(25+0.5, 25, sqrt(50*0.5*0.5), lower.tail = TRUE)
pnorm(25, 25, sqrt(50*0.5*0.5), lower.tail = TRUE)

pbinom(2, 25, 0.1, lower.tail = TRUE)
pnorm(2+0.5, 2.5, sqrt(25*0.1*0.9), lower.tail = TRUE)

#-------------------------------------------------------------------------------
# Sampling Distributions for the Mean
#-------------------------------------------------------------------------------
# Suppose we draw all possible random samples of size n from a population, compute
# the mean value for each sample, and construct a histogram.  This histogram 
# would represent the sampling distribution for the mean derived from the population.

# Random sampling from a normal distribution (population) results in a sampling 
# distribution for the mean which is a normal distribution but with a variance
# that is smaller by a factor of 1/n, n being the sample size.

set.seed(123)
n <- 25  # Sample size

# Define a vector for storage purposes.
m <- numeric(0)  # Mean values stored here.
N <- 10000  # Number of iterations used in establishing the empirical sampling distribution.

for (i in 1:N)
{
  m[i] <- sum(rnorm(n, 0, 1))/n
}

# Plot a histogram with density function overlay.
# First define the class intervals for the histogram.
cells <- seq(-1,1,0.05)
x <- seq(-0.975,0.975,0.05)

hist(m, prob=TRUE, breaks = cells, col = "blue", ylim=c(0.0,2.0))
curve(dnorm(x,mean=0,sd=0.2),add=TRUE, col="orange",lwd=2)

sd(m)
skewness(m)
kurtosis(m)

qqnorm(m, col = "red")
qqline(m, col = "green", lwd = 2)

# Problem:  Suppose a production process produces widgets with a weight distributed
# as a normal variable with mean of 100 grams and standard deviation of 10 grams.
# What is the probability of a random sample of size 25 having a mean value that is 
# outside 100 +- 2 grams?

cord.x <- c(-3, seq(-3, -2*(5)/10, 0.01), -2*(5)/10)
cord.y <- c(0, dnorm(seq(-3, -2*(5)/10, 0.01),0,1), 0)
cord.xx <- c(2*(5)/10, seq(2*5/10, +3, 0.01), +3)
cord.yy <- c(0, dnorm(seq(2*5/10, +3, 0.01),0,1), 0)
curve(dnorm(x,0,1),xlim=c(-3,3),main="Standard Normal Density", ylab = "density")
polygon(cord.x,cord.y,col="skyblue")
polygon(cord.xx,cord.yy,col="skyblue")

pnorm(98, mean = 100, sd = 10/sqrt(25), lower.tail = TRUE)+ 
  pnorm(102, mean = 100, sd = 10/sqrt(25), lower.tail = FALSE)

2*pnorm(-1, 0, 1, lower.tail = TRUE)

# Knowing the sampling distribution provides a basis for making probablistic
# statements about sampling outcomes.

#-------------------------------------------------------------------------------
# Demonstration of the Central Limit Theorem

x <- seq(0,5,0.1)
plot(x,dexp(x,rate = 1), type = "l", col = "red", ylab = "density", main = 
       "Exponential Density Function Rate = 1", lwd = 2)

set.seed(123)
n <- 25  # Sample size

# Define a vector for storage purposes.
m <- numeric(0)  # Mean values stored here.
N <- 10000  # Number of iterations used in establishing the empirical sampling distribution.

for (i in 1:N)
{
  m[i] <- sum(rexp(n, rate = 1))/n
}


# Plot a histogram with density function overlay.
# First define the class intervals for the histogram.

cells <- seq(0,2,0.1)
x <- seq(.05,1.95,0.1)

hist(m, prob=TRUE, breaks = cells, col = "blue", ylim=c(0.0,3.0))
curve(dnorm(x,mean=1,sd=1/sqrt(n)),add=TRUE, col="orange",lwd=2)

sd(m)
skewness(m)
kurtosis(m)

qqnorm(m, col = "red")
qqline(m, col = "green")

#-------------------------------------------------------------------------------
# Sampling distribution for binomial proportion.

# Example problem Section 7.3 Black.
# Let p = 0.6 and n = 120.  Determine the sampling distribution for the 
# binomial z-score:  (phat - p)/sqrt(p(1-p)/n)

p <- 0.6  # This is the binomial probability.
n <- 120   # This is the number of binomial trials.

x <- seq(0,120,1)
set.seed(123)

# Define a vector for storage purposes.
m <- numeric(0)  # Mean values stored here.
N <- 10000  # Number of iterations used in establishing the empirical sampling distribution.

for (i in 1:N)
{
phat <- (rbinom(1, size = n, prob = p))/n
m[i] <- (phat - p)/sqrt(p*(1-p)/n)
}

# Plot a histogram with density function overlay.
# First define the class intervals for the histogram.
cells <- seq(-4.75,4.75,0.5)
x <- seq(-4.5,4.5,1.0)

hist(m, prob=TRUE, breaks = cells , col = "blue", ylim=c(0.0,0.5))
curve(dnorm(x, mean=0, sd=1), add=TRUE, col="orange",lwd=2)

sd(m)
skewness(m)
kurtosis(m)

qqnorm(m, col = "red")
qqline(m, col = "green", lwd = 2)

# Example problem Section 7.3 Black.  If the probability is 0.6 of success, with
# a sample of 120 what is the probability that 60 or fewer successes occur?  
# Using pbinom() an exact calculation can be made. 

pbinom(60, 120, 0.6, lower.tail = TRUE)

# The calculation in Black resulted in 0.0125.
# This illustrates what happens when a continuous probability distribution is 
# used to approximate a discrete probability distribution. As the sample size 
# enlarges,the approximation becomes better. 