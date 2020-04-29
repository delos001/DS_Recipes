
# We apply bagging and random forests to the Boston data, 
# using the randomForest package in R. The exact results 
# obtained in this section may depend on the version of R 
# and the version of the randomForest package installed on 
# your computer. Recall that bagging is simply a special case 
# of a random forest with m = p. Therefore, the randomForest() 
# function can be used to perform both random forests and bagging.



library(randomForest)
library(MASS)  # MASS package that has the Boston data set

# create a training split: 
# use half the number of observations out of all the observations 
#   in the data set
train = sample(1:nrow(Boston), nrow(Boston)/2)

set.seed(1)
# create random forest to predict medv using all data in Boston data set, 
# using the train subset.  The mtry=13 indicates all 13 predictors should 
# be considered for each split of the tree
bag.boston=randomForest(medv~., 
                        data=Boston, 
                        subset = train, 
                        mtry=13, 
                        importance=TRUE)
bag.boston


# get predicted values using bagged tree results using test data [-train,]
yhat.bag=predict(bag.boston, 
                 newdata=Boston[-train,])
plot(yhat.bag, boston.test)   # plot predicted results vs. actual results
abline(0,1)    # generate a line with intercept at 0, slope=1
mean((yhat.bag-boston.test)^2)   # get the MSE.  results in 13.16 

# Change the number of trees grown by random forest using the ntree argument
# same as above but the number of trees grown is 25
bag.boston=randomForest(medv~., 
                        data=Boston, 
                        subset=train, 
                        mtry=13, 
                        ntree=25)
yhat.bag=predict(bag.boston, 
                 newdata=Boston[-train,])
mean((yhat.bag-boston.test)^2)
