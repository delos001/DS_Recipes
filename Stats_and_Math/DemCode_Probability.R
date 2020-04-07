# Predict 401 Demonstration of Calculations using R for Week 3 

#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# Examples of calculations using the classical method of assigning probabilities.
# marginal, union, joint and conditional probabilities (Section 4.4 Black)

# Problem:  Each of three people are presented with 5 different soft drinks in random 
# order.  What is the probability the three people pick the same drink at random?
# Refer to Black Section 4.3.  Sampling with replacement.

number.of.possible.outcomes <- 5*5*5  
number.of.outcomes.with.agreement <- 5
number.of.outcomes.with.agreement/number.of.possible.outcomes

# Problem:  One soft drink is preferred by the manufacturer.  Three people pick 
# two soft drinks from 5 selections which include the preferred soft drink.  What
# is the probability none of the people pick the preferred soft drink at random?
# Refer to Black Section 4.3.  Sampling without replacement.

# First, calculate the number of combinations for a single person.


# Second, remove the preferred drink and calculate the number of combinations for 
# a single person.  Then raise to the third power for three people.
y <- c("b","c","d","e")
dim(combn(y,2))[2]
reduced.number.combinations <- (dim(combn(y,2))[2])^3

reduced.number.combinations/total.number.combinations

#-------------------------------------------------------------------------------
# The following examples use the Hospital.csv data set.

hospital <- read.csv(file.path("c:/RBlack/","Hospital.csv"),sep=",")
str(hospital)

# Black Chapter 1 Analyzing the Databases (page 15) has a hospital data dictionary.

# To generate a table with margins, it is necessary to convert the variables to factors.
# In this case, this is equivalent to generating nominal variables for table construction.
# Simultaneously the variables will be labeled for easy of interpretation.

control <- factor(hospital$Control, labels = c("G_NFed","NG_NP","Profit","F_GOV"))
region <- factor(hospital$Geog..Region, labels = c("So","NE","MW",'SW',"RM","CA","NW"))
control_region <- table(control, region)

# Add marginal totals and rename for simplicity.  Print the table.
# The table frequencies can be indexed by row and column.

mcr <- addmargins(control_region)
mcr


# Demonstration of calculations in Figure 4.7 of Business Statistics by Black.

# Marginal probability hospital is for profit?
mcr[3,8]/mcr[5,8]

# Union probability Rocky Mountain or Not Government Not for-profit?
(mcr[5,5]+mcr[2,8]-mcr[2,5])/mcr[5,8]

# Intersection probability for-profit in California?
mcr[3,6]/mcr[5,8]

# Conditional probability hospital is in Midwest if for-profit?
mcr[3,3]/mcr[3,8]

# Conditional probability hospital is government non-federal if in the South?
mcr[1,1]/mcr[5,1]

# Note that a conditional probability is a ratio of a single cell total (which is
# the intersection of two events) divided by a marginal total.  

# Extra problem:  Probability NG_NP but not Regions NE or MW?
(mcr[2,8]-mcr[2,2]-mcr[2,3])/mcr[2,8]

# Bayes' Theorem Calculation
# What is the probability a hospital is a for profit hospital if it is in MW?
# Refer to Section 4.8 for the formula used in this example.  The numerator in 
# that formula gives us the intersection probability for a MW for-profit hospital.
# The denominator sums up the intersection probabilities to provide the 
# probability of a MW hospital.

mcr

numerator <- (mcr[3,8]/mcr[5,8])*(mcr[3,3]/mcr[3,8])
# The numerator is the intersection probability of MW and for-profit.

marginal <- mcr[,8]/mcr[5,8]
conditional <- mcr[,3]/mcr[,8]
intersection <- marginal*conditional
numerator/sum(intersection[1:4])
# The denominator sums up all the intersection probabilities of hospitals in the
# MW to obtain the probability of a MW hospital.

# As a check calculate the conditional probability directly.
mcr[3,3]/mcr[5,3]

# Compare to the unconditional marginal probability.  There is a difference.
mcr[3,8]/mcr[5,8]

# Hospitals by type of service: general or psychiatric.-------------------------

# Breakdown of hospitals by service: general hospital=1, psychiatric=2.
# Create a factor out of Service and form a table.
service <- factor(hospital$Service, labels = c("medical", "psychiatric"))
service <- addmargins(table(service))

p <- service[2]/service[3]
p

# Demonstration of differences and similarities between dbinom() and dhyper().

dbinom(5,10,p)
# The binomial probability reflects sampling with replacement.

dhyper(5,32,168,10)
# The hypergeometric probability reflects sampling without replacement.

x <- seq(0,10)
par(mfrow = c(2,1))
plot(x,dbinom(x, 10 , prob = p), type = "h", main = "Binomial Probabilities", col = "red")
points(x,dbinom(x, 10 , prob = p), pch = 16, cex = 1)
plot(x,dhyper(x, 32 , 168, 10), type = "h",main = "Hypergeometric Probabilities", col = "blue")
points(x,dhyper(x, 32 , 168, 10), pch = 16, cex = 1)
par(mfrow = c(1,1))

par(mfrow = c(2,1))
plot(x,pbinom(x, 10 , prob = p), type = "h", main = "Binomial cdf", col = "red")
abline(h = 0.75, col = "green")
points(x,pbinom(x, 10 , prob = p), pch = 16, cex = 1)
plot(x,phyper(x, 32 , 168, 10), type = "h", main = "Hypergeometric cdf" , col = "blue")
abline(h = 0.75, col = "green")
points(x,phyper(x, 32 , 168, 10), pch = 16, cex = 1)
par(mfrow = c(1,1))

# With a discrete distribution it is difficult to divide the probabilities equally.

qbinom(0.75, 10, prob = p, lower.tail = TRUE)
qhyper(0.75, 32 , 168, 10, lower.tail = TRUE)

# By definition the pth quantile is that number x such that two conditions are met.
# P[X < x] <= p and P[X <= x] >= p.

# Poisson distribution in R-----------------------------------------------------
# Find out more using help(dpois).  lambda is the expected or average value.

help(dpois)
# Using n = 10 and p = 0.16 from before we can choose lambda = 1.6 and compare.

par(mfrow = c(2,1))
plot(x,dpois(x, lambda = 1.6), type = "h", main = "Poisson Probabilities", col = "red")
points(x,dpois(x, lambda = 1.6), pch = 16, cex = 1)
plot(x,ppois(x, lambda = 1.6), type = "h", main = "Poisson cdf" , col = "blue")
points(x,ppois(x, lambda = 1.6), pch = 16, cex = 1)
abline(h = c(0.25, 0.5, 0.75), col = "green")
par(mfrow = c(1,1))

qpois(c(0.25, 0.5, 0.75), lambda = 1.6, lower.tail = TRUE)

# By definition the pth quantile is that number x such that two conditions are met.
# P[X < x] <= p and P[X <= x] >= p.
#-------------------------------------------------------------------------------

# Some caution is needed when using library functions

p <- 0.4   # Assume a binomial distribution with 500 trials.

# Suppose the probability of less than 225 successes is desired.
# pbinom includes 225 in the lower tail if lower.tail = TRUE.  Must subtract 1 from 225.
pbinom(224,500,p,lower.tail=TRUE)
# This is a check.  Note the following calculation which sums the lower tail.
x <- c(seq(0,224,by = 1))
sum(dbinom(x,500,p))

# If 225 or less is desired than 225 can be included in the function.
pbinom(225,500,p,lower.tail=TRUE )
# This is a check.  Note the following calculation which sums the lower tail.
x <- c(seq(0,225,by = 1))
sum(dbinom(x,500,p))

# It is important to keep in mind the exclusion or inclusion of values.

#-------------------------------------------------------------------------------

