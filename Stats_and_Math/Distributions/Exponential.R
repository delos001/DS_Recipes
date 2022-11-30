
# SEE DISTRIBUTION README


#----------------------------------------------------------
# BASIC SYNTAX
# use ?dexp, ?pexp etc for help

dexp(x, rate = 1, log = FALSE)
pexp(q, rate = 1, lower.tail = TRUE, log.p = FALSE)
qexp(p, rate = 1, lower.tail = TRUE, log.p = FALSE)
rexp(n, rate = 1)



# find probability that x is greater than 2, given a 
#     rate of change of 1.2 using a one tailed test (upper tail)
#     result is 0.0907 (Black example p212)
pexp(2,rate=1.20, lower.tail = FALSE)


#----------------------------------------------------------
# PLOTTING EXAMPLE
x <- seq(0,5,0.1)
plot(x,dexp(x,rate = 1), 
     type = "l", 
     col = "red", 
     ylab = "density", 
     main = "Exponential Density Function Rate = 1", 
     lwd = 2)
