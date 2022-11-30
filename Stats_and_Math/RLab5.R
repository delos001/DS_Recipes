library(ISLR)

attach(Auto)
set.seed(1)
train=sample(392, 196)


lm.fit = lm(mpg~horsepower, data=Auto, subset=train)
mean((mpg-predict(lm.fit,Auto))[-train]^2)

lm.fit2 = lm(mpg~poly(horsepower, 2), data=Auto, subset=train)
mean((mpg-predict(lm.fit2, Auto))[-train]^2)

lm.fit3 = lm(mpg~poly(horsepower, 3), data=Auto, subset=train)
mean((mpg-predict(lm.fit3, Auto))[-train]^2)

set.seed(2)
train=sample(392, 196)

lm.fit = lm(mpg~horsepower, data=Auto, subset=train)
mean((mpg-predict(lm.fit,Auto))[-train]^2)

lm.fit2 = lm(mpg~poly(horsepower, 2), data=Auto, subset=train)
mean((mpg-predict(lm.fit2, Auto))[-train]^2)

lm.fit3 = lm(mpg~poly(horsepower, 3), data=Auto, subset=train)
mean((mpg-predict(lm.fit3, Auto))[-train]^2)

library(boot)
glm.fit=glm(mpg~horsepower, data=Auto)
cv.err = cv.glm(Auto, glm.fit)
cv.err$delta

cv.error=rep(0,5)
cv.error
for (i in 1:5) {
  glm.fit=glm(mpg~poly(horsepower, i), data=Auto)
  cv.error[i]=cv.glm(Auto, glm.fit)$delta[1]
}
cv.error

set.seed(17)
cv.error.10=rep(0,10)
for (i in 1:10){
  glm.fit = glm(mpg~poly(horsepower, i), data=Auto)
  cv.error.10[i]= cv.glm(Auto, glm.fit, K=10)$delta[1]
}
cv.error.10

names(Portfolio)
library(boot)
alpha.fn=function (data ,index){
  X=data$X[index]
  Y=data$Y[index]
  return ((var(Y)-cov(X,Y))/(var(X)+var(Y) -2*cov(X,Y)))
}

alpha.fn(Portfolio, 1:100)

set.seed(1)
alpha.fn(Portfolio, sample(100, 100, replace=T))

boot(Portfolio, alpha.fn, R=1000)

boot.fn = function(data, index){
  return (coef(lm(mpg~horsepower, data=data, subset=index)))
} 
boot.fn(Auto, 1:392)

set.seed(1)
boot.fn(Auto, sample(392, 392, replace=T))

boot(Auto, boot.fn, 1000)

summary(lm(mpg~horsepower, data=Auto))
summary(lm(mpg~horsepower, data=Auto))$coef

boot.fn = function(data, index){
  coefficients(lm(mpg~horsepower+I(horsepower^2), data=data, subset=index))
}
set.seed(1)
boot(Auto, boot.fn, 1000)

pr=function(n) return(1-(1-1/n)^n)
x = 1:10000
plot(x,pr(x))

store=rep(NA, 10000)
for (i in 1:10000){
  store[i]=sum(sample(1:100, replace = TRUE)==4)>0
}
mean(store)

store2=rep(NA, 10)
for (i in 1:10){
  store2[i]=sum(sample(1:10, replace = TRUE)==4)>0
}
store2
sum(store2)
mean(store2)

store3
sum(store3)
mean(store3)

storea=sample(1:10, replace=TRUE)
storea
sum(storea==4)
sum(storea==4)>0

summary(Default)
set.seed(1)
glm.fit1=glm(default~income+balance, data=Default, family=binomial)

set.seed(1)
q5 = function(){
train = sample(dim(Default)[1], dim(Default)[1]/2)
glm.fit2=glm(default~income+balance, data=Default, family=binomial, subset=train)
glm.pred=rep("No", dim(Default)[1]/2)
glm.probs=predict(glm.fit2, Default[-train, ], type="response")
glm.pred[glm.probs>0.5]="Yes"
return(mean(glm.pred != Default[-train, ]$default))
}
q5()

set.seed(1)
FiveB = function() {
  # i.
  train = sample(dim(Default)[1], dim(Default)[1]/2)
  # ii.
  glm.fit = glm(default ~ income + balance, data = Default, family = binomial, 
                subset = train)
  # iii.
  glm.pred = rep("No", dim(Default)[1]/2)
  glm.probs = predict(glm.fit, Default[-train, ], type = "response")
  glm.pred[glm.probs > 0.5] = "Yes"
  # iv.
  return(mean(glm.pred != Default[-train, ]$default))
}
FiveB()
