library(splines)

agelims=range(age)
agelims
age.grid=seq(from=agelims[1], 
             to=agelims[2])

# regression model on wage.  the "ns" argument generates the 
# entire matrix of basis functions for splines with specified 
# set of knots.  Cubic splines are the default

fit2=lm(wage~ns(age, df=4), data=Wage)
pred2=predict(fit2, newdata = list(age=age.grid), se=TRUE)

plot(age, wage, col="gray")
# creates predicted line base on age.grid, and predicted fit lines from code above
lines(age.grid, pred2$fit, lwd=2)
lines(age.grid, pred2$fit + 2*pred2$se, lty="dashed")
lines(age.grid, pred2$fit - 2*pred2$se, lty="dashed")

# gives the dimensions of data after applying 3 knots 
#   (3000 rows with 6 basis functions from 3 knots)  output: [1] 3000    6
dim(bs(age, knots = c(25, 40, 60)))

# Recall that a cubic spline with three knots has seven degrees of freedom; 
#     these degrees of freedom are used up by an intercept, plus 6 basis functions.

# this gives the same results as line above but since
# gives the attribute of the bs function using 6 df and shows where R has 
#     assigned the knots corresponding to 25th, 50th, and 75th percentile: 
dim(bs(age, df=6))
attr(bs(age, df=6), "knots")
# output:
#  25%   50%   75% 
#  33.75 42.00 51.00 
# The function bs() also has a degree argument, so we can fit splines of any degree, 
#     rather than the default degree of 3 (which yields a cubic spline)

# gets the predicted value of when age (the x value) is 80.  
#   this is for a natural regression spline)
predict(fit2, data.frame(age=80))
