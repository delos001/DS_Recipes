



# Assume independent random samples are available from two populations 
# giving information about population proportions. For the first sample 
# assume n1= 100 and x1= 45. For the second sample, assume n2= 100 and x2= 42. 
# Test the null hypothesis that the population proportions are equal 
# versus the alternative hypothesis that the proportion for population 1 
# is greater than the proportion for population 2.  
# This is a one-sided test and the alternative hypothesis must be stated 
# with p1 - p2 > 0, and the test statistic calculated accordingly. Pick the 
# correct z value and p-value. Round your answer to the nearest thousandth.

# gets the pooled sample between the two samples
n1 <- 100
x1 <- 45
n2 <- 100
x2 <- 42
pht<-(x1+x2)/(n1+n2)
pht  # OUT: .435

# H0 = pht2 > pht1,  
# H0 determines one sided test (since not set to equal)
pht1 <- x1/n1
pht2 <- x2/n2
zScore <- (pht2 - pht1)/(sqrt((pht*(1-pht))*((1/n1)+(1/n2))))
zScore  # OUT: -0.4278952
# Now look up zScore in table: 0.428 = 0.664
# Since we are doing greater than, subtract 1, as z-score is to LEFT and we
# need to look to RIGHT. Thus: 1 - 0.664 = 0.336
