# Predict 401 Demonstration of Calculations using R for Week 7 

#----------------------------------------------------------------------------
#----------------------------------------------------------------------------

# stats is an example of a user-defined function.

stats <- function(x) {
  cat("\n   sample:", length(x), "observations")
  cat("\n     mean:", mean(x, na.rm = TRUE))
  cat("\n       sd:", sd(x, na.rm = TRUE))
  cat("\n variance:", var(x, na.rm = TRUE),"\n")
}

# Demonstration using data from Table 10.1 of Business Statistics.  This problem
# involves comparing wages of advertising and auditing managers.  Note how
# stats is used to generate the same results as in Table 10.1.

advertising <- c(74.256, 96.234, 89.807, 93.261, 103.030, 74.195, 75.932, 80.742,
                 39.672, 45.652, 93.083, 63.384, 57.791, 65.145, 96.767, 77.242, 
                 67.056, 64.276, 74.194, 65.360, 73.904, 54.270, 59.045, 68.508,
                 71.115, 67.574, 59.621, 62.483, 69.319, 35.394, 86.741, 57.351)

stats(advertising)

auditing <- c(69.962, 55.052, 57.828, 63.362, 37.194, 99.198, 61.254, 73.065, 48.036, 
              60.053, 66.359, 61.261, 77.136, 66.035, 54.335, 42.494, 83.849, 67.160,
              37.386, 59.505, 72.790, 71.351, 58.653, 63.508, 43.649, 63.369, 59.676,
              54.449, 46.394, 71.804, 72.401, 56.470, 67.814, 71.492)

stats(auditing)

# The null hypothesis is that the true mean wages for advertising managers and
# auditing managers are equal.  The alternative is that they are not equal.  This
# is a two-tailed hypothesis test.  We do not know which salary level is greater
# or lesser.  We will assume normal distributions and use a Type I error rate of 5%.
# Since this is a two-tailed test, the error rate must be split for the z-test.

z.lower <- qnorm(0.025, mean=0, sd = 1, lower.tail = TRUE)
z.upper <- qnorm(0.975, mean=0, sd = 1, lower.tail = TRUE)

cord.x <- c(-3, seq(-3, z.lower, 0.01), z.lower)
cord.y <- c(0, dnorm(seq(-3, z.lower, 0.01),0,1), 0)
cord.xx <- c(z.upper, seq(z.upper, +3, 0.01), +3)
cord.yy <- c(0, dnorm(seq(z.upper, +3, 0.01),0,1), 0)
curve(dnorm(x,0,1),xlim=c(-3,3),main="Standard Normal Density", ylab = "density")
polygon(cord.x,cord.y,col="skyblue")
polygon(cord.xx,cord.yy,col="skyblue")

delta <- mean(advertising) - mean(auditing)
delta

two.tailed.z.value <- function(x, y){
  delta <- mean(x)-mean(y)
  std <- sqrt((var(x)/length(x))+(var(y)/length(y)))
  z.value <- delta/std   # See Section 10.1 of Business Statistics.
  z.value
  }

result <- two.tailed.z.value(advertising, auditing)
result 

cord.x <- c(-3, seq(-3, z.lower, 0.01), z.lower)
cord.y <- c(0, dnorm(seq(-3, z.lower, 0.01),0,1), 0)
cord.xx <- c(z.upper, seq(z.upper, +3, 0.01), +3)
cord.yy <- c(0, dnorm(seq(z.upper, +3, 0.01),0,1), 0)
curve(dnorm(x,0,1),xlim=c(-3,3),main="Standard Normal Density", ylab = "density")
polygon(cord.x,cord.y,col="skyblue")
polygon(cord.xx,cord.yy,col="skyblue")
abline(v = result, col = "red")

# A p-value for a two-tailed test must take into account both tails.  This is
# different from a one-tailed test.  Since we did not know prior to the statistical
# test which tail the result would fall into, we must multiply by two as below.

2.0*pnorm(result, mean = 0, sd = 1, lower.tail = FALSE )  #Two-sided p-value.

# Confidence interval construction uses the sample standard deviation for the 
# difference.  This is shown in Section 10.1 page 363 of Business Statistics.

std <- sqrt((var(advertising)/length(advertising))+(var(auditing)/length(auditing)))
interval <- c(delta + z.lower*std, delta + z.upper*std)
interval

# Note that this interval does not include the origin which agrees with the
# z-test and the p-value.

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Using the data for advertising and auditing, a t-test will be shown, and the 
# variances will also be compared.  In the former, the same hypotheses will be
# tested.  The hypotheses for the variances will be equality versus inequality.

help(t.test)

t.test(advertising, auditing, alternative = c("two.sided"), mu = 0, paired = FALSE,
       var.equal = TRUE, conf.level = 0.95)


help(var.test)

results <- var.test(advertising, auditing, ratio = 1, alternative = c("two.sided"),
                    conf.level = 0.95)
results

f.lower <- qf(0.025, 31, 33, lower.tail = TRUE)
f.upper <- qf(0.975, 31, 33, lower.tail = TRUE)
cord.x <- c(f.upper, seq(f.upper, 4, 0.01), 4)
cord.y <- c(0, df(seq(f.upper, 4, 0.01), 31, 33), 0)
cord.xx <- c(0, seq(0, f.lower, 0.01), f.lower)
cord.yy <- c(0, df(seq(0, f.lower, 0.01), 31, 33), 0)
curve(df(x,31,33),xlim=c(0,3),main=" F Density", ylab = "density")
polygon(cord.x,cord.y,col="skyblue")
polygon(cord.xx,cord.yy,col="skyblue")
abline(v = results$statistic, col = "red")
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Data from Table 10.5 will be used to demonstrate statistical inference for
# two related populations.  This example involves comparing P/E ratios from
# two years for nine different companies.

company <- c(1,2,3,4,5,6,7,8,9)
year1 <- c(8.9,38.1,43.0,34.0,34.5,15.2,20.3,19.9,61.9)
year2 <- c(12.7,45.4,10.0,27.2,22.8,24.1,32.3,40.1,106.5)

ratios <- data.frame(company, year1, year2)
ratios

plot(year1, year2, main= "Plot of P/E Ratios for Nine Companies", xlab = "Year One",
     ylab = "Year Two", col = "red")
abline(a = 0, b = 1, col = "green", lty = 2)

d <- year1 - year2

# If there is a positive correlation between two variables, the variance of their 
# difference is less than the sum of the separate variances for the two variables.

var(d)
var(year1)+var(year2)

ratios <- data.frame(ratios, d)
ratios

t.test(d, alternative = c("two.sided"), mu = 0, paired = FALSE, var.equal = FALSE,
       conf.level = 0.95)

t.test(year1, year2, alternative = c("two.sided"), mu = 0, paired = TRUE, 
       var.equal = TRUE, conf.level = 0.95)

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Demonstration using data from Section 10.4 Business Statistics.  This is from
# the section dealing with confidence intervals.  Results will be compared to 
# Table 10.13 which used Minitab for the shopping example.

help(prop.test)

morning <- c(48, 400)
after <- c(187, 480)

morning[2] <- morning[2]-morning[1]
after[2] <- after[2]-after[1]

c.matrix <- data.matrix(rbind(morning,after))
c.matrix

prop.test(c.matrix,alternative = c("two.sided"), conf.level = 0.98, correct = FALSE)

# An exact test is available.  It will test the same hypotheses, however the
# confidence interval is for the odds ratio, not the difference in proportions.

fisher.test(c.matrix, alternative = "two.sided", conf.level = 0.98)
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
