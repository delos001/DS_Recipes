# Chad R Bhatti
# OneR_example2.R
# 12.17.2018

###########################################################################
# Load Packages;
library('OneR')
library('woeBinning')
###########################################################################

# German credit data from woeBinning;
str(germancredit)

# Response variable is creditability;
table(germancredit$creditability)

# Shorten the data name;
gc <- germancredit;

###########################################################################

# How do we look at EDA for factors in classification?
# Simplest method is to look at the discrete variables.
# What is the target here? Check the numeric values for creditability!

gc$target <- abs(2 - as.numeric(gc$creditability));
table(gc$target)

# Compute the probability of each class by each factor level;
# Here we are computing the Prob(target=1) = Prob(BAD)
# This is a rejection score.  You apply for credit and get rejected
# if you have a high probability of BAD (default).

aggregate(gc$target, by=list(foreign.worker=gc$foreign.worker), FUN=mean)
aggregate(gc$target, by=list(job=gc$job), FUN=mean)


# You can visualize summmary in barplot();
fw <- aggregate(gc$target, by=list(foreign.worker=gc$foreign.worker), FUN=mean)
barplot(fw$x, names.arg=fw$foreign.worker,main='Prob(Default) for Foreign Worker')


################################################################################
# Discrete visualizations of class propensity are convenient and easy to
# understand. Highly useful for classification EDA;
# When we have continuous variables we frequently discretize the continuous
# variable into discrete categories for this purpose.
# How should we bin?
################################################################################


# Base R cut() function;
cuts <- cut(gc$age.in.years,breaks=5);
table(cuts)


# OneR bin() function for equal length bins;
bin <- bin(gc$age.in.years,nbins=5);
table(bin)
aggregate(gc$target, by=list(age.bin=bin), FUN=mean)
# Here are results are non-monotonic;  Not ideal;


# Other options in bin();
bin.2 <- bin(gc$age.in.years,nbins=5,method=c('content'));
table(bin.2)
aggregate(gc$target, by=list(age.bin=bin.2), FUN=mean)
# Reasonably monotonic;


bin.3 <- bin(gc$age.in.years,nbins=5,method=c('clusters'));
table(bin.3)
aggregate(gc$target, by=list(age.bin=bin.3), FUN=mean)
# Reasonably monotonic;


################################################################################
# Now let's look at the optbin() function for 'optimal binning';
################################################################################


# Binning based on logistic regressions;
bin.4 <- optbin(gc$target ~ gc$age.in.years,method=c('logreg'));
table(bin.4)
aggregate(gc$target, by=list(age.bin=bin.4[,1]), FUN=mean)

# Binning based on entropy - decision tree;
bin.5 <- optbin(gc$target ~ gc$age.in.years,method=c('infogain'));
table(bin.5)
aggregate(gc$target, by=list(age.bin=bin.5[,1]), FUN=mean)



################################################################################
# Another type of binning is called Weight Of Evidence (WOE) binning, and  
# we will cover that in a separate tutorial;
################################################################################










