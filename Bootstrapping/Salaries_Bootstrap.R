# Demonstration R Code for PREDICT 401 Sync Session #4
# salaries.csv data are salary differences between two comparable positions. 

require(moments)  # This package brings in skewness() and kurtosis().
require(asbio)  # This package does a Wilcox winsorization and returns the revised vector.

salaries <- read.csv(file.path("c:/Rdata/","salaries.csv"),sep=" ")
str(salaries)

diff <- salaries[,1]  # Define the vector for analysis.
summary(diff)

hist(diff, col = "orange", main = "Histogram of Salary Differences", xlab = "Difference")
skewness(diff)
kurtosis(diff)

par(mfrow = c(1,2))
qqnorm(diff, col = "orange", pch = 16, main = "Differences Q-Q Plot")
qqline(diff, col = "blue")
boxplot(diff, col = "orange", main = "Differences Boxplot")
par(mfrow = c(1,1))

#--------------------------------------------------------------------------------------------
# What follows is bootstrap resampling from the simple random sample.

N <- 10^4  # This is the number of resamples drawn.

# Define vectors for storage purposes.
my.t.mean <-numeric(N)
my.mean <- numeric(N)
my.t <- numeric(N)
my.boot <- numeric(N)

# mean values for later calculations
mu <- mean(diff)
tmu <- mean(diff, trim = 0.2)

# needed for computing standard deviations
n <- length(diff)
h <- 0.6*sqrt(n)

for (i in 1:N)
{
  x <- sample(diff, n, replace = TRUE)
  my.mean[i] <- mean(x)
  my.boot[i] <- (mean(x)-mu)/(sd(x)/sqrt(n))    # untrimmed mean t value
  my.t.mean[i] <- mean(x, trim = 0.2)
  std <- sd(win(x))
  my.t[i] <- (mean(x, trim = 0.2)-tmu)/(std/h)  # trimmed mean t value
 }

# Comparison of trimmed and untrimmed variability.

par( mfrow = c(2,2))
cells <- seq(from = 3.0,to = 5.5, by = 0.1)
hist(my.mean, breaks = cells, main = "Bootstrap distribution of untrimmed mean values", col = "blue")
abline(v= quantile(my.mean, probs = 0.025),col = "green", lty = 2, lwd = 2)
abline(v= quantile(my.mean, probs = 0.975),col = "green", lty = 2, lwd = 2)

cells <- seq(from = -6.0, to = 6, by = 0.5)
hist(my.boot, breaks = cells, main = "Bootstrap distribution of untrimmed t_statistic", col = "blue")
abline(v = quantile(my.boot, probs = 0.025), col = "green", lty = 2, lwd = 2)  
abline(v = quantile(my.boot, probs = 0.975), col = "green", lty = 2, lwd = 2)

cells <- seq(from = 3.0,to = 5.5, by = 0.1)
hist(my.t.mean, breaks = cells, main = "Bootstrap distribution of trimmed mean values", col = "red")
abline(v= quantile(my.t.mean, probs = 0.025),col = "green", lty = 2, lwd = 2)
abline(v= quantile(my.t.mean, probs = 0.975),col = "green", lty = 2, lwd = 2)

cells <- seq(from = -6.0, to = 6, by = 0.5)
hist(my.t, breaks = cells, main = "Bootstrap distribution of trimmed t_statistic", col = "red")
abline(v = quantile(my.t, probs = 0.025), col = "green", lty = 2, lwd = 2)  
abline(v = quantile(my.t, probs = 0.975), col = "green", lty = 2, lwd = 2)
par( mfrow = c(1,1))

#----------------------------------------------------------------------
# Percentile bootstrapping on trimmed mean confidence interval.
round(quantile(my.t.mean, prob = c(0.025,0.975)), digits = 3)
#----------------------------------------------------------------------
# Determine a two-sided confidence interval using trimmed bootstrap t distribution.
Q1 <- quantile(my.t, prob = c(0.025), names = FALSE)
Q2 <- quantile(my.t, prob = c(0.975), names = FALSE)
round(tmu - Q2*(std/h), digits = 3)
round(tmu - Q1*(std/h), digits = 3)
std/h
#-----------------------------------------------------------------------
# Theoretical trimmed mean confidence interval.
n <- length(diff)
h <- 0.6*sqrt(n)
df <- n-2*4-1
c <- qt(0.975, df, lower.tail = TRUE)
std <- sd(win(diff, lambda = 0.2))
E <- c*std/h
round(mean(diff, trim = 0.2)-E, digits = 3)
round(mean(diff, trim = 0.2)+E, digits = 3)

#----------------------------------------------------------------------
# Evaluate performance of percentile bootstrap on untrimmed means.
round(quantile(my.mean, prob = c(0.025,0.975)), digits = 3)

#----------------------------------------------------------------------
# Evaluate performance of bootstrap t on untrimmed data.
Q1 <- quantile(my.boot, prob = c(0.025), names = FALSE)
Q2 <- quantile(my.boot, prob = c(0.975), names = FALSE)
round(mu - Q2*(sd(diff)/sqrt(n)), digits = 3)
round(mu - Q1*(sd(diff)/sqrt(n)), digits = 3)
sd(diff)/sqrt(n)
#-----------------------------------------------------------------------
# Evaluate traditional t-test performance
t.test(diff)
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------

# The distributions are comparable.  The difference in the confidence intervals which result
# is a result of the difference in the variability of the mean versus the untrimmed mean.
((sd(diff)/sqrt(n))/(std/h))^2  # Approximate amount the sample size would need to increase.

sigma <- (std/h)*sqrt(50)

salaries <- read.csv(file.path("c:/Rdata/","salaries.csv"),sep=" ")
str(salaries)

diff <- salaries[,1]  # Define the vector for analysis.
summary(diff)

tmu
x <- seq(-1,10,by = 0.1)
hist(diff, col = "orange", main = "Histogram of Salary Differences", xlab = "Difference", 
     prob = T, ylim = c(0,0.4))
curve(dnorm(x,tmu,sigma), add = T, col = "blue", lwd = 2)
legend("topright", legend= c("trimmed mean = 4.26", "standard deviation = 1.010"))