library(ISLR)
attach(Wage)

fit=lm(wage~poly(age,4), data=Wage)



coef(summary(fit))
coef(fit)
summary(fit)

fit2=lm(wage~poly(age, 4, raw=T), data=Wage)

coef(summary(fit2))

fit2a=lm(wage~age+I(age^2)+I(age^3)+I(age^4), data=Wage)
fit2b=lm(wage~cbind(age, age^2, age^3, age^4), data=Wage)


agelims=range(age)
agelims
age.grid=seq(from=agelims[1], to=agelims[2])
age.grid
preds=predict(fit, newdata=list(age=age.grid), se=TRUE)
se.bands=cbind(preds$fit + 2*preds$se.fit, preds$fit-2*preds$se.fit)

par(mfrwo=c(1,2), mar=c(4.5, 4.5, 1,1), oma=c(0,0,4,0))
plot(age, wage, xlim=agelims, cex=0.5, col="darkgrey")
title("Degree-1 Polynomial", outer=T)
lines(age.grid, preds$fit, lwd=2, col="blue")
matlines(age.grid, se.bands, lwd=1, col="blue", lty=3)


preds2 =predict (fit2 ,newdata =list(age=age.grid),se=TRUE)
max(abs(preds$fit - preds2$fit ))



fit.1 = lm(wage~age, data=Wage)
fit.2 = lm(wage~poly(age,2), data=Wage)
fit.3 = lm(wage~poly(age,3), data=Wage)
fit.4 = lm(wage~poly(age,4), data=Wage)
fit.5 = lm(wage~poly(age,5), data=Wage)

anova(fit.1, fit.2, fit.3, fit.4, fit.5)
