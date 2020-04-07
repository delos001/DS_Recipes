# Predict 401 Demonstration of Calculations using R for Week 6 

#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# The main objective of this program is to demonstrate the capabilities of R.
# Examples of calculations dealing with statistical inference as it relates to 
# hypothesis testing for single populations will be given.  Refer to Chapter 9
# of Business Statistics.  Regarding R, library functions do not exist for certain
# statistical tests.  Library functions are used in what follows if available.


# Demonstration Problem 9.1 Section 9.2 page 315:  The average out-of-pocket
# expenditure for a dental tooth filling is believed to be $141 if insured. 
# It is believed the actual average expenditure is greater than $141.  To test 
# this assertion, a random sample of size 32 and the resulting out-of-pocket
# expenditures is recorded.  The population standard deviation is $30.  At the 
# 5% alpha level, test the assertion assuming the population is normally distributed.

cost.data <- c(147,152,119,142,163,151,123,118,145,166,149,130,158,175,142,160,
               175,125,147,210,132,156,139,122,163,175,120,135,207,141,170,110)

# The null hypothesis is that the population mean is $141.  The alternative is 
# one-sided "greater than" the $141.  The belief is that the cost has increased.  

# To test, first calculate the z-score.

z <- (mean(cost.data)-141)/(30/sqrt(32))
z

# Next, use alpha = 0.05 in qnorm() to obtain the critical value for comparison.
# Since this is a one-sided test, only one critical value is used.

critical.value <- qnorm(0.95, mean = 0, sd = 1, lower.tail = TRUE)
critical.value 

# The z score is less than the critical value. The null hypothesis can not be
# rejected at the 5% level.  This same conclusion can be reached using a p-value.

pnorm(z, mean = 0, sd = 1, lower.tail = FALSE)

# Since the p-value exceeds 5%, the null hypothesis can not be rejected.
# Using the critical value, it is possible to solve for the sample mean which
# would result in rejection.

critical.value*(30/sqrt(32))+141

# Continue the example assuming the population standard deviation is not
# known.  This requires use of the t-test.  The degrees of freedom for the test
# are 31.  However, the standard deviation is divided by the sample size.

t <- (mean(cost.data)-141)/(sd(cost.data)/(sqrt(32)))
t

critical.value <- qt(0.95, 31, lower.tail = TRUE)
critical.value

# The critical value is less than the t-value so the null hypothesis can be
# rejected.  The difference in result is a consequence of a smaller sample variance.
# A p-value may be calculated as well.  It is smaller than 5%.

pt(t, 31, lower.tail = FALSE)

# Since the entire data set is available, t.test() can be used.

t.test(cost.data, alternative = c("greater"), mu = 141, conf.level = 0.95)

# This confirms the preceding calculations.

#-------------------------------------------------------------------------------

# Example of hypothesis testing with proportions: a person is presented with 400
# true/false questions and answers correctly 215 times.  If the person is guessing 
# at random, we would expect 50% success.  The person says he did not guess at 
# random and should have done better than chance alone.  Test this assertion 
# with alpha = 0.05.

z <- (215/400 - 0.5)/sqrt(0.5*0.5/400)
z

# With n = 400 and p = 0.5, np = 200 > 5 so we use the normal approximation.

critical.value <- qnorm(0.95, mean = 0, sd = 1, lower.tail = TRUE)
critical.value

# A p value may be determined.

pnorm(z, mean = 0, sd = 1, lower.tail = FALSE)

# Since the z value is less than the critical value, the null hypothesis of
# random quessing can not be rejected.  This can be confirmed using prop.test().

prop.test(215, 400, alternative = c("greater"), conf.level = 0.95, correct = FALSE)

# With smaller sample sizes it is advantageous to use binom.test().  This test
# is based on exact binomial probabilities without using the normal approximation.

binom.test(215, 400, p = 0.5, alternative = c("greater"), conf.level = 0.95)

# In this case the conclusions are the same.
#-------------------------------------------------------------------------------

# The data for Demonstration Problem 9.1 Section 9.2 page 315 produced different
# results depending on whether the z test or the t test were used.  In
# this example we will compare the population variance to the sample variance.  
# The population standard deviation is $30.  The sample standard deviation is 
# 23.98586 with 31 degrees of freedom.  We follow the steps shown in Demonstration
# Problem 9.4 Section 9.5 page 335 of Business Statistics.

chi <- (31*var(cost.data)/30^2)  # This is the test statistic.
chi

# To find the critical values for a one-sided test, we use qchisq().

q.values <- qchisq(0.05, 31, lower.tail = TRUE)
q.values

# The value for the test statistic is above the critical value.
# The null hypothesis of equality can not be rejected.  

pchisq(chi, 31, lower.tail = TRUE)

#-------------------------------------------------------------------------------

# Calculating Type II Error Rates

# Refer to Section 9.6 and the subsequent Demonstration Problems.  Consider the
# following problem.  Are containers underfilled?  The nominal filling level is 
# an average of 12 oz.  An unacceptable filling level is a average of 11.96 oz.
# This defines the null and alternative hypotheses.  The standard deviation for
# filling is 0.1 oz.  With a random sample of 60, what is the probability of not
# rejecting the null hypothesis when the filling level is 11.96 given alpha = 0.05?
# Assume a normal distribution.  The use of functions will be shown.

# Calculating the Type II error rate for this problem involves three steps.
# 1) Determine the critical value that would prompt rejection of the null hypothesis.
# 2) Assume the alternative hypothesis is true, and calculate a z value using 
# the critical value obtained from 1). 
# 3) Assuming the alternative hypothesis is true, use the z value from 2) to find
# the probability of not rejecting the null hypothesis.

# Power is defined as 1.0 minus the Type II error rate.  Power will vary 
# as a function of sample size and the Type I error rate.

# First calculate the critical fill level that would be used to compare against
# a sample mean fill value.  For this purpose define a function to be used later.

n <- 60
alpha <- 0.01
sigma <- 0.1
nominal <- 12.0

# Find the critical z value that would result in rejecting the null hypothesis.

critical.z <- qnorm(alpha,0,1)  # Refer to Figure 9.22 and following.
critical.z   # Note that we are working in the left tail of the normal distribution.

# Express the critical z value in terms of a critical fill volume.

value <- nominal + critical.z*(sigma/sqrt(n))  

# Reject the null hypothesis if the sample mean is less than this value.

# Now assume the alternate hypothesis is true and the average fill level is 11.96. 
# What is the probability of obtaining a sample average which is above the critical
# fill value which would not result in rejecting the null hypothesis?  

alternative <- 11.96
zvalue <- (value-alternative)*(sqrt(n)/sigma)
zvalue

# If the sample generates a mean fill volume greater than zvalue, the null
# hypothesis will not be rejected.  For this problem, this corresponds to finding
# the tail area to the right of the z value determined above.  

pnorm(zvalue, 0, 1, lower.tail = FALSE)  # Type II error rate

cord.x <- c(zvalue, seq(zvalue, +3.0, 0.01), 3.0)
cord.y <- c(0, dnorm(seq(zvalue, +3.0, 0.01),0,1), 0)
curve(dnorm(x,0,1),xlim=c(-3,3),main="Standard Normal Density", ylab = "density",
      col = "orange", lwd = 2)
polygon(cord.x,cord.y,col="red")
abline(v = zvalue, col="green", lty = 3, lwd = 3)
abline(v = 0)

# The probability of having a sample mean greater than value(60) is 7.3%. There are 
# slight differences from the text due to rounding during the calculation.

# The power of a statistical test is 1 minus the Type II error rate.  Reducing the
# size of the Type I error rate makes it more difficult to reject the null 
# hypothesis thus reducing the power.
