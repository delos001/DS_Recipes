# Chad R Bhatti
# 12.19.2018
# pROC_example1.R


########################################################################
# Standard ROC curves for binary classification;
# Generate ROC curve, plot it, and compute AUC;
# Uses the pROC package;
########################################################################

# Install packages if needed;
install.packages('pROC',dependencies=TRUE)
install.packages('woeBinning',dependencies=TRUE)
# Insane number of dependencies needed for pROC;


# Load libraries
library(pROC)
library(woeBinning)


# Rename germancredit;
gc <- germancredit;
str(gc)

# Table response variable;
table(gc$creditability)

# Add target variable with simple name;
# Code the response variable as 0/1;
gc$target <- abs(as.numeric(gc$creditability)-2);
table(gc$target)


# Fit a basic logistic regression model;
model.1 <- glm(target ~ foreign.worker + credit.history, data=gc,
		family='binomial'
		);

summary(model.1)

names(model.1)
model.score.1 <- model.1$fitted.values;


#######################################################################
# Generate ROC curve and plot it;
#######################################################################
# Note that we are using model scores to generate the ROC curve;

roc.1 <- roc(response=gc$target, predictor=model.score.1)
print(roc.1)
plot(roc.1)

# Compute AUC
auc.1 <- auc(roc.1);

#> auc.1
#Area under the curve: 0.6374



#######################################################################
# Generate a SMOOTH ROC curve and plot it;
#######################################################################
# A smooth ROC curve will look prettier and not be as flat;

roc.2 <- smooth(roc=roc.1)
print(roc.2)
plot(roc.2,main='Smoothed ROC Curve for Logistic Regression Model')


# Compute AUC
auc.2 <- auc(roc.2);

#> auc.2 
#Area under the curve: 0.6687
# If you smooth one ROC curve, then you need to smooth them all is you are
# using AUC for comparison purposes;

# Note that there are limitations to using a smoothed ROC curve with pROC.
# You cannot perform a full classification analysis with a smoothed ROC curve.




#######################################################################
# How do we find the threshold value recommended by the ROC curve?;
#######################################################################

# For a raw ROC curve

coords(roc=roc.1,x=c('best'),
input=c('threshold','specificity','sensitivity'),
ret=c('threshold','specificity','sensitivity'),
as.list=TRUE
)

roc.specs <- coords(roc=roc.1,x=c('best'),
input=c('threshold','specificity','sensitivity'),
ret=c('threshold','specificity','sensitivity'),
as.list=TRUE
)


# For a smooth ROC curve
# NOTE!!!! The threshold cannot be returned for a smoothed ROC curve!
# If you need to compute a threshold, then you need to use a raw ROC curve.

coords(smooth.roc=roc.2,x=c('best'),
input=c('specificity','sensitivity'),
ret=c('threshold','specificity','sensitivity'),
as.list=TRUE
)

# In summary if you need to assign the classes using a ROC analysis,
# then you need to use the raw ROC curve, and hence you should use the
# raw ROC curve throughout your analysis AND for any other models that
# you are using for comparison.



#######################################################################
# Once we have the threshold value we can assign the classes?;
#######################################################################

gc$ModelScores <- model.1$fitted.values;
gc$classes <- ifelse(gc$ModelScores>roc.specs$threshold,1,0);

# Rough confusion matrix using counts;
table(gc$target, gc$classes)
# Note the orientation of the table.  The row labels are the true classes 
# and the column values are the predicted classes;


# Let's create a proper confusion matrix
t <- table(gc$target, gc$classes);
# Compute row totals;
r <- apply(t,MARGIN=1,FUN=sum);
# Normalize confusion matrix to rates;
t/r

# Look at your confusion matrix and compare it to roc.specs.
# Do we see anything interesting?  
# What values are on the diagonal?
# What values are on the off-diagonal?




#######################################################################
# Notes:
#######################################################################
# (1) AUC is not a meaningful metric in its own right.  It is only useful
# for model comparisons, similar in that regard to how we use AIC and BIC 
# in linear models.
#
# (2) AUC is only one possible metric when presenting the results of a 
# classifier.  We might also want to show the confusion matrix in rates
# and the overall accuracy rate.
#
#
#
#
#
#





















