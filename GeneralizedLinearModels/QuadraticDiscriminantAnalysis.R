library(MASS)
attach(Smarket)

qda.fit=qda(Direction~Lag1+Lag2, data=Smarket, subset=train)
qda.fit



qda.class=predict(qda.fit, Smarket.2005)$class
addmargins(table(qda.class, Direction.2005))






mean(qda.class==Direction.2005)
