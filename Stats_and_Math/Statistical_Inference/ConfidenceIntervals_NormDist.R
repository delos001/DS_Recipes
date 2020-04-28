
#----------------------------------------------------------
#----------------------------------------------------------
# GENERAL EXAMPLE
# normal distribution
a <- 5
s <- 2
n <- 20
error <- qnorm(0.975)*s/sqrt(n)
left <- a-error
right <- a+error
left  # OUT: 4.123477
right # OUT: 5.876523





#----------------------------------------------------------
#----------------------------------------------------------
# Confidence interval using finite correction for 
#   sample less than 39
# Problem 8.5 Section 8.1 page 268:  
#   A random sample of size 39 is taken from a population of 200 members.  
#   The sample mean is 66 and the population standard deviation is 11.  
#   Construct a 96% confidence interval to estimate the population mean.  

# point estimate of pop mean is the sample mean 66
# 5% of 200 is 10 which is less than 39.  The finite correction factor is needed.  
# R does not have z-test function.  One must be constructed.
finite <- sqrt((200 - 39)/(199))
finite

std <- 11 *finite/sqrt(39)

# For a 96% confidence interval we need quantiles from the standard 
#   normal # distribution corresponding to percentiles at 2% and 98%.
z.values <- qnorm(c(0.02, 0.98), 
                  mean = 0, 
                  sd = 1, 
                  lower.tail = TRUE)
pnorm(z.values,
      mean = 0, 
      sd = 1, 
      lower.tail = TRUE)

c(signif(66 + z.values[1]*std, digits=4), 
  signif(66 + z.values[2]*std, digits=4))


# If the population were 2000 instead of 200 the finite correction factor 
#   would not be needed.  The procedure in R would be be as follows using 
#   the same z.values.
# The signif function control the number of digits in the response (like round)
std <- 11/sqrt(39)
c(signif(66 + z.values[1]*std, digits=4), 
  signif(66 + z.values[2]*std, digits=4))
