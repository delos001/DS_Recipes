

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
deviance(gam.m1)
deviance(gam.m2)

preds=predict(gam.m2, newdata=Wage)
gam.lo=gam(wage~s(year, df=4) + lo(age, span=0.7) + education, data=Wage)

par(mfrow=c(1,3))
plot.gam(gam.lo, se=TRUE, col="red")
par(mfrow=c(1,1))

gam.lo.i=gam(wage~lo(year, age, span=0.5)+education, data=Wage)


library(akima)
par(mfrow=c(1,2))
plot(gam.lo.i)
par(mfrow=c(1,1))
