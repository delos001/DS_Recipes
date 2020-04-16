

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
