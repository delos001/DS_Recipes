library(MASS)
library(ISLR)

fix(Boston)

names(Boston)

attach(Boston)
lm.fit=lm(medv~lstat)
lm.fit
summary(lm.fit)

names(lm.fit)
lm.fit$coefficients
coef()
coef(lm.fit)

effects(lm.fit)
confint(lm.fit)

predict(lm.fit, data.frame(lstat=c(5,10,15)), interval = "confidence")

plot(lstat, medv)
abline(lm.fit, lwd=2, col="red")

plot(lstat, medv, col="red", pch=10)
abline(1,2)

plot(lstat, medv, pch="+")
plot(1:20, 1:20, pch=1:20)

par(mfrow=c(2,2))
plot(lm.fit)

plot(predict(lm.fit), residuals(lm.fit))
plot(predict(lm.fit), rstudent(lm.fit))
plot(hatvalues(lm.fit))
which.max(hatvalues(lm.fit))

lm.fit=lm(medv~lstat+age, data=Boston)
summary(lm.fit)
lm.fit

lm.fit=lm(medv~., data=Boston)
summary(lm.fit)

lm.fit1=lm(medv~.-age, data=Boston)
summary(lm.fit1)

par(mfrow=c(2,2))
plot(lm.fit1)

summary(lm(medv~lstat*age, data=Boston))

lm.fit2=lm(medv~lstat+I(lstat^2))
summary(lm.fit2)

lm.fit=lm(medv~lstat)
anova(lm.fit, lm.fit2)

par(mfrow=c(2,2))
plot(lm.fit)
plot(lm.fit2)

lm.fit5 = lm(medv~poly(lstat, 5))
summary(lm.fit5)

summary(lm(medv~log(rm), data=Boston))

fix(Carseats)
names(Carseats)
lm.fit=lm(Sales~. +Income:Advertising + Price:Age, data=Carseats)
summary(lm.fit)
contrasts(Carseats$ShelveLoc)
?contrasts

LoadLibraries = function(){
  library(ISLR)
  library(MASS)
  print("The libraries have been loaded")
}
LoadLibraries()

attach(Auto)
fix(Auto)
names(Auto)
lm.fit8=lm(mpg~horsepower, data=Auto)
summary(lm.fit8)

predict(lm.fit8, data.frame(horsepower=98), interval = "confidence")
predict(lm.fit8, data.frame(horsepower=c(98, 99, 100)), interval="prediction")

plot(horsepower, mpg)
abline(lm.fit8, lwd=1, col="red")

par(mfrow=c(2,2))
plot(lm.fit8)
par(mfrow=c(1,1))

pairs(Auto)
str(Auto)
cor(subset(Auto, select=-name))

lm.fit9 = lm(mpg~.-name, data=Auto)
summary(lm.fit9)

par(mfrow=c(2,2))
plot(lm.fit9)
par(mfrow=c(1,1))
plot(predict(lm.fit9), rstudent(lm.fit9))
names(Auto)
lm.fit9e = lm(mpg~cylinders+horsepower+cylinders:horsepower+acceleration*displacement+weight
              +year+origin)
summary(lm.fit9e)

lm.fit9f = lm(mpg~log(horsepower)+I(horsepower^2)+year+I(acceleration^(1/2)))
summary(lm.fit9f)

attach(Carseats)
fix(Carseats)
names(Carseats)
str(Carseats)

lm.fit10a = lm(Sales~Price+Urban+US)
summary(lm.fit10a)

lm.fit10e = lm(Sales~Price+US)
summary(lm.fit10e)

confint(lm.fit10e, level = 0.95)
plot(predict(lm.fit10e), rstudent(lm.fit10e))

par(mfrow=c(2,2))
plot(lm.fit10e)
par(mfrow=c(1,1))

set.seed(1)
x=rnorm(100)
y=2*x+rnorm(100)

summary(x)

lm.fit11 = lm(y~x+0)
summary(lm.fit11)

lm.fit11b = lm(x~y+0)
summary(lm.fit11b)

(sqrt(length(x)-1) * sum(x*y)) / (sqrt(sum(x*x) * sum(y*y) - (sum(x*y))^2))

set.seed(1)
x=rnorm(100)
eps=rnorm(100, 0, sqrt(0.25))
y = -1 + 0.5*x + eps
length(y)
plot(x,y)

lm.fit13e = lm(y~x)
summary(lm.fit13e)
abline(lm.fit13e, lwd=2, col="2")
abline(-1, 0.5, lwd=2, col="3")
legend(-2, legend=c("model fit", "pop. regression"), col=2:3, lwd=2)


set.seed(1)
x2=rnorm(100)
eps=rnorm(100, 0, sqrt(0.05))
y2 = -1 + 0.5*x2 + eps
length(y2)
plot(x2,y2)

lm.fit13h = lm(y2~x2)
summary(lm.fit13h)
abline(lm.fit13h, lwd=2, col="2")
abline(-1, 0.5, lwd=2, col="3")
legend(-1.5, legend=c("model fit", "pop. regression"), col=2:3, lwd=2)

predict(lm.fit13e, interval="confidence")
confint(lm.fit13e)
confint(lm.fit13h)

set.seed(1)
x1=runif(100)
x2=0.5 * x1 + rnorm(100)/10
y=2 + 2*x1 + 0.3*x2 + rnorm(100)

cor(x1,x2)
plot(x1,x2)
lm.fit14c = lm(y~x1+x2)
summary(lm.fit14c)

lm.fit14d = lm(y~x1)
summary(lm.fit14d)

lm.fit14e = lm(y~x2)
summary(lm.fit14e)

x1 = c(x1, 0.1)
x2 = c(x2, 0.8)
y = c(y, 6)

lm.fit14g1 = lm(y~x1+x2)
summary(lm.fit14g1)

summary(lm(y~x1))
summary(lm(y~x2))

plot(lm.fit14g1)

str(Boston)
summary(Boston)

lm.fit15 = lm(crim~., data=Boston)
summary(lm.fit15)
