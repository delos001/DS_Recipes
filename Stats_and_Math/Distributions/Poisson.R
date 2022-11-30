
# IN THIS SCRIPT
# PPOIS
# DPOIS
# RPOIS

# Focuses on the number of discrete occurences over some interval or continuum
# Describes the occurrence of rare events  (law of improbable events)

# Characteristics: 
# discrete distribution
# describes rare events
# independent occurrences
# discrete occurences over time
# expected # of occurrences must be held constant



#----------------------------------------------------------
# PPOIS
# If there are twelve cars crossing a bridge per minute on average, 
# find the probability of having seventeen or more cars crossing the 
# bridge in a particular minute.
# Therefore:

# lower tail test: 
#     The probability of having sixteen or less cars crossing the 
#       bridge in a particular minute is given by the function ppois.
#     Gives you the cummulative probability of having 16 or less given 
#       a running average of 12
ppois(16, lambda=12)

# upper tail test: 
#     The probability of having seventeen or more cars crossing 
#       the bridge in a minute is in the upper tail of the probability 
#       density function.
ppois(16, lambda=12, lower=FALSE)



#----------------------------------------------------------
# DPOIS
# Gives you the discrete probability of getting exactly 5 with a 
#   running average of 3
# If the random variable x has a Poisson Distribution with mean 
#   equal to 3, find the probability that x = 5. 
dpois(5,lambda=3)



#----------------------------------------------------------
# RPOIS
# generate distribution of random samples
# produces density function for x=0.5 with 5 df, with t-distribution
set.seed(1234)
# sets object with poisson distribution, 10,000 values, lambda = 0.5
poisVector<-rpois(1000,lambda=0.5)
mean(poisVector)
var(poisVector)

poisVector[:100]  # gives you first 100 numbers
