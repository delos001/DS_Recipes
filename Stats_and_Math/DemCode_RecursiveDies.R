# Based on the paper "The Probability Distribution of the Sum of Several Dice:
# Slot Applications" by Ashok K. Singh\ Rohan J. Dalpatadu\ Anthony F. Lucas
# http://digitalscholarship.unlv.edu/cgi/viewcontent.cgi?article=1025&context=grrj

#===============================================================================
# Recursive function for determining probability distribution.
# Based on rolling a die. # Computes probability of sum of rolls.

dies <- function(j, m){
  
  # dies() returns the probability of m given j.
  # j is number of rolls and m is the sum.
  
  if (j <= 1 & m <= 6){
    sum = 1/6
  }
  else if (m < j | m > 6*j){
    sum <- 0
  }
  else {
    sum <- 0
    limit <- min(m-1, 6)
    for (k in 1:limit){
      sum <- sum + dies(j-1, m-k)/6}
  }
  return(sum)
}

#===============================================================================
# This next portion calculates the distribution of outcome frequencies for N rolls.
# Impossible outcomes are scored as zero frequency.  Keep N fixed for next series.
# Note that the minimum sum for N rolls is N and the maximum sum is 6*N.

prob <- numeric(0)
N <- 5
i <- 1
for (k in seq(from = N,to = N*6, by = 1))
{
  prob[i] <- dies(N,k)
  i <- i + 1
}

# To determine the number of different combinations that can produce a particular
# sum, we must multiple the probability of a particular sum by the total number of
# possible sequences in the sample space which is 6^N.  For example, with five rolls
# there is one sequence that produces a sum of 5 and one that produces a sum of
# 30.  However, there are 780 sequences that produce a sum of 17 and another 780
# sequences that produce a sum of 18.

prob*6^N

#===============================================================================
# This shows the probability distribution as a function of number of rolls.

x <- seq(from = N, to = N*6, by = 1)
toss <- factor(x)
barplot(prob, col="red", main = "Bar Plot of Distribution",
        names.arg = toss, xlab = "Tosses", ylab = "Frequency")

# This calculates then plots the cummulative distribution function.

cdf.prob <- cumsum(prob)
plot(x, cdf.prob, xlab = "Sum of Dice with N Tosses",
     main = "Cummulative Distribution Function", col = "red", type = "b")
# This gives the probability of a sum of 20 or more.

1 - cdf.prob[20-N]
#===============================================================================

# Due to longer computation times with more dies, the normal approximation may
# be used to estimate tail probabilities.  The following investigates this possibility.

# The expected value of a sum is 3.5*N.  The variance is 5/6*(3.5*N).  These results
# are determined from the moment generating function shown in the cited paper.

# The following uses the normal approximation to estimate the cdf.  Note the use
# of the continuity correction +0.5.

# First we demonstrate the formulas for the mean and standard deviation are right.
3.5*N
sqrt((5/6)*3.5*N)

m.sum <- sum(x*prob)
std <- sqrt(sum(x*x*prob) - (sum(x*prob))^2)
m.sum
std

#===============================================================================
z <- (x + 0.5 - m.sum)/std
n.prob <- pnorm(z,0,1,lower.tail = TRUE)

# This plots the exact cdf along with the estimated cdf.

plot(x, cdf.prob, xlab = "Sum of Dice with N Tosses",
     main = "Cummulative Distribution Function", col = "red", type = "b")
lines(x, n.prob)
legend("bottomright", legend = c("red is exact calculation", "black is normal estimate",
                                 "continuity correction used"))

# Error calculation

error <- data.frame(x, cdf.prob, n.prob, cdf.prob-n.prob)
error

# This next step calculates the probability of a sum of 20 or higher given N.

limit <- 20-N
prob[1:limit]*6^N
(1-sum(prob[1:limit]))  # Exact calculation.

pnorm((19.5 - m.sum)/std, 0, 1, lower.tail = FALSE) # Normal approximation.

#===============================================================================
# Sometimes for problems of this nature it is easier to do a simulation.

set.seed(123)
results <- numeric(0)
iter <- 100000
N <- 5
for (k in 1:iter){
  results[k] <- sum(sample.int(6,size=N,replace=TRUE))
}
hist(results, freq = FALSE)

# This gives the probability of a sum of 20 or more given N.
sum(results >= 20)/iter

#===============================================================================

# With N larger than 8, recursive computational time takes much longer.
# The normal approximation using a continuity correction corresponds
# to the exact probabilities closely for higher sums.  This will allow simulations
# for large numbers of tosses when computational time is an issue.  Here is a plot
# with N = 10 using the normal approximation.

N <- 10
x <- seq(from = N, to = 6*N, by = 1)
m.sum <- 3.5*N
std <- sqrt(m.sum*5/6)
z <- (x + 0.5 - m.sum)/std
n.prob <- pnorm(z,0,1,lower.tail = TRUE)
plot(x,n.prob, type = "b", col = "blue")

pnorm((19.5 - m.sum)/std, 0, 1, lower.tail = FALSE) # Normal approximation.

#===============================================================================

# Here is a simulation.

set.seed(123)
results <- numeric(0)
iter <- 100000
N <- 5
for (k in 1:iter){
  results[k] <- sum(sample.int(6,size=N,replace=TRUE))
}
hist(results, freq = FALSE)

# This gives the probability of a sum of 20 or more given N.
sum(results >= 20)/iter

#===============================================================================