
#------------------------------------------------------------------
# EXAMPLE 1
ex from Q10 of Ch4

library(class)
train.X = as.matrix(Lag2[train])
test.X = as.matrix(Lag2[!train])
train.Direction = Direction[train]
set.seed(1)
knn.pred = knn(train.X, test.X, train.Direction, k = 1)
table(knn.pred, Direction.0910)


knn.pred = knn(train.X, test.X, train.Direction, k = 10)
table(knn.pred, Direction.0910)
mean(knn.pred == Direction.0910)

knn.pred = knn(train.X, test.X, train.Direction, k = 100)
table(knn.pred, Direction.0910)
mean(knn.pred == Direction.0910)



#----------------------------------------------------------------------
# EXAMPLE 2
library(class)
attach(Smarket)

train=(Year<2005)
Smarket.2005=Smarket[!train,]
dim(Smarket.2005)
Direction.2005=Direction[!train]

train.X=cbind(Lag1, Lag2)[train,]
test.X=cbind(Lag2, Lag2)[!train,]
train.Direction=Direction[train]


set.seed(1)
knn.pred=knn(train.X, test.X, train.Direction, k=1)
addmargins(table(knn.pred, Direction.2005))
(83+43)/252
mean(knn.pred==Direction.2005)

knn.pred=knn(train.X, test.X, train.Direction, k=3)
table(knn.pred, Direction.2005)
mean(knn.pred==Direction.2005)


#----------------------------------------------------------------------
# EXAMPLE 3

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
