

# uses pcr() function
# uses pls library
# make sure missing values are removed, imputed, etc before performing PCR


note # you have to use set seed to reproduce results as this is used 
#   to partition the train test for cross validation below runs 
#   pcr on salary for all predictor variables (note that pcr doesn't 
#   actually consider the dependent variable so you are just specifying 
#   salary here to exclude from the pcr.  Scale=TRUE standardizes each 
#   predictor (using eqn 6.6 of text) so the scale on which each variable 
#   is measured will not have an effect.
# Setting validation=CV causes pcr to compute the 10-fold cross validation 
#   error for each posssible value of M (# of principal components used)
library(pls)
set.seed(2)
pcr.fit=pcr(Salary~., data=Hitters, scale=TRUE, validation="CV")




summary(pcr.fit)

validationplot(pcr.fit, val.type = "MSEP")


set.seed(1)
pcr.fit=pcr(Salary~., data=Hitters, subset=train, scale=TRUE, validation="CV")
validationplot(pcr.fit, val.type="MSEP")
MSEP(pcr.fit)


pcr.pred=predict(pcr.fit, x[test,], ncomp=7)
mean((pcr.pred-y.test)^2)

# here we fit PCR on the full data set using M=7 principal components 
#     identified by the cross validation.  
# we use x and y here (these were calculated previously 
#   (see ridge regression tab) for additional info, but the calculation is:
# x=model.matrix(Salary~., Hitters)[,-1]
# y=Hitters$Salary
pcr.fit=pcr(y~x, scale=TRUE, ncomp=7)
summary(pcr.fit)




plot(pcr.fit, ncomp=1:7)

