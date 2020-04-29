# Predict 401 Demonstration of Calculations using R for Week 5 

#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# The main objective of this program is to demonstrate the capabilities of R.
# Examples of calculations dealing with statistical inference and estimation for
# single populations will be given.  Refer to Chapter 8 of Business Statistics.


# Problem 8.5 Section 8.1 page 268:  A random sample of size 39 is taken from a 
# population of 200 members.  The sample mean is 66 and the population standard 
# deviation is 11.  Construct a 96% confidence interval to estimate the population
# mean.  What is the point estimate of the population mean?  

# The point estimate of the population mean is the sample mean or 66.
# 5% of 200 is 10 which is less than 39.  The finite correction factor is needed.
# R does not have z-test function.  One must be constructed.

finite <- sqrt((200 - 39)/(199))
finite

std <- 11 *finite/sqrt(39)
std

# For a 96% confidence interval we need quantiles from the standard normal
# distribution corresponding to percentiles at 2% and 98%.

z.values <- qnorm(c(0.02, 0.98), mean = 0, sd = 1, lower.tail = TRUE)
z.values

# Note that this can be worked in reverse.
pnorm(z.values,mean = 0, sd = 1, lower.tail = TRUE)

# The answers are given with two digits beyond the decimal point.  This can be
# accomplished using the signif() function giving the resulting confidence interval.

c(signif(66+z.values[1]*std, digits=4), signif(66+z.values[2]*std, digits=4))

# If the population were 2000 instead of 200 the finite correction factor would
# not be needed.  The procedure in R would be be as follows using the same z.values.

std <- 11/sqrt(39)
c(signif(66+z.values[1]*std, digits=4), signif(66+z.values[2]*std, digits=4))

# Note that the confidence interval is wider without the finite correction factor.
#-------------------------------------------------------------------------------

# Problem 8.17 Section 8.2 page 275: Use the data below to construct a confidence 
# for the population mean.  Assume the population is normally distributed.

data.set <- c(16.4,17.1,17.0,15.6,16.2,14.8,16.0,15.6,17.3,17.4,15.6,15.7,17.2,
              16.6,16.0,15.3,15.4,16.0,15.8,17.2,14.6,15.5,14.9,16.7,16.3)

mean(data.set)   # This is the point estimate of the population mean.

# Since the entire data set is available, t.test() can be used.

t.test(data.set, alternative = c("two.sided"), mu = 0, conf.level = 0.99)

# Since we are not given the true population mean, we set mu = 0.  These results
# can be obtained using R as a calculator.

# Quantiles must be determined from the t-distribution.

t.values <- qt(c(0.005, 0.995), 24, lower.tail = TRUE)
std <- sd(data.set)/sqrt(25)
mu <- mean(data.set)
c(signif(mu+t.values[1]*std, digits=5), signif(mu+t.values[2]*std, digits=5))

# These results match the answers in Business Statistics.
#-------------------------------------------------------------------------------

# Demonstration Problem 8.4 Section 8.3 page 279 Business Statistics.  Construct
# a 92% confidence interval to estimate the proportion of all fast-growing small
# companies that have a management succession plan, given that only 51% of a 
# sample of 210 chief executives do so.

# The point estimate is 0.51.  With a sample of size 210 the normal approximation
# may be used.  The quantiles for a 92% confidence interval must be determined.

z.values <- qnorm(c(0.04, 0.96), mean = 0, sd = 1, lower.tail = TRUE)
z.values

std <- sqrt(0.51*0.49/210)
std

c(signif(0.51+z.values[1]*std, digits=2), signif(0.51+z.values[2]*std, digits=2))

# These results match what is given in Business Statistics.  Another method is to
# use the one sample prop.test().  No correction is needed given the sample size.

prop.test(107, 210, alternative = c("two.sided"), conf.level = 0.92, correct = FALSE)
#-------------------------------------------------------------------------------

# Demonstration Problem 8.6 Section 8.4 page 284.  The average hourly wage for a 
# production worker is $19.58.  A sample of 25 workers results in a sample standard
# deviation of $1.12.  Construct a 95% confidence interval for the population 
# variance, and then a confidence interval for the population standard deviation.

# This calculation requires quantiles from the Chi-square distribution.

chi.values <- qchisq(c(0.025, 0.975), 24, lower.tail = TRUE)
chi.values

# For the first confidence interval we need the sample variance.

sigma <- 1.12^2

# Now the interval can be constructed.  Note how the chi.values are entered.

c(signif(24*sigma/chi.values[2], digits = 4),
         signif(24*sigma/chi.values[1], digits = 5))

# This matches the answer given in Business Statistics.  To convert to standard
# deviations, take the sqrt.

result <- c(sqrt(signif(24*sigma/chi.values[2], digits = 4)),
  sqrt(signif(24*sigma/chi.values[1], digits = 5)))
result

# Square result to compare values.

result*result
#-------------------------------------------------------------------------------

# Demonstration Problem 8.9 Section 8.5 page 288 Business Statistics.  A 
# researcher wants to be within 0.05 of the actual proportion in a population with
# 99% confidence.  With no prior information to go on, what sample size should 
# be used?  This is a straightforward use of R as a calculator.

result <- ((qnorm(0.995, mean = 0, sd = 1, lower.tail = TRUE))^2)*0.5*0.5/0.05^2
signif(result, digits = 4)


# The answer differs slightly since R uses more digits in the calculation.

#-------------------------------------------------------------------------------

# Central Limit Theorem

# Bonus code showing the convergence of the binomial distribution to the normal
# distribution.  This code can be used to illustrate the importance of using
# the two rules np > 5 and n(1-p) > 5.  These rules work best if 0.25 < p < 0.75.
# This program is written so that the user can change p, N and n.  Depending on
# these choices, particularly with values of p close to zero or one, some rather
# odd shaped histograms result.  This indicates n needs to be increased.



# Draw a random sample of size n from the binomial distribution.
n <- 50 
p <- 0.1   # This is the binomial probability.
N <- 10000  # number of samples to draw

proportions <- numeric(0)
set.seed(123)

proportions <- rbinom(N,n,p)/n  # This produces the binomial variables.

number.cells <- nclass.Sturges(proportions)
delta <- max(proportions)/number.cells

cells <- seq(0.0, max(proportions), delta)
center <- seq(delta/2, max(proportions), delta)
std <- sqrt(p*(1-p)/n)


# Determine the normal distribution with the same mean and variance.
# Superimpose on the binomial histogram.  Adjust the y-axis limit to accomodate 
# different choices of N, p and n.

x <- center
limit <- max(N*(pnorm(x+delta/2,mean=p,sd=std)-pnorm(x-delta/2,mean=p,sd=std)))

hist(proportions, breaks=cells,freq = TRUE, col = "blue", ylim = c(0, limit),
     xlab="sample proportion", main="Histogram of Binomial Proportions with Normal Density")

curve(N*(pnorm(x+delta/2,mean=p,sd=std)-pnorm(x-delta/2,mean=p,sd=std)),
      add=TRUE, col="orange",lwd=2)
abline(v=p+std*qnorm(0.95,mean=0,sd=1,lower.tail=TRUE),col="red",lwd=2)
abline(v=p,col="orange",lwd=2,lty=2)

# Determine the portion of the sample falling beyond the 95% quantile.  A good
# approximation should be close to 5%.  For practical use in hypothesis testing,
# it should be between 2.5% and 7.5%.

sum(proportions > p+std*qnorm(0.95,mean=0,sd=1,lower.tail=TRUE))/N

#-------------------------------------------------------------------------------

