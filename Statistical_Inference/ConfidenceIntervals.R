

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
# GENERAL EXAMPLE
# t-distribution
a <- 5
s <- 2
n <- 20
error <- qt(0.975,df=n-1)*s/sqrt(n)
left <- a-error
right <- a+error
left  # OUT: 4.063971
right  # OUT: 5.936029


#----------------------------------------------------------
# Confidence interval using finite correction for 
#   sample less than 39
finite <- sqrt((200 - 39)/(199))
finite

std <- 11 *finite/sqrt(39)
z.values <- qnorm(c(0.02, 0.98), mean = 0, sd = 1, lower.tail = TRUE)
pnorm(z.values,mean = 0, sd = 1, lower.tail = TRUE

c(signif(66+z.values[1]*std, digits=4), signif(66+z.values[2]*std, digits=4))
