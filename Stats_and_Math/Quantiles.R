

# there are 9 different ways/types to calculate quantiles
# default type used by R is type 7, 
#     which will be used if you run the summary function

x <- c( 1.3, 2.2, 2.7, 3.1, 3.3, 3.7)
p <- c(0.25, 0.5, 0.75)

quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 1)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 2)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 3)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 4)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 5)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 6)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 7)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 8)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 9)


#----------------------------------------------------------
# EXAMPLE 1
mag <- c(0.70, 0.74, 0.64, 0.39, 0.70, 2.20, 1.98, 0.64, 1.22, 0.20, 1.64, 1.02, 
         2.95, 0.90, 1.76, 1.00, 1.05, 0.10, 3.45, 1.56, 1.62, 1.83, 0.99, 1.56,
         0.40, 1.28, 0.83, 1.24, 0.54, 1.44, 0.92, 1.00, 0.79, 0.79, 1.54, 1.00,
         2.24, 2.50, 1.79, 1.25, 1.49, 0.84, 1.42, 1.00, 1.25, 1.42, 1.15, 0.93,
         0.40, 1.39)

quantile(mag)



#----------------------------------------------------------
# QUANTILES FOR DISCRETE DISTRIBUTION

# binomial distribution where p is a calculated vector probability
qbinom(0.75, 10, prob = p, lower.tail = TRUE)

# hypergeometric: 32 is what size you want to get quanitle of, 
#   within a 168 medical hospitals using sample size of 10
qhyper(0.75, 32 , 168, 10, lower.tail = TRUE)

