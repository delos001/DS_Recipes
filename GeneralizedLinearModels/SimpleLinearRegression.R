

library(ISLR)

attach(Boston)
lm.fit=lm(medv~lstat)
lim.fit=lm(medv~lstat, data=Boston)
summary(lim.fit=lm(medv~lstat, data=Boston))
lm.fit
summary(lm.fit)

names(lm.fit)

lm.fit$coefficients


coef(lm.fit)

confint(lm.fit)
predict(lm.fit)
predict(lm.fit, data.frame(lstat=c(5,10,15)), interval = "confidence")



predict(lm.fit, data.frame(lstat=c(5,10,15)), interval = "prediction")

plot(lstat,medv)
abline(lm.fit, lwd=2, col="red")


par(mfrow=c(2,2))
plot(lm.fit)
par(mfrow=c(1,1))

par(mfrow=c(2,2))
plot(predict(lm.fit), residuals(lm.fit))
plot(predict(lm.fit), rstudent(lm.fit))
plot(hatvalues(lm.fit))
which.max(hatvalues(lm.fit))
