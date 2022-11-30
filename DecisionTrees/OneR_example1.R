# Chad R Bhatti
# OneR_example1.R

###########################################################################
# Paper: https://link.springer.com/article/10.1023/A:1022631118932
###########################################################################

The main purpose of the OneR package and paper is to point out to the 
machine learning community that simple models provide insights that get
lost in larger more complex models.  Remember, this is the machine learning
community, not the statistics community, hence there is no concept of EDA
in the machine learning community.  This is their attempt at EDA.  Throughout
my courses I frequently refer to this as Computational EDA.  We frequently
fit decision trees, random forest, and naive models using automated variable
selection to take a model based approach to EDA. 

The OneR package implements 1 level decision trees.  My interpretation of 
this is a decision tree in 1 variable that allows multiple splits.  If you
read the documentation, then you will see that OneR creates up to 5
categorical bins for an attribute and uses them to create this tree.  All
numerical attributes are discretized to 5 equal length bins.  Categorical
attributes are taken as the five largest factor levels.

Note: Take a look at the article if you are interested, but I will warn you
that it is not written in a manner that is readable for most students.

###########################################################################


# Install Packages;
install.packages('OneR',dependencies=TRUE)
install.packages('woeBinning',dependencies=TRUE)

# Load Packages;
library('OneR')
library('woeBinning')

# German credit data from woeBinning;
str(germancredit)

# Response variable is creditability;
table(germancredit$creditability)



###########################################################################
# Shorten the data name;
gc <- germancredit;

col.list <- c('status.of.existing.checking.account',
		'installment.rate.in.percentage.of.disposable.income',
		'age.in.years','other.installment.plans','creditability');

skinny <- gc[,col.list];
head(skinny)


# Formula style call;
model.1 <- OneR(creditability ~ ., data=gc, verbose=TRUE);
# This suggests that essentially any model should reach the level of 70% 
# accuracy.


# What do we get from the method function summary()?
summary(model.1)


# Generic call requires response variable be the last column in the data frame;
model.2 <- OneR(skinny, verbose=TRUE);
summary(model.2)


# Fit a model to a single attribute;
model.3 <- OneR(creditability ~ status.of.existing.checking.account, data=gc, verbose=TRUE);
summary(model.3)

# You can also use print() to print out the model;
print(model.3)

# You can also access the model object;
names(model.3)



###########################################################################
# Plot a mosaic plot;
###########################################################################
# Commonly used to visualize classifier accuracy;
plot(model.3)
# Here note that it would be better to have shorter names for your factor levels;




###########################################################################
# Print out a confusion matrix;
###########################################################################
y.hat <- predict(model.3,newdata=gc);
y <- gc$creditability;

eval_model(prediction=y.hat, actual=y, dimnames=c('Prediction','Actual'))

# Note that we want to show confusion matrices in rates (or relative) in 
# any reports.  People cannot relate/understand what a confusion matrix
# of counts is.  You want to be able to look at your confusion matrix
# and instantly know your accuracy.






























