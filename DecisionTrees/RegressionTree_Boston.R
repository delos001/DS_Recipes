


library(MASS)
set.seed(1)

# create training sample: out of nrows in data set, randomly select half
train=sample(1:nrow(Boston), nrow(Boston)/2)

# create tree to predict medv variable using the training sample
tree.boston=tree(medv~., Boston, subset=train)

plot(tree.boston)  # plot the tree 
# add the text and values: gives mean values for each terminal node for 
# the splits (ex: lower lstat results in higher priced homes)
text(tree.boston)


# et summary results from the tree.  NOTICE only 3 of the variables are used.  
# In regression tree, deviance is simply sum of squared errors for tree
summary(tree.boston)




# creates cross validation for tree above (to see if prunning could improve performance)
cv.boston=cv.tree(tree.boston)
# plots deviance vs. tree size (size is number of terminal nodes of each tree considered)
plot(cv.boston$size, cv.boston$dev, type="b")


# prune the tree
# prune the tree using a 5 terminal node tree (note that you would set this number 
# based on the cross validation results, so if cv resulted in 7, you would do best=7
prune.boston=prune.tree(tree.boston, best=5)
plot(prune.boston)
text(prune.boston, pretty=0)


# predict the results from the tree using the test data
yhat=predict(tree.boston, newdata=Boston[-train,])  
boston.test=Boston[-train, "medv"]  # test rows (-train) for medv column
plot(yhat, boston.test)
abline(0,1)       # line with intercept of zero and slope of 1
mean((yhat-boston.test)^2)   # test set MSE: 
# MSE discussion:
# 24.046:  the square root of MSE is around 5.01 indicating this model least to test 
# predcitions that are within around 5,010 of true median home value for the suburb
