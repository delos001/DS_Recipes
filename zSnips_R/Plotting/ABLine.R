

# reates scatter plot with 2 diff variables
# plots a line with intercept of 1 and slope of 2  
#    (note you have to run these together to get the line to appear)
plot(x,y)
ablines(1,2)


# plots 2 variables (note: these are from: library(ISLR) package 
#     and the file name is Boston
# creates a least squares regression line of the lm.fit model.  
#     the lwd is the line weight
plot(lstat,medv)
abline(lm.fit, lwd=2, col="red")
