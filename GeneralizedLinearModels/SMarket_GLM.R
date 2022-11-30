# For this example, we use the Smarket data set which gives data on the market 
# vs. lag 1,2,3,4,5 days prior to the date specified

library(ISLR)
attach(Smarket)

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
