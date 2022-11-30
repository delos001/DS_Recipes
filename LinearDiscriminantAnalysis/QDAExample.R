
# This code is from StatsLearning Lect10 R A LDA 111213 (see resource in 1Note)

library(MASS)
attach(Smarket)

qda.fit=qda(Direction~Lag1+Lag2, data=Smarket, subset=train)
qda.fit


qda.class=predict(qda.fit, Smarket.2005)$class
addmargins(table(qda.class, Direction.2005))

mean(qda.class==Direction.2005)


#-------------------------------------------------------------------
# EXAMPLE 2
# ex from Q10 of Ch4

library(MASS)

train = (Year < 2009)
Weekly.0910 = Weekly[!train, ]

qda.fit = qda(Direction ~ Lag2, data = Weekly, subset = train)
qda.class = predict(qda.fit, Weekly.0910)$class
table(qda.class, Direction.0910)

mean(qda.class == Direction.0910)


qda.fit = qda(Direction ~ Lag2 + sqrt(abs(Lag2)), data = Weekly, subset = train)
qda.class = predict(qda.fit, Weekly.0910)$class
table(qda.class, Direction.0910)
mean(qda.class == Direction.0910)


