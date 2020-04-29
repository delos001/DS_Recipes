
# Applies only to experiments with replacement 
#   (note this is opposite of binomial distribution)

# characteristics:
# discrete distribution
# each outcome is either success of failure
# sampling without replacement
# Population, N, is finite
# number of successes in population, A, is known

# see Fishers exact test for example of getting probability 
# using hypergeometric distribution
dhyper(x, m, n, k, log = FALSE)
phyper(q, m, n, k, lower.tail = TRUE, log.p = FALSE)
qhyper(p, m, n, k, lower.tail = TRUE, log.p = FALSE)
rhyper(nn, m, n, k)


# for:
# x=3: if I draw 3 white balls, what is the probability given:
# m=8 total white balls are present
# n=16 total black balls are present (found by subtracting white balls from total balls)
# k=5 is how many balls will be drawn from the sample
dhyper(3,8,16,5)


# EXAMPLE 2
# The hypergeometric probability reflects sampling without replacement
# specify number of psych hospitals wanted: of 32 there, 168 are medical, 
#   with sample size of 10
dhyper(5,32,168,10)
