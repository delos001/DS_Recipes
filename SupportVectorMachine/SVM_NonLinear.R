
# StatsLearning Lect12 R SVM B 111213
# https://www.youtube.com/watch?v=L3n2VF7yKkk&feature=youtu.be
#   IMPORTANT: view this video as it has better code to 
#   get better graphs than what are in the standard svm library

# NOTE: Another example from Ch9, exercise 4 of ISLR text
library(e1071)

set.seed(1)

# create 2 column matrix 200 rows filled with randomly generated number
x = matrix(rnorm(200*2), ncol=2)
x[1:100,] = x[1:100,]+2  # for first hundred rows (1:100), set x to x+2
x[101:150,] = x[101:150,]-2  # for rows 101-150, set x to x-2 (remaining 50 are left alone)

# create vector y: repeat 1 for 150 times, repeat 2 for 50 times
y = c(rep(1,150), rep(2,50))
dat=data.frame(x=x, y=as.factor(y))

plot(x, col=y)

train=sample(200,100)  # create a train sample by taking 100 out of 200 samples


svmfit=svm(y~., 
           data=dat[train,], 
           kernel="radial",   # kernel options could be "polynomial", "radial", etc
           
           # if using polynomial kernal, instead of gamma, use degree argument (ex: degree=3)
           gamma=1,  # gamma=1 specifies the gamma value for the radial kernel
           cost=1)

# note there are some training errors: you could increase the cost, and get more 
#   irregular decision boundary but this could come at cost of overfitting
plot(svmfit, dat[train,])

# output: gives svm type, kernel type, cost value, gamma value, 
#   number of support vectors, number of classes, and levels
summary(svmfit)


# repeats above but with high cost value:
svmfit=svm(y~., 
           data=dat[train,], 
           kernel="radial", 
           gamma=1, 
           cost=1e5)
plot(svmfit, dat[train,])


# CROSS VALIDATION
set.seed(1)
# tune 10 fold cross validation using radial kernel, varying cost and gamma value
tune.out=tune(svm, y~., 
              data=dat[train,], 
              kernel="radial",
              ranges = list(cost=c(0.1, 1, 10, 100, 1000),
                          gamma=c(0.5, 1, 2, 3, 4)))

summary(tune.out)  #  gives the best cost value and the best gamma value
names(tune.out)

# run model on test data; puts results in a confusion matrix to see prediction ability.
table(true=dat[-train,"y"], pred=predict(tune.out$best.model,
                        newdata=dat[-train,]))

# tune.out$best.model argument pulls from the tune.out variable created above.  
# best.model is one of the attributes and this will pull the predicted result 
#     from the model using a cost value of 1 and gamma value of 2
#            pred
# true      1  2
#    1      74  3
#    2        7 16
# this shows that only 10% of the observations are misclassified

