# This code is from StatsLearning Lect10 R A LDA 111213 (see resource in 1Note)
# lda() function is part of the MASS library
# lda() function is same as lm() and glm() except for absense of family option


library(MASS)
attach(Smarket)

train=(Year<2005)
Smarket.2005=Smarket[!train,]
dim(Smarket.2005)
Direction.2005=Direction[!train]

lda.fit=lda(Direction~Lag1+Lag2, data=Smarket, subset=train)

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





#---------------------------------------------------------
# EXAMPLE 2

# example from Q10 of Ch4

library(MASS)

train = (Year < 2009)
Weekly.0910 = Weekly[!train, ]

lda.fit = lda(Direction ~ Lag2, data = Weekly, subset = train)
lda.pred = predict(lda.fit, Weekly.0910)
table(lda.pred$class, Direction.0910)

mean(lda.pred$class == Direction.0910)

lda.fit = lda(Direction ~ Lag2:Lag1, data = Weekly, subset = train)
lda.pred = predict(lda.fit, Weekly.0910)
mean(lda.pred$class == Direction.0910)


