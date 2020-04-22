# use LOESS


agelims=range(age)
agelims
age.grid=seq(from=agelims[1], 
             to=agelims[2])


plot(age, wage, 
     xlim=agelims, 
     cex=0.5, 
     col="darkgrey")
title("Local Regression")

# loess creates a fit at span of 0.2 and 0.6
fit = loess(wage~age, span=0.2, data = Wage)
fit2 = loess(wage~age, span=0.6, data = Wage)

# plot: using age.grid and predicted fit values from age.grid for first fit above
lines(age.grid, 
      predict(fit, data.frame(age=age.grid)), 
      col="red", 
      lwd=2)
lines(age.grid, 
      predict(fit2, data.frame(age=age.grid)), 
      col="blue", 
      lwd=2)
legend("topright", 
       legend=c("Span=0.2", "Span=0.5"), 
       col=c("red", "blue"),
       lty=1, 
       wd=2, 
       cex=0.8)

# gets predicted value of when age (the x value) is 80.  
#   (this is for a local regression model)
predict(fitlr, data.frame(age=80))
