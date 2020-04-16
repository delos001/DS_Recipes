# this example uses the Caravan data set from the ISLR library 
# (85 predictors measuring characteristics for 5822 individuals)
# Purchase is response variable which indicates whether or not an individual purchases a caravan insurance policy  
# NOTE in this data set only 6% of people purchased the caravan insurance


library(ISLR)
dim(Caravan)
attach(Caravan)
summary(Purchase)



standardized.X=scale(Caravan[,-86])
var(Caravan[,1])
var(Caravan[,2])
var(standardized.X[,1])
var(standardized.X[,2])


test=1:1000
train.X=standardized.X[-test,]
test.X=standardized.X[test,]
train.Y=Purchase[-test]
test.Y=Purchase[test]
set.seed(1)
knn.pred=knn(train.X, test.X, train.Y, k=1)
mean(test.Y!=knn.pred)
mean(test.Y!="No")



table(knn.pred, test.Y)
9/(68+9)








knn.pred=knn(train.X, test.X, train.Y, k=3)
addmargins(table(knn.pred, test.Y))
knn.pred=knn(train.X, test.X, train.Y, k=5)
addmargins(table(knn.pred, test.Y))
4/15

glm.fits=glm(Purchase~., data=Caravan, family=binomial, subset=-test)
glm.probs=predict(glm.fits, Caravan[test,], type="response")
glm.pred=rep("No", 1000)
glm.pred[glm.probs>0.5]="Yes"
table(glm.pred, test.Y)

glm.pred=rep("No", 1000)
glm.pred[glm.probs>0.25]="Yes"
table(glm.pred, test.Y)
