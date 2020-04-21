# glmet package is needed to perform ridge regression
# NOTE: the lasso process and valiation/cross validation of 
#   lasso is the same as ridge regression so see the Ridge regression 
#   for additional syntax
# Lasso, relative to least squares regression is Less flexible and 
#   hence will give improved prediction accuracy when its increase in 
#   bias is less than its decrease in variance.

library(glmnet)

x=model.matrix(Salary~., Hitters)[,-1]

y=Hitters$Salary


# grid creates the values that will be used for lambda later. 
# here, it creates 100 equally spaced values from 10 to -2
# create ridge regression model: uses x, y.  
# alpha of 0 is for ridge regression, alpha of 1 is lasso regression.  
# lamda is all the values created in line above
# NOTE: glmnet will perform regression for default lambda values if not specified.  
#   However, using the grid function, we have implemented the fuction over 
#   values ranging from lambda = 10^10 to lambda=10^-2, covering the full 
#   range of scenarios from the null model containing only the intercept, 
#   to the least squares fit.
# NOTE: the glmnet() function standardizes the variables so that they are 
#   on the same scale. To turn off this default setting, use the argument 
#   standardize=FALSE.
grid=10^seq(10,-2, length=100)
ridge.mod=glmnet(x,y,alpha=1, lambda=grid)


lasso.mod=glmnet(x[train,], y[train], alpha=1, lambda=grid)
plot(lasso.mod)

cv.out=cv.glmnet(x[train,], y[train],alpha=1)
plot(cv.out)

# gets the position of the best lambda value (the value that has the lowest test error)
bestlam=cv.out$lambda.min
# predicts the coefficents using the best lambda value
lasso.pred=predict(lasso.mod, s=bestlam, newx=x[test,])
mean((lasso.pred-y.test)^2)


# you now repeat the lasso on the full data set
out=glmnet(x,y,alpha=1, lambda=grid)
lasso.coef=predict(out, type="coefficients", s=bestlam)[1:20,]
lasso.coef


# IMPORTANT: example to create a matrix for the prediction function 
#   when there is no dependent variable to add
#   xtest=model.matrix(~.,data.test.std)
