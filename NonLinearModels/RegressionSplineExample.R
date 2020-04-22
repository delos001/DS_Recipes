

library(splines)

agelims=range(age)
agelims
age.grid=seq(from=agelims[1], to=agelims[2])

# regression model on wage.  
# the "bs" argument generates the entire matrix of basis functions 
#     for splines with specified set of knots.  
# Cubic splines are the default
fit=lm(wage~bs(age, knots=c(25, 40, 60)), data = Wage)
# get predicted values using derived age.grid data and include standard errors
pred=predict(fit, newdata=list(age=age.grid), se=TRUE)

plot(age, wage, col="gray")
lines(age.grid, pred$fit, lwd=2)
lines(age.grid, pred$fit + 2*pred$se, lty="dashed")
lines(age.grid, pred$fit - 2*pred$se, lty="dashed")

# gives the dimensions of data after applying 3 knots 
#   (3000 rows with 6 basis functions from 3 knots)  output: [1] 3000    6
# Recall that a cubic spline with three knots has seven degrees of freedom; 
#   these degrees of freedom are used up by an intercept, plus six basis functions.)

dim(bs(age, knots = c(25, 40, 60)))

dim(bs(age, df=6))
# gives the attribute of the bs function using 6 df and shows where R has 
# assigned the knots corresponding to 25th, 50th, and 75th percentile: 
# output:
#   25%   50%   75% 
#   33.75 42.00 51.00 

attr(bs(age, df=6), "knots")
# The function bs() also has a degree argument, so we can fit splines of any degree, 
#   rather than the default degree of 3 (which yields a cubic spline)

# gets the predicted value of when age (the x value) is 80.  (this is for a cubic regression spline)
predict(fit, data.frame(age=80))
