# Chad R. Bhatti
# 12.19.2018
# woe_example1.R


# Install packages;
install.packages('woeBinning',dependencies=TRUE)

# Load library;
library(woeBinning)
library(OneR)

# Rename germancredit;
gc <- germancredit;
str(gc)

# Table response variable;
table(gc$creditability)

# Add target variable with simple name;
# Code the response variable as 0/1;
gc$target <- abs(as.numeric(gc$creditability)-2);
table(gc$target)


#####################################################################
# What is WOE?
#####################################################################
# WOE = 100*ln(%[1]/%[0]) for each category
# For a two category variable we can compute examples;
# Ex: 50/50 Split has WOE = 100*log(0.50/0.50)=0 No information
# Ex: 0/1 = 25/75 Split has WOE = 100*log(0.75/0.25) = 109.8612
# Ex: 0/1 = 75/25 Split has WOE = 100*log(0.25/0.75) = -109.8612
# The further from 0 the better;
#####################################################################


#####################################################################
# How do we use WOE in EDA?
#####################################################################
# For discrete variables we can compute the WOE for each category
# (i.e. factor level) and see if we have 'separation' in the response
# variable across the categories.  If we do have separation, then the
# predictor is a good predictor.  If we do not have separation, then 
# the predictor is not a good predictor.
#####################################################################


#####################################################################
# How do we use WOE in optimal binning?
#####################################################################
# We can use WOE to create discrete variables that display separation
# in the response variable, and hence engineer better predictor 
# variables.
#####################################################################


#####################################################################
# We essentially compute WOE from a table
#####################################################################

t <- table(gc$housing,gc$target)
t[,1]
t[,2]
100*log( (t[,2]/sum(t[,2])) / (t[,1]/sum(t[,1])) )



#####################################################################
# Write our own function;
#####################################################################

my.woe <- function(my.var,my.target){
	t <- table(my.var,my.target);
	woe <- 100*log( (t[,2]/sum(t[,2])) / (t[,1]/sum(t[,1])) );
	return(woe)
}

my.woe(gc$housing,gc$target)



#####################################################################
# Let's take a look at WOE binning;
#####################################################################

woe.binning(df=gc,target.var=c('target'),pred.var=c('housing'))
my.woe(gc$housing,gc$target)
# Use this example since the binning algorithm will not collapse the factors;
# Hence we can compare results with our static WOE function;


#####################################################################
# Bin age using woe.binning;
#####################################################################

age.bin <- woe.binning(df=gc,target.var=c('target'),pred.var=c('age.in.years'))

# WOE plot for age bins;
woe.binning.plot(age.bin)

# Score bins on data frame;
woe.df <- woe.binning.deploy(df=gc,binning=age.bin)
head(woe.df)
table(woe.df$age.in.years.binned)

# See the WOE Binning Table
woe.binning.table(age.bin)


#####################################################################
# Bin age using woe.tree.binning;
#####################################################################

age.tree <- woe.tree.binning(df=gc,target.var=c('target'),pred.var=c('age.in.years'))

# WOE plot for age bins;
woe.binning.plot(age.tree)
# Note that we got different bins;

# Score bins on data frame;
tree.df <- woe.binning.deploy(df=gc,binning=age.tree)
head(tree.df)
table(tree.df$age.in.years.binned)

# See the WOE Binning Table
woe.binning.table(age.tree)


#####################################################################
# Compare to optbin() in OneR;
#####################################################################

# Binning based on logistic regressions;
bin.4 <- optbin(gc$target ~ gc$age.in.years,method=c('logreg'));
table(bin.4)
aggregate(gc$target, by=list(age.bin=bin.4[,1]), FUN=mean)

# Binning based on entropy - decision tree;
bin.5 <- optbin(gc$target ~ gc$age.in.years,method=c('infogain'));
table(bin.5)
aggregate(gc$target, by=list(age.bin=bin.5[,1]), FUN=mean)


# Looks like the WOE binning is a combination of the two;
# Use whichever binning interest you.  If you just want one method to
# have as a goto, then probably choose WOE.  We have explored more than
# WOE to have a robust discussion of the topic of optimal binning;
# Remember, we can also combine bins for categorical variables using
# backwards variable selection on a family of dummy variables.  We have
# shown that as another example in another video.






















