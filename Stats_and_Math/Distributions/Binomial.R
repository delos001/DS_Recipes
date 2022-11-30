# IN THIS SCRIPT:
# Cummulative Distribution
# Discrete Distribution
# Quantile Distribution


#----------------------------------------------------------
# CUMMULATIVE DISTRIBUTION:  pbinom(x, n, p): 
# use for cumulative distribution function  
# x=number of sucesses, n=number of trials, p=probability
# The experiment has n identical trials, 
#   only 2 possible outcomes, independent outcomes, 
#   prob of success is constant, q=(1-p) is probability of failure

# for cummulative probability of 5 sucesses (5 or fewer) 
# in 10 trials, with probability of 0.5 using lower tail.  
pbinom(5,10,0.5, lower.tail=TRUE)   # OUT: 0.6230469


# for cummulative probability of 5 sucesses (6 or greater) 
# in 10 trials, with probability of 0.5 using upper tail.  
# (note this is 1-p) for lower tail above
pbinom(5,10,0.5, lower.tail=TRUE)   # OUT: 0.3769531   


# gives probability s for  n sucessess(3,4,5,6,7) in 
# 10 trials, with probability of 0.5 using lower tail.  
pbinom(c(3,4,5,6,7),10,0.5, 
       lower.tail=TRUE)  # OUT: 0.1718, 0.3769, 0.6230, 0.82812, 0.94531


# gives probability s for  n sucessess(7,6,5,4,3) in 10 trials, 
# with probability of 0.5 using upper tail.  
pbinom(c(7,6,5,4,3),10,0.5, 
       lower.tail=FALSE)  # OUT: 0.05468, 0.1718750, 0.3769, 0.6230, 0.82812

# approximate the binomial distribution using normal 
# distribution when np>5 and nq>5
#probabilities with binomial distribution
pbinom(58,100,0.5, lower.tail=FALSE)



#----------------------------------------------------------
# DISCRETE DISTRIBUTION: 
# use for binomial probability distributions
# x=number of sucesses, n=number of trials, p=probability
# The experiment has n identical trials, only 2 possible outcomes, 
#   independent outcomes, prob of success is constant, q=(1-p) is 
#   probability of failure

# for probability of exactly 5 successes (interval 1-5) 
# in 10 trials, with probability of 0.5 using lower tail.  
sum(dbinom(c(0,1,2,3,4,5),10,0.5))  # OUT: 0.6230469

# for probability of exactly 5 successes (interval 6-10) in 
# 10 trials, with probability of 0.5 using lower tail.  
# (note this is 1-p) for lower tail above
sum(dbinom(c(6,7,8,9,10),10,0.5))  # OUT: 0.3769531  


# The binomial probability reflects sampling with replacement
# pull sample of size 10 from p (above) and get probability of 
# getting 5 psychiatric hospitals
dbinom(5,10,p)




#----------------------------------------------------------
# QUANTILE DISTRIBUTION: quantiles are a range of probabilities
# use for Binomial probabilities 
# x=quantiles, n=number of trials, p=probability

# gives number of sucesses for quantiles (0.1,0.25,0.5,0.75,0.9) 
# in 10 trials, with probability of 0.5 using lower tail. 
qbinom(c(0.1,0.25,0.5,0.75,0.9),10,0.5, lower.tail=TRUE) # OUT: 3,4,5,6,7

# gives number of sucesses for quantiles (0.1,0.25,0.5,0.75,0.9) 
# in 10 trials, with probability of 0.5 using upper tail.  
qbinom(c(0.1,0.25,0.5,0.75,0.9),10,0.5, lower.tail=FALSE)  # OUT: 7,6,5,4,3
