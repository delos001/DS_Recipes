library(splines)

agelims=range(age)
agelims
age.grid=seq(from=agelims[1], to=agelims[2])

plot(age, wage, xlim=agelims, cex=0.5, col="darkgrey")
title("Smoothing Spline")
fit=smooth.spline(age, wage, df=16)

fit2=smooth.spline(age, wage, cv=TRUE)
fit2$df

lines(fit, col="red", lwd=2)
lines(fit2, col="blue", lwd=2)
legend("topright", legend=c("16DF", "6.8DF"), col=c("red", "blue"), lty=1, lwd=2, cex=0.8)
