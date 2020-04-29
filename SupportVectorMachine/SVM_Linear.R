
# StatsLearning Lect12 R SVM A 111213
# https://www.youtube.com/watch?v=qhyyufR0930&feature=youtu.be



set.seed(1)

# create a 2 column matrix with 20 randomly generated numbers in each column
x = matrix(rnorm(20*2), ncol = 2)

# create vector containing 10 values of 1 and 10 values of -1 
# (for 20 total values in the vector)
y = c(rep(-1,10), rep(1,10))

x[y==1,] = x[y==1,]+1  # when y is 1, x is x+1

# plot x.  differentiate color by subtracting the y value (either a 1 or a -1) 
#   from 3 which gives red or blue
plot(x, col = (3-y))

dat=data.frame(x = x, y = as.factor(y))

library(e1071)

# support vector matrix: predict y, using dat data frame, with linear kernel, cost value = 10, 
#     small cost value gives wide margins with many support vectors on margin or violate margin
#     large cost value gives narrow margins and few support vectors on margin or violating margin
#     scale = false (tells svm not to scale each feature to have mean zero or sd of 1  
#         (depending on application, you may want scale=TRUE)
svmfit=svm(y~., data=dat, kernel="linear", cost=10, scale=FALSE)

# plot support vector classifier with separating data points using svm function
# region of feature space that will be assigned to the −1 class is shown in light blue, 
#   and the region that will be assigned to the +1 class is shown in purple
plot(svmfit, dat)



names(svmfit)  # show all outputs categories of svmfit
svmfit$index  # identifies the support vectors from the svmfit

summary(svmfit)

# output:
# Parameters:
#    SVM-Type:  C-classification 
#  SVM-Kernel:  linear 
#        cost:  10 
#       gamma:  0.5 
# Number of Support Vectors:  7
# ( 4 3 )
# Number of Classes:  2 
# Levels: 
#  -1 1

# NOTE: if we used a small cost value (0.1), then the result in the example gives many more support vectors:
# 1  2  3  4  5  7  9 10 12 13 14 15 16 17 18 20




# CROSS VALIDATION FOR SUPPORT VECTOR CLASSIFIER
set.seed(1)

# tune performs 10fold cross validation of svm (in this case, based on cost values): 
#   y is dep var, using dat dataframe, with linear kernel, and a range of cost values.
tune.out=tune(svm, y~., data=dat, kernel="linear", 
	ranges=list(cost=c(0.001, 0.01, 1, 5, 10, 100)))
  
# gives error for each cost value 
#   (and also gives the "best" value which is cost=0.1, in this example)
summary(tune.out)


bestmod=tune.out$best.model  # creates variable that will store best model
# gives summary of an SVM model using the bestmod (ie: the best cost of 0.1)
summary(bestmod)


# USE THE PREDICT FUNCTION TO PREDICT CLASS LABEL
# create matrix with 2 columns of randomly generated numbers, 20 rows for each column
xtest = matrix(rnorm(20*2), ncol=2)

# randomly select either a 1 or a -1, 20 times
ytest = sample(c(-1,1) , 20, replace = TRUE)
xtest[ytest==1,] = xtest[ytest==1,] + 1  # when y is 1, x is x+1

# add the y values to the data frame, as a factor 1,-1
testdat=data.frame(x = xtest, y = as.factor(ytest))

# predict using the bestmod (cost=0.1 from above) using the new testdat data
ypred = predict(bestmod, testdat)
# create a confusion matrix with to show the class predictions
table(predict = ypred, truth = testdat$y)

