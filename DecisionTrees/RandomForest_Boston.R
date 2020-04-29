
# StatsLearning Lect10 R trees B 111213
# https://www.youtube.com/watch?v=IY7oWGXb77o&feature=youtu.be


# Growing a random forest proceeds in exactly the same way, 
#   except that we use a smaller value of the mtry argument.
# By default, randomForest() uses p/3 variables when building a 
#   random forest of regression trees, and sqrt(p) variables when 
#   building a random forest of classification trees. 
# Here we use mtry = 6.


library(randomForest)
library(MASS)

train=sample(1:nrow(Boston), nrow(Boston)/2)

set.seed(1)
rf.boston=randomForest(medv~., data=Boston, subset=train, mtry=6, importance=TRUE)

yhat.rf=predict(rf.boston, newdata=Boston[-train,])
mean((yhat.rf-boston.test)^2)

importance(rf.boston)




varImpPlot(rf.boston)
