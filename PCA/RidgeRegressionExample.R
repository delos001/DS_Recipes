
#---------------------------------------------------------------------------------
# EXAMPLE 1
# glmet package is needed to perform ridge regression
# StatsLearning Lect10 R modelselection D 111213
# Ridge regression, relative to least squares regression is 
#   Less flexible and hence will give improved prediction 
#   accuracy when its increase in bias is less than its decrease in variance.


library(glmnet)

# NOTE: you need to do this because glmnet doesn't have typical 
#   functionality like lm(), so you need to do glmnet on x and y 
#   variable names (rather than col header names)
# NOTE: model.matrix is useful for creating x because it creates matrix 
#   of all 19 variables but also converts qualitative variables to dummy variables

x=model.matrix(Salary~., Hitters)[,-1]
y=Hitters$Salary


# grid creates the values that will be used for lambda later. 
#   here, it creates 100 equally spaced values from 10 to -2
# create ridge regression model: uses x, y.  alpha of 0 is for ridge regression, 
#   alpha of 1 is lasso regression.  lamda is all the values created in line above
# NOTE: glmnet will perform regression for default lambda values if not specified.  
#   However, using the grid function, we have implemented the fuction over values 
#   ranging from lambda = 10^10 to lambda=10^-2, covering the full range of scenarios 
#   from the null model containing only the intercept, to the least squares fit.
# NOTE: the glmnet() function standardizes the variables so that they are on the same scale. 
#   To turn off this default setting, use the argument standardize=FALSE.
grid=10^seq(10,-2, length=100)
ridge.mod=glmnet(x,y,alpha=0, lambda=grid)

dim(coef(ridge.mod))


ridge.mod$lambda[50]
# NOTE: We expect the coefficient estimates to be much smaller, in terms of l2 norm, 
#   when a large value of λ is used, as compared to when a small value of λ is used.
coef(ridge.mod)[,50]


sqrt(sum(coef(ridge.mod)[-1,50]^2))

predict(ridge.mod, s=50, type="coefficients")[1:20,]



#-----------------------------------------------------------------------------------------
# EXAMPLE 2
set.seed(1)
train=sample(1:nrow(x), nrow(x)/2)
test=(-train)
y.test=y[test]

ridge.mod=glmnet(x[train,], 
                 y[train], 
                 alpha=0,   # the alpha of zero tell R to do ridge regression instead of lasso
                 lambda=grid, 
                 thresh=1e-12)   # thresh is a convergence threshold




ridge.pred=predict(ridge.mod, 
                   s=4,     # s=4 is the number of lambda values
                   newx=x[test,])

mean((ridge.pred-y.test)^2)

# predicts the values with a very high lambda (s=10^10). 
# This is like fitting a model with just an intercept. 
# So we are testing whether the model above is better or 
#   worse than a model with no variables.  
#   (this is important to compare to see if you model is any good)
ridge.pred=predict(ridge.mod, s=1e10, newx=x[test,])

mean((ridge.pred-y.test)^2)


ridge.pred=predict(ridge.mod, s=0, newx=x[test,], exact=T)



mean((ridge.pred-y.test)^2)
