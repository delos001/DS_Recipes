library(splines)

agelims=range(age)
agelims
age.grid=seq(from=agelims[1], to=agelims[2])

fit2=lm(wage~ns(age, df=4), data=Wage)
pred2=predict(fit2, newdata = list(age=age.grid), se=TRUE)

plot(age, wage, col="gray")
lines(age.grid, pred2$fit, lwd=2)
lines(age.grid, pred2$fit + 2*pred2$se, lty="dashed")
lines(age.grid, pred2$fit - 2*pred2$se, lty="dashed")


dim(bs(age, knots = c(25, 40, 60)))

dim(bs(age, df=6))
attr(bs(age, df=6), "knots")
