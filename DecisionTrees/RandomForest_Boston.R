
# StatsLearning Lect10 R trees B 111213
# https://www.youtube.com/watch?v=IY7oWGXb77o&feature=youtu.be


# Growing a random forest proceeds in exactly the same way, 
#   except that we use a smaller value of the mtry argument.
# By default, randomForest() uses p/3 variables when building a 
#   random forest of regression trees, and sqrt(p) variables when 
#   building a random forest of classification trees. 
# Here we use mtry = 6.


library(randomForest)
library(MASS)  # contains the Boston data

train=sample(1:nrow(Boston), nrow(Boston)/2)  # partition data: train and test

set.seed(1)

# create random forest to predict the medv variable using Boston data 
# and train subset data with 6 predictor variables (mtry=6) considered 
# for each split.  Importance will show the importance of each variable

rf.boston=randomForest(medv~., 
                       data=Boston, 
                       subset=train, 
                       mtry=6, 
                       importance=TRUE)

yhat.rf=predict(rf.boston,    # predict medv using test [-train] observations
                newdata=Boston[-train,])

mean((yhat.rf-boston.test)^2)  # get MSE

importance(rf.boston)   # gives a chart for the importance of the variables:


# Two measures of variable importance are reported. 
# The former is based upon the mean decrease of accuracy in predictions 
# on the out of bag samples when a given variable is excluded from the model. 
# The latter is a measure of the total decrease in node impurity that results 
# from splits  over that variable, averaged over all trees (this was plotted in 
# Figure 8.9). In the case of regression trees, the node impurity is measured by 
# the training RSS, and for classification trees by the deviance.

# produces plots of the importance measures: 
# The results indicate that across all of the trees considered in the 
# random forest, the wealth level of the community (lstat) and the house 
# size (rm) are by far the two most important variables.
varImpPlot(rf.boston)
