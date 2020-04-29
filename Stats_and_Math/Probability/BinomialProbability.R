

# the probability of x successes given the probability p 
#     success on a single trial.  n = 4, x = 3, p = 1/6
this is same as using the binomial formula above
dbinom(3,4,1/6)

# probability that x is greater than or equal to 7 
#   (note 6 is used to get 7 or more) out of 15 samples with a 
#   known success rate of 0.60
pbinom(6,15,0.6, lower.tail = FALSE)
