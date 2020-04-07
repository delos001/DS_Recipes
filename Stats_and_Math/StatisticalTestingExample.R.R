## Practice Problems for Final Exam, PREDICT 401

###########
# 1)	Suppose that a class of 30 students is assigned to write an essay.

#  a.	Suppose 4 essays are randomly chosen to appear on the class bulletin board.
#     How many different groups of 4 are possible?

factorial(30) / (factorial(4) * factorial(30 - 4)) # [1] 27405

#  b.	Suppose 4 essays are randomly chosen for awards of $10, $7, $5 and $3.
#     How many different groups of 4 are possible?

factorial(30) / factorial(30 - 4) # [1] 657720

#  c.	Explain the significant differences between problems 1 and 2.

# Item (a) asks for the combinations or groups of four possible. There isn't a sense
# in which the order of the four essays selected is meaningful. Item (b) asks for the
# permutations possible when four are selected from 30. Here, there is a meaningful
# difference in the order - i.e. prizes awarded - of the four selected. 


###########
# 2)  Find the standard deviation for the given probability distribution.

P.x <- c(0.37, 0.13, 0.06, 0.15, 0.29)
x <- c(0, 1, 2, 3, 4)
mean.x <- sum(x*P.x)
var.x <- sum(P.x*(x - mean.x)^2)
sqrt(var.x)  # [1] 1.703056

###########

# 3)  For a standard normal distribution, find the percentage of data that are more 
#     than 2 standard deviations below the mean or more than 3 standard deviations 
#     above the mean.

pnorm(-2, 0, 1,lower.tail = TRUE) + pnorm(3, 0, 1, lower.tail = FALSE)
# [1] 2.410003

###########
# 4) Use Bayes’ theorem to find the indicated probability with the results below.

#                      Approve of Mayor		Do not approve of Mayor
#	Republican			             8					        17
#	Democrat			              18					        13
#	Independent			             7					        37

# One of the 100 test subjects is selected at random. Given that the person selected
# approves of the Mayor, what is the probability that they vote Democrat?

# We know the person approves of the Mayor. Let's look at only those individuals.
# Of the "Mayor approvers," 18 vote Democrat.

18 / (8 + 18 + 7) # [1] 0.5454545

# We can also work the problem "the long way":

# Probability a person votes Democrat:
(18 + 13) / (8 + 17 + 18 + 13 + 7 + 37) # [1] 0.31

# Probability a Democrat-voter approves of Mayor:
18 / (18 + 13) # [1] 0.5806452

# Probability a person doesn't vote Democrat:
(8 + 17 + 7 + 37) / (8 + 17 + 18 + 13 + 7 + 37)  # OR, 1 - Person_votes_Democrat [1] 0.69

# Probability a non-Democrat-voter approves of Mayor:
(8 + 7) / (8 + 17 + 7 + 37) # [1] 0.2173913

# So, applying these values to the usual formulation of Bayes' theorem:
(0.31 * 0.5806452) / ((0.31 * 0.5806452) + (0.69 * 0.2173913)) # [1] 0.5454546

###########
#5) Use the results summarized in the table for (4) and test at the 5% level if party affiliation
#   and approval of the Mayor are independent of each other using Pearson's Chi-square
#   test of independence.

approve <- c(8, 18, 7)
not.approve <- c(17, 13, 37)
vote <- cbind(approve, not.approve)

chisq.test(vote, correct = FALSE)  # X-squared = 14.633, df = 2, p-value = 0.0006646

###########
# 6) A police department reports that the probabilities that 0, 1, 2, and 3 burglaries
#    will be reported in a given day are 0.46, 0.41, 0.09, and 0.04, respectively. Find
#    the standard deviation for the probability distribution. Round the answer to the
#    nearest hundredth.

probs <- c(0.46, 0.41, 0.09, 0.04)
meanProb <- sum(probs * c(0, 1, 2, 3))

varProb <- sum(probs * (-meanProb + c(0, 1, 2, 3))^2)
round(sqrt(varProb), 2) # [1] 0.79

###########
# 7)  Assume that the weight loss for the first month of a diet program varies between
#     6 pounds and 12 pounds, and is spread evenly over the range of possibilities, so
#     that there is a uniform distribution. Find the probability of between 8.5 and 10 
#     poundslost.

(10 - 8.5) / (12 - 6) # [1] 0.25

###########
# 8) Find the indicated z-score. The graph depicts the standard normal distribution with
#    mean = 0 and standard deviation = 1. 	Shaded area is 0.0901.

# To return the indicated z-score:
qnorm(0.0901, mean = 0, sd = 1) # [1] -1.340139

# To create the plot:
x <- seq(-3, 3, length = 100)
y <- dnorm(x, mean = 0, sd = 1)
plot(x, y, type = "l")

x2 <- seq(-3, -1.34, length = 100)
y2 <- dnorm(x2, mean = 0, sd = 1)
polygon(c(-3,x2, -1.34), c(0, y2, 0), col = "gray")
text(-0.5, 0.1, "0.0901", cex = 2)

###########
# 9)	True or False:  in a hypothesis test, an increase in alpha will cause a decrease
#     in the power of the test provided the sample size is kept fixed.

# FALSE. The power of a test - the probability of rejecting the null hypothesis when
# the alternative hypothesis is true - decreases as a function of beta; the probability
# of failing to reject the null hypothesis when the alternative hypothesis is true. An
# increase in alpha will decrease beta, thus increasing power. However, please remember
# that alpha and beta aren't symmetric and we won't try to control one via the other.

###########
# 10)	True or False:  in a hypothesis test regarding a population mean, the
#     probability of a type II error, beta, depends on the true value of the population
#     mean.

# TRUE. The probability of a type II error - failure to reject a false null
# hypothesis - is dependent on the "true value" of the test statistic. In a broad sense,
# either type error will have some relationship with the true mean. However, alpha is much
# more directly related to the test statistic - the probability associated with our data
# given the null hypothesis. Power, however, is related directly to the difference between
# the true and hypothesized mean and how easily, how "powerfully" we can resolve smaller and
# smaller differences between the true and hypothetical mean.

###########
# 11)	True or False:  In a hypothesis test regarding a population mean, if the
#     sample size is increased and the probability of a type II error is fixed and does not 
#     change then the type I error rate does not change.

# FALSE. Keeping the power the same, an increase in sample size provides more data for 
# the statistical test making it less likely that a type I error will occur.  

###########
# 12)	True or False:  In a hypothesis test regarding a population mean, if the
#     sample size is increased and the probability of a type I error is fixed and does not 
#     change then the type II error rate will decrease.  

# TRUE. With alpha constant, an increase in sample size provides more data for the statistical 
# test increasing the power.  Thus it less likely that a type II error will occur.  

###########
# 13)	Suppose that you perform a hypothesis test regarding a population mean, and that
#     the evidence does not warrant rejection of the null hypothesis. When formulating
#     the conclusion to the test, why is phrase “fail to reject the null hypothesis” more
#     accurate than the phrase “accept the null hypothesis?”  Give a short answer.

# A hypothesis test does not “prove” the null hypothesis. Rather, it is meant to determine
# whether or not there is sufficient evidence to reject it. Insufficient evidence does not
# validate the null hypothesis; it just leaves us without grounds for rejecting it.

###########
# 14)	According to a recent poll, 53% of Americans would vote for the incumbent president.
#     If a random sample of 100 people results in 45% who would vote for the incumbent,
#     test the claim that the actual percentage is 53%. Use a 0.10 significance level.

# H0:  p  = 0.53  (null hypothesis)
# H1:  p != 0.53  (alternative hypothesis)
# z = -1.60
# p = 0.1095986
# critical z = -1.645

# Calculate z-score:
stdDev <- sqrt((100 * 0.53) * (1 - 0.53))

z <- (45 - (100 * 0.53))/stdDev
z # [1] -1.602888

# Estimate p-value:
2 * pnorm(-1.60) # [1] 0.1095986

# Calculate critical z score:
qnorm(1 - 0.10/2, lower.tail = F) # [1] -1.644854

# Given our p-value and adopted significance level, 0.110 > 0.10, we fail to reject the
# null hypothesis. There is insufficient evidence to reject the claim that the “true”
# percentage is 53%.

###########
# 15)	What is the relationship between the linear correlation coefficient and the
#     usefulness of the regression equation for making predictions?

# The linear regression equation is appropriate for predictions only when there is
# linear correlation between two variables. The linear correlation coefficient
# quantifies the strength of a linear relationship, and greater  or significant
# magnitudes indicate the likely usefulness of the linear regression equation for
# the purpose of prediction.

###########
# 16)  Assume that a hypothesis test of the given claim will be conducted. A cereal
#      company claims that the mean weight of the cereal in its packets is 14 oz.
#      Identify the type I error for the test.

# c.	Reject the claim that the mean weight is 14 oz. when it is actually 14 oz.
# A type I error is the incorrect rejection of a "true" null hypothesis.

###########
# 17)	Scores on a test are normally distributed with a mean of 68.2 and a standard
#     deviation of 10.4. Estimate the probability that among 75 randomly selected students,
#     at least 20 of them score greater than 78.

# We need to determine the z-score associated with our score of interest, 78
z <- (78-68.2)/10.4

# We need to determine the probability associated with a random value being greater than 78
p <- 1-pnorm(z,0,1,lower.tail=TRUE)

# SAME AS ABOVE, just specifying that we want the "upper tail"
p <- pnorm(z,0,1,lower.tail = F)

# This sequence "provides" the => 20 possible instances (56 of a total 75) that we need for
# summing our probabilities:
x <- seq(20,75,1)

# This returns the exact binomial probability:
sum(dbinom(x,75,p)) # [1] 0.02784581

# We may want the normal approximation, for which:

# This formula returns a z-score for the normal approximation:
b <- (19.5-p*75)/sqrt(75*p*(1-p))

# This returns the probability associated with our "corrected" z-score:
pnorm(b , 0, 1, lower.tail=FALSE) # [1] 0.02321583

# EXPLANATION:  We assume a normal distribution, but we rely on a binomial distribution
# when we want the likelihood of => 20 "successes". So, 0.173 is the probability associated
# with any "random" test taker scoring greater than 78; this we solve assuming (and
# employing a normal distribution; pnorm()). However, when we go to look at the likelihood
# that at least 20 of our test takers achieve this score we rely on a binomial, even though
# we still assume (and rightly) that our test scores are normally distributed.

# So, looking at the sum(dbinom(x, 75, p)). This is the exact binomial probability associated
# with our conditions; 20 or more successes (test score > 78) out of 75 test takers. What we
# want is to correct for the fact that we've had to use a discrete distribution (binomial) to
# approach a continuous, normally distributed problem/reality.

# The (19.5 - p * 75)/ sqrt(75 * p * (1-p)) gives us our "corrected" z-score that we can then
# "plug in" to our cumulative probability function, pnorm().

###########
# 18) Find the value of the linear correlation coefficient, r.

x <- c(62, 53, 64, 52, 52, 54, 58)
y <- c(158, 176, 151, 164, 164, 174, 162)

cor(x, y) # [1] -0.7749395

###########
# 19) A researcher wants to estimate what proportion of U.S. refinery workers are contract workers.
#     The researcher wants to be 95% confident of her results and be within 0.05 of the actual proportion.
#     There are no prior studies.  The researcher has no idea what is the actual propulation
#     proportion.  How large a sample size should be taken?  Round to the next largest integer.

z <- qnorm(0.975, 0, 1, lower.tail = TRUE)
n <- z^2*0.5*0.5/0.05^2   #  [1] 384.1459
n

###########
# Use the traditional method to test the given hypothesis. Assume that the samples
# are independent and that they have been randomly selected.

# 20)	Use the given sample data to test the claim that P1 > P2. Use a significance level of 0.01.

# Sample 1	  Sample 2
# n1 = 85	  n2 = 90
# x1 = 38	  x2 = 23

# P1 = 0.447
# P2 = 0.256
# z = 2.66
# critical z = 2.33

# Calculate pooled sample proportion:
p <- (((38/85) * 85) + ((23/90) * 90)) / (85 + 90)

# Calculate standard error:
stdErr <- sqrt(p * (1 - p) * ((1/85) + (1/90)))

z <- ((38/85) - (23/90)) / stdErr
z # [1] 2.657104

# Calculate the critical z-score:
qnorm(1 - 0.01) # [1] 2.326348

# At a significance level of 0.01, we reject the null hypothesis. There is sufficient
# idence to support the claim that P1 > P2.

###########
# Test the indicated claim about the means of two populations. Assume that the two
# samples are independent simple random samples selected from normally distributed
# populations. Do not assume that the population standard deviations are equal. Use
# the traditional method or “p-value” method as indicated.

# 21)	 A researcher was interested in comparing the amount of time (in hours) spent
#      watching television by women and by men. Independent simple random samples of
#      14 women and 17 men were selected, and each person was asked how many hours he
#      or she had watched television during the previous week. The summary statistics
#      are as follows:

# Women		Men
# x1 = 12.5 hr	x2 = 13.8 hr
# s1 = 3.9 hr	s2 = 5.2 hr
# n1 = 14		n2 = 17

x1 <- 12.5
s1 <- 3.9
n1 <- 14

x2 <- 13.8
s2 <- 5.2
n2 <- 17

# Calculate our t:
t <- (x1 - x2) / sqrt(s1^2/n1 + s2^2/n2)
t # [1] -0.7945437

s1n1 <- s1^2/n1
s2n2 <- s2^2/n2

df.calculated <- ((s1n1 + s2n2)^2)/(s1n1^2/(n1-1)+s2n2^2/(n2-1))
df.calculated
n1 + n2 -2

# Calculate the critical t:
qt(1 - 0.05, df = df.calculated, lower.tail = F) # [1] -1.699535

# At our adopted significance level (0.05), we fail to reject the null hypothesis.
# There is insufficient evidence for the claim that the mean amount of time spent
# watching television by women is smaller than the mean amount of time spent
# watching television by men.

###########
# Perform the indicated hypothesis tests.  Assume the two samples are independent simple random 
# samples selected from normally distributed populations.  Also assume that the population 
# standard deviations are equal.  Pool the sample variances for the test.

# 22)	A researcher was interested in comparing the amount of time spent watching
#     television by women and by men. Independent simple random samples of 14 women
#     and 17 men were selected, and each person asked how many hours he or she had
#     watched television during the previous week. The summary statistics are as follows:

# Women		Men
# x1 = 11.4 hr	x2 = 16.8 hr
# s1 = 4.1 hr	s2 = 4.7 hr
# n1 = 14		n2 = 17

x1 <- 11.4
s1 <- 4.1
n1 <- 14

x2 <- 16.8
s2 <- 4.7
n2 <- 17

# Calculate our pooled standard deviation
s <- sqrt(((n1 - 1)*s1^2 + (n2 -1)*s2^2) / (n1 + n2 - 2))

# Calculate our t:
t <- (x1 - x2) / (s*sqrt(1/n1 + 1/n2))
t # [1] -3.369099

# Calculate the critical t:
qt(1 - 0.05, df = n1 + n2 - 2, lower.tail = F) # [1] -1.699127

# At our adopted significance level (0.05), we reject the null hypothesis. There
# is sufficient evidence for the claim that the mean amount of time spent watching
# television by women is smaller than the mean amount of time spent watching
# television by men.

###########
# 23)  Construct the indicated confidence interval for the difference between population
#      proportions, P1 - P2. Assume that the samples are independent and that they have
#      been randomly selected.  x1 = 15, n1 = 50 and x2 = 23, n2 = 60. Construct a 90% 
#      confidence interval for the difference between population proportions, P1 - P2.

x1 <- 15
n1 <- 50

x2 <- 23
n2 <- 60

p1 <- x1/n1
p2 <- x2/n2

# Calculate the standard deviation of the difference between proportions:
s <- sqrt(p1 * (1 - p1)/n1 + p2 * (1 - p2)/n2 )

# Calculate the critical z:
qnorm(1-0.10/2) # [1] 1.644854

(p1 - p2) - (qnorm(1-0.10/2)*s) # [1] -0.2317335
(p1 - p2) + (qnorm(1-0.10/2)*s) # [1] 0.06506688

############
# 24)  Use the given data to find the equation of the regression line. Round the
#      final values to three significant digits, if necessary.

x <- c(6, 8, 20, 28, 36)
y <- c(2, 4, 13, 20, 30)

lm(y ~ x)$coefficients

# (Intercept)           x 
#  -3.7900485   0.8974515

###########
# 25) Conduct a chi-square test for independence. State the null and alternative
#     hypotheses, and provide the chi-square and associated p-value. A web service 
#     is interested in whether or not having signed up for email updates and offers 
#     is independent of purchasing choice (has purchased or has not). Determine 
#     the margins, chi-square statistics and associated p-value for the contingency 
#     table below:

#				           has made purchase		has not made purchase
# has signed up		      30				             60
# has not signed up	    20				             75

# Calculate the margin totals:

values <- matrix(c(30, 60, 20, 75), ncol = 2, byrow = TRUE)
colnames(values) <- c("purchase", "notPurchase")
rownames(values) <- c("signUp", "notSignUp")
values <- addmargins(values)
values

# Calculate the expected values based on marginal probabilities:
185 * (50/185) * (95/185) # [1] 25.67568

expValues <- values

expValues[, 1] <- c(50 - 25.67568, 25.67568, 50)
expValues[, 2] <- c(135 - (95 - 25.67568), 95 - 25.67568, 135)
expValues

chiSq <- (30 - 24.32432)^2 / 24.32432 + (60 - 65.67568)^2/65.67568 +
	(20 - 25.67568)^2/25.67568 + (75 - 69.32432)^2/69.32432

chiSq # [1] 3.534118
pchisq(chiSq, df = 1, lower.tail = F) # [1] 0.06011828

# We can use the chisq.test() function on our contingency table.
# NOTE:  table provided to test should NOT have margin totals.

values <- matrix(c(30, 60, 20, 75), ncol = 2, byrow = TRUE)
chisq.test(values, correct = FALSE)

#         Pearson's Chi-squared test

# data:  values
# X-squared = 3.5341, df = 1, p-value = 0.06012

###########
# 26)	Conduct a chi-square goodness of fit test. State the null and alternative 
#     hypothesis, and provide the chi-square and associated p-value.An urgent care
#     center is interested in whether visits per day of the week are uniformly distributed.

visits <- c(24, 19, 26, 29, 30, 23)

# Calculate our expected visits, assuming a uniform density:
expVisits <- rep(sum(visits)/length(visits), times = length(visits))

# Calculate our chi-square statistic:
chiSq <- sum((visits - expVisits)^2 / expVisits)
chiSq # [1] 3.291391

# Calculate our p-value:
pchisq(chiSq, df = 6 - 1, lower.tail = F) # [1] 0.65516

# We could use the chisq.test() on our observed frequencies:
chisq.test(visits, p = rep(1/length(visits), times = length(visits)))

#         Chi-squared test for given probabilities

# data:  visits
# X-squared = 3.2914, df = 5, p-value = 0.6552

# NOTE:  chisq.test() would've used uniform probabilities for "p" by default.
chisq.test(visits)

#         Chi-squared test for given probabilities

# data:  visits
# X-squared = 3.2914, df = 5, p-value = 0.6552

###########
# 27) Test the hypothesis of a zero correlation using the procedure shown
#     by Wilcox in Basic Statistics on pages 173-174.  Assume the coefficient
#     r is a Pearson Product Moment Correlation coefficient.  Assume n = 47, 
#     r = -0.286.  Test the null hypothesis of zero correlation versus the 
#     alternative that the correlation is negative at 95% confidence.  Also 
#     calculate the p-value.

# Calculate T:
T <- -0.286 * sqrt((47 - 2)/(1 - (-0.286)^2))
T # [1] -2.002178

# Calculate the critical value:
qt(1 - 0.05, df = 45, lower.tail = F) # [1] -1.679427

# Calculate the p-value:
1 - pt(abs(-2.00), df = 45) # [1] 0.02577884

# The T test statistic has a Student’s t-distribution with 45 degrees
# of freedom.  The test statistic value is -2.00.  The critical value
# is -1.679.  Since T = -2.00 < -1.679 the null hypothesis can be
# rejected.  The p-value is 0.0258 < 0.05.

###########
# 28)	A project manager is trying to assemble a five-member team. She has a
# 	  list of 30 volunteers that she intends to draw five (5) from randomly,
#	    so as not to alienate anyone. However, only four (4) of the 30 have a specific
#	    certification that the project manager knows she’ll need. What is the
#	    probability that two of the five members randomly selected will be one
#	    of the four with the needed certification?

N <- 30 # size of population
k <- 4  # number of "successes"
n <- 5  # sample size, without replacement
x <- 2  # quantity of interest

((factorial(k) / (factorial(x) * factorial(k - x))) *
	(factorial(N - k) / (factorial(n - x) * factorial((N - k) - (n - x))))) /
	(factorial(N) / (factorial(n) * factorial(N - n)))

# Or, using the dhyper() function:
dhyper(2, 4, (30 - 4), 5) # [1] 0.1094691


# What is the probability that at least one of the five members randomly selected
# will have the needed certification?

1 - phyper(0, 4, (30 - 4), 5) # [1] 0.5384054

###########
# 29)	Consumers are asked to rate a company both before and after viewing a video 
#     on the company twice a day for a week.  Use the paired data given below.  Use a
#     traditional statistical.  Test at the 1%   significance level if the "after" results
#     are less than the "before" results.  Assume the data are normally distributed.

#     pair	   1	 2	 3	 4	 5	 6	 7	 8   9
#     before	38	27	30	41	36	38	33	36	44
#     after	  22	28	21	38	38	26	19	31	35

before <- c(38,	27,	30,	41,	36,	38,	33,	36,	44)
after <-  c(22,	28,	21,	38,	38,	26,	19,	31,	35)
delta <- before - after  #  null hypothesis is that the difference is zero.
                         #  alternative hypothesis is the difference is > 0.
sd(delta)
qt(0.99, 8, lower.tail = TRUE)

t.test(delta, alternative = c("greater"), mu = 0, paired = FALSE, conf.level = 0.99)

# At our adopted significance level, we reject the null hypothes of no difference.

###########
# 30)	Fill in the missing entries in the following, partially completed one-way
#     ANOVA table.  Determine the p-value.

# Source		 df	   SS		  MS = SS/df		F-statistic
# Treatment		3						              11.16
# Error			      13.72		0.686
# Total

# df, Error (SS / MS)
13.72 / 0.686 # [1] 20

# df, Total (df_Treatment + df_Error)
3 + 20 # [1] 23

# MS, Treatment (F-statistic * MS_Error)
11.16 * 0.686 # [1] 7.65576

# SS, Treatment (df_Treatment * MS_Treatment)
3 * 7.65576 # [1] 22.96728

# SS, Total (SS_Treatment + SS_Error)
22.96728 + 13.72 # [1] 36.68728

pf(11.16, 3, 20, lower.tail = FALSE)  # p-value = 0.0001607934