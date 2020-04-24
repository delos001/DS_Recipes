
# Cummulative Dist:  pbinom(x, n, p): 
# use for cumulative distribution function  
# x=number of sucesses, n=number of trials, p=probability

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



pbinom(c(7,6,5,4,3),10,0.5, lower.tail=FALSE)


pbinom(58,100,0.5, lower.tail=FALSE)

pnorm(58-0.5,50,sqrt(100*0.5*0.5), lower.tail=FALSE)
