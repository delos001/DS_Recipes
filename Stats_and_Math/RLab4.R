library(ISLR)
names(Smarket)
dim(Smarket)
Smarket[1:4,]
summary(Smarket)
attributes(Smarket)
pairs(Smarket)
head(Smarket)
cor(Smarket[,-9])

attach(Smarket)
plot(Volume)

glm.fit=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, family=binomial, data=Smarket)
summary(glm.fit)
coef(glm.fit)
summary(glm.fit)$coef
summary(glm.fit)$coef[,4]

glm.prob=predict(glm.fit, type="response")
glm.prob[1:10]

contrasts(Direction)

glm.pred=rep("Down", 1250)
glm.pred[glm.prob>0.5]="Up"

table(glm.pred, Direction)
table(glm.pred)
addmargins(table(glm.pred, Direction))
(507+145)/1250

train=(Year<2005)
Smarket.2005=Smarket[!train,]
dim(Smarket.2005)
Direction.2005=Direction[!train]

glm.fit=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, family=binomial, data=Smarket,
            subset=train)
glm.probs=predict(glm.fit, Smarket.2005, type="response")
glm.pred=rep("Down", 252)
glm.pred[glm.probs>0.5]="Up"

addmargins(table(glm.pred, Direction.2005))
mean(glm.pred==Direction.2005)
mean(glm.pred!=Direction.2005)

glm.fit=glm(Direction~Lag1+Lag2, data=Smarket, family=binomial, subset=train)
glm.prob=predict(glm.fit, Smarket.2005, type="response")
glm.pred=rep("Down", 252)
glm.pred[glm.prob>0.5]="Up"
addmargins(table(glm.pred, Direction.2005))
mean(glm.pred==Direction.2005)

predict(glm.fit, newdata=data.frame(Lag1=c(1.2, 1.5), Lag2=c(1.1, -0.8)), type="response")

####Linear Discriminant Analysis
library(MASS)
lda.fit=lda(Direction~Lag1+Lag2, data=Smarket, subset=train)
lda.fit

plot(lda.fit)

lda.pred=predict(lda.fit, Smarket.2005)
names(lda.pred)

lda.class=lda.pred$class
addmargins(table(lda.class, Direction.2005))
mean(lda.class==Direction.2005)

sum(lda.pred$posterior[,1]>=0.5)
sum(lda.pred$posterior[,1]<0.5)

lda.pred$posterior[1:20,1]
lda.class[1:20]
sum(lda.pred$posterior[,1]>0.9)

qda.fit=qda(Direction~Lag1+Lag2, data=Smarket, subset=train)
qda.fit

qda.class=predict(qda.fit, Smarket.2005)$class
names(qda.fit)
addmargins(table(qda.class, Direction.2005))
mean(qda.class==Direction.2005)

###K Nearest Neighbor

library(class)
attach(Smarket)

train=(Year<2005)
Smarket.2005=Smarket[!train,]
dim(Smarket.2005)
Direction.2005=Direction[!train]

train.X=cbind(Lag1 ,Lag2)[train ,]
test.X=cbind (Lag1 ,Lag2)[!train ,]
train.Direction =Direction [train]

set.seed(1)
knn.pred=knn(train.X, test.X, train.Direction, k=1)
addmargins(table(knn.pred, Direction.2005))
(83+43)/252
mean(knn.pred==Direction.2005)

knn.pred=knn(train.X, test.X, train.Direction, k=3)
table(knn.pred, Direction.2005)
mean(knn.pred==Direction.2005)

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

addmargins(table(knn.pred, test.Y))
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

#applied

summary(Weekly)
pairs(Weekly)

glm.fit10=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, data=Weekly,
              family=binomial)
summary(glm.fit10)


##functions:
Power=function(){
  2^3
}
print(Power())

Power2=function(x,a){
  x^a
}

Power2(3,8)
Power2(10,3)
Power2(8,17)

Power3=function(x,a){
  result=x^a
  return(result)
}

x=1:10
plot(x, Power3(x,2), log="xy", ylab="Log y=x^2", xlab="Log x",
     main="Log of x^2 vs. Log x")

PlotPower=function(x,a) {
  plot(x, Power3(x,a))
}
PlotPower(1:10, 3)