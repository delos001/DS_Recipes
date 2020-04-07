library(ISLR)
attach(Wage)


fit=lm(wage~poly(age,4), data=Wage)
coef(summary(fit))
coef(fit)
summary(fit)

fit2=lm(wage~poly(age, 4, raw=T), data=Wage)
coef(summary(fit2))

fit2a=lm(wage~age+I(age^2)+I(age^3)+I(age^4), data=Wage)
coef(fit2a)

fit2b=lm(wage~cbind(age, age^2, age^3, age^4), data=Wage)
coef(summary(fit2b))

agelims=range(age)
agelims
age.grid=seq(from=agelims[1], to=agelims[2])
age.grid
preds=predict(fit, newdata=list(age=age.grid), se=TRUE)
se.bands=cbind(preds$fit + 2*preds$se.fit, preds$fit-2*preds$se.fit)
preds

par(mfrow=c(1,2), mar=c(4.5, 4.5, 1,1), oma=c(0,0,4,0))
plot(age, wage, xlim=agelims, cex=.5, col="darkgrey")
title("Degree-1 Polynomial", outer=T)
lines(age.grid, preds$fit, lwd=2, col="blue")
matlines(age.grid, se.bands, lwd=1, col="blue", lty=3)
par(mfrow=c(1,1))
preds2=predict(fit2, newdata = list(age=age.grid), se=TRUE)
max(abs(preds$fit-preds2$fit))

preds2 =predict (fit2 ,newdata =list(age=age.grid),se=TRUE)
max(abs(preds$fit - preds2$fit ))

fit.1 = lm(wage~age, data=Wage)
fit.2 = lm(wage~poly(age,2), data=Wage)
fit.3 = lm(wage~poly(age,3), data=Wage)
fit.4 = lm(wage~poly(age,4), data=Wage)
fit.5 = lm(wage~poly(age,5), data=Wage)

anova(fit.1, fit.2, fit.3, fit.4, fit.5)

fit=glm(I(wage>250)~poly(age,4), data=Wage, family=binomial)
preds=predict(fit, newdata=list(age=age.grid), se=TRUE)

pfit = exp(preds$fit)/(1+exp(preds$fit))
se.bands.logit = cbind(preds$fit + 2*preds$se.fit, preds$fit - 2*preds$se.fit)
se.bands = exp(se.bands.logit)/(1+exp(se.bands.logit))

plot(age,I(wage>250), xlim=agelims, type="n", ylim=c(0, 0.2))
points(jitter(age), I((wage>250)/5), cex=0.5, pch="|", col="darkgrey")
lines(age.grid, pfit, lwd=2, col="blue")
matlines(age.grid, se.bands, lwd=1, col="blue", lty=3)
names(preds)

table(cut(age, 4))
fit = lm(wage~cut(age,4), data=Wage)
coef(summary(fit))

### regression splines

library(splines)
fit=lm(wage~bs(age, knots=c(25, 40, 60)), data = Wage)
pred=predict(fit, newdata=list(age=age.grid), se=TRUE)
plot(age, wage, col="gray")
lines(age.grid, pred$fit, lwd=2)
lines(age.grid, pred$fit + 2*pred$se, lty="dashed")
lines(age.grid, pred$fit - 2*pred$se, lty="dashed")

dim(bs(age, knots = c(25, 40, 60)))
dim(bs(age, df=6))
attr(bs(age, df=6), "knots")

### natural spline
fit2=lm(wage~ns(age, df=4), data=Wage)
pred2=predict(fit2, newdata = list(age=age.grid), se=TRUE)
lines(age.grid, pred2$fit, col="red", lwd=2)

plot(age, wage, col="gray")
lines(age.grid, pred2$fit, lwd=2)
lines(age.grid, pred2$fit + 2*pred2$se, lty="dashed")
lines(age.grid, pred2$fit - 2*pred2$se, lty="dashed")

### smooth spline
plot(age, wage, xlim=agelims, cex=0.5, col="darkgrey")
title("Smoothing Spline")
fit=smooth.spline(age, wage, df=16)
fit2=smooth.spline(age, wage, cv=TRUE)
fit2$df
lines(fit, col="red", lwd=2)
lines(fit2, col="blue", lwd=2)
legend("topright", legend=c("16DF", "6.8DF"), col=c("red", "blue"), lty=1, lwd=2, cex=0.8)

####local Regression

plot(age, wage, xlim=agelims, cex=0.5, col="darkgrey")
title("Local Regression")
fit = loess(wage~age, span=0.2, data = Wage)
fit2 = loess(wage~age, span=0.6, data = Wage)
lines(age.grid, predict(fit, data.frame(age=age.grid)), col="red", lwd=2)
lines(age.grid, predict(fit2, data.frame(age=age.grid)), col="blue", lwd=2)
legend("topright", legend=c("Span=0.2", "Span=0.5"), col=c("red", "blue"),
       lty=1, lwd=2, cex=0.8)

### generalized additive models

gam1 = lm(wage~ns(year,4)+ns(age, 5)+education, data=Wage)
summary(gam1)
par(mfrow=c(1,3))
plot.gam(gam1, se=TRUE, col="red")

library(gam)
gam.m3 = gam(wage~s(year, 4) + s(age,5) + education, data=Wage)
par(mfrow=c(1,3))
plot(gam.m3, se=TRUE, col="blue")
par(mfrow=c(1,1))
summary(gam.m3)

gam.m1 = gam(wage~s(age,5)+education, data = Wage)
gam.m2 = gam(wage~year+s(age,5) + education, data=Wage)
anova(gam.m1, gam.m2, gam.m3, test="F")

summary(gam.m3)

par(mfrow=c(1,3))
preds=predict(gam.m2, newdata=Wage)
gam.lo=gam(wage~s(year, df=4) + lo(age, span=0.7) + education, data=Wage)
plot.gam(gam.lo, se=TRUE, col="red")
par(mfrow=c(1,1))

gam.lo.i=gam(wage~lo(year, age, span=0.5)+education, data=Wage)

library(akima)
par(mfrow=c(1,2))
plot(gam.lo.i)
par(mfrow=c(1,1))

gam.lr=gam(I(wage>250)~year+s(age, df=5)+education, family=binomial, data=Wage)
par(mfrow=c(1,3))
plot(gam.lr, se=TRUE, col="green")
par(mfrow=c(1,1))

table(education, I(wage>250))

gam.lr.s = gam(I(wage>250)~year + s(age, df=5) + education, family=binomial,
               data=Wage, subset=(education!="1. < HS Grad"))
plot(gam.lr.s, se=TRUE, col="green")


### applied exercises
set.seed(1)
library(boot)
all.deltas=rep(NA, 10)
for (i in 1:10){
  glm.fit = glm(wage~poly(age, i), data=Wage)
  all.deltas[i] = cv.glm(Wage, glm.fit, K=10)$delta[2]
}
plot(1:10, all.deltas, xlab="Deg", ylab = "CV error", type="l", pch=20, lwd=2,
     ylim=c(1590, 1700))
min.point=min(all.deltas)
sd.points=sd(all.deltas)
abline(h=min.point+0.2*sd.points, col="red", lty="dashed")
abline(h=min.point-0.2*sd.points, col="red", lty="dashed")
legend("topright", "0.2 Stdev lines", lty="dashed", col="red")

fit.1=lm(wage~age, data=Wage)
fit.2=lm(wage~poly(age, 2), data=Wage)
fit.3=lm(wage~poly(age, 3), data=Wage)
fit.4=lm(wage~poly(age, 4), data=Wage)
fit.5=lm(wage~poly(age, 5), data=Wage)
fit.6=lm(wage~poly(age, 6), data=Wage)
fit.7=lm(wage~poly(age, 7), data=Wage)
fit.8=lm(wage~poly(age, 8), data=Wage)
fit.9=lm(wage~poly(age, 9), data=Wage)
fit.10=lm(wage~poly(age, 10), data=Wage)

anova(fit.1, fit.2, fit.3, fit.4, fit.5,
      fit.6, fit.7, fit.8, fit.9, fit.10)

plot(wage~age, data=Wage, col="darkgrey")
agelims=range(Wage$age)
age.grid=seq(from=agelims[1], to=agelims[2])
lm.fit=lm(wage~poly(age,3), data=Wage)
lm.pred=predict(lm.fit, data.frame(age=age.grid))
lines(age.grid, lm.pred, col="blue", lwd=2)

set.seed(1)
summary(Wage$maritl)
summary(Wage$jobclass)

par(mfrow=c(1,2))
plot(Wage$maritl, Wage$wage)
plot(Wage$jobclass, Wage$wage)
par(mfrow=c(1,1))

fit = lm(wage~maritl, data=Wage)
deviance(fit)
fit = lm(wage~jobclass, data=Wage)
deviance(fit)
fit = lm(wage~maritl+jobclass, data=Wage)
deviance(fit)

fit=gam(wage~maritl+jobclass+s(age,4), data=Wage)
deviance(fit)

##q8
set.seed(1)
rss=rep(NA, 10)
fits=list()
for (d in 1:10){
  fits[[d]] = lm(mpg~poly(displacement, d), data=Auto)
  rss[d] = deviance(fits[[d]])
}
rss
anova(fits[[1]], fits[[2]], fits[[3]], fits[[4]])

###q9
library(MASS)
attach(Boston)
lm.fit=lm(nox~poly(dis, 3), data=Boston)
summary(lm.fit)
