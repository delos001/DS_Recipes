# uses pls() function
# uses pls library
# NOTE: make sure missing values are removed, imputed, etc before performing PCR
set.seed(1)
pls.fit=plsr(Salary~., data=Hitters, subset=train, scale=TRUE, validation="CV")
summary(pls.fit)

validationplot(pls.fit, val.type = "MSEP")


# the lowest MSEP occurs at 2 so predict the results on test data for ncomp=2
pls.pred=predict(pls.fit, x[test,], ncomp=2)
mean((pls.pred-y.test)^2)


pls.fit=plsr(Salary~., data=Hitters, scale=TRUE, ncomp=2)
summary(pls.fit)

# in this example,  
# the percentage of variance in Salary that the two-component PLS fit 
#     explains, 46.40%, is almost as much as that explained using the 
#     final seven-component model PCR fit, 46.69.  
# This is because PCR only attempts to maximize the amount of variance 
#   explained in the predictors, while PLS searches for directions that 
#   explain variance in both the predictors and the response.
