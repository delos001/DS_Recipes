library(splines)

agelims=range(age)
agelims
age.grid=seq(from=agelims[1], 
             to=agelims[2])

plot(age, wage, 
     xlim=agelims, c
     ex=0.5, 
     col="darkgrey")
title("Smoothing Spline")
# creates variable to store results of smooth spline on age vs wage for 16 degrees of freedom
fit=smooth.spline(age, 
                  wage, 
                  df=16)

# NOTE: the smooth.spline determines which lambda values leads to 16 degrees of freedom
# creates second variable to store the results of smooth spline  
#     on age vs. wage using cross validation 
# provides the degrees of freedom from the cross valiation procedure.  
# The result here is the model with the optimal degrees of freedom 
#     (ie: determines the lambda value that gives 6.8 df)
fit2=smooth.spline(age,
                   wage, 
                   cv=TRUE)
fit2$df

lines(fit, col="red", lwd=2)
lines(fit2, col="blue", lwd=2)
legend("topright", 
       legend=c("16DF", "6.8DF"), 
       col=c("red", "blue"), 
       lty=1, lwd=2, 
       cex=0.8)

# gets the predicted value of when age (the x value) is 80.  
#   (this is for a smoothing spline)
fit4$y[fit4$x==80]
