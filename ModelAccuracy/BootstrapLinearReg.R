# IN THIS FILE:
# Accuracy of linear regression example
# Accuracy of quadratic model


#----------------------------------------------------------
#----------------------------------------------------------
# Accuracy of a linear regression model
#----------------------------------------------------------
#----------------------------------------------------------
# example using bootstrap to find the variability of 
#   coefficient estimates Bo and B1 (intercept and slope terms)

# create a function that take data set and the indices for the observations
#     the function returns the coefficients (coef argument) of the linear model: 
#         mgp=dep var, horsepower=predictor, 
#         data=the data set you want and subset by the index number.  
#     NOTE: the "return" part if not necessary if you are going to use the boot 
#         function (see quadratic ex below)

boot.fn = function(data, index){
  return (coef(lm(mpg~horsepower, data=data, subset=index)))
} 
boot.fn(Auto, 1:392)  # calls function: uses auto data for index 1 through 392

set.seed(1)
boot.fn(Auto, sample(392, 392, replace=T))


# computes SE of 1,000 boostrap estimates for intercept and slope terms
boot(Auto, boot.fn, 1000)
# the bootstrap estimate for standard error of the intercept (SE Bo) is 
#     0.860 and the stadard error of the slope (SE B1) is 0.0074.  
#     This tells us that the value for the intercept is 39.94 and the 
#         value for the slope is -0.158  based on the bootstrap method


# we compare the bootstap results above to how we can calculate the SE of the of the lm
# note: $coef will tell R to just give coefficient estimates rather 
#     than all the summary data (ie: Rsqare, Fstatistic, etc)

summary(lm(mpg~horsepower, data=Auto))
summary(lm(mpg~horsepower, data=Auto))$coef

# We see that some of results are similar, others are different (ie: the standard errors)
# NOTE: this is because the standard formulas that are utilized in the summary 
#   function have assumptions: the variance estimate relies on the linear model 
#   being the correct model type (ie not polynomial).  
#   This also assumes all the xi value are fixed and that all the variability 
#   comes from the variation in the errors, ei, which is not realistic assumption.  
#   Bootstrap method does not rely on these assumptions so it is likely to give a more 
#     accurate estimateof the standard errors than the summary function




#----------------------------------------------------------
#----------------------------------------------------------
# Accuracy of a quadratic model
#----------------------------------------------------------
#----------------------------------------------------------
boot.fn = function(data, index){
  coefficients(lm(mpg~horsepower+I(horsepower^2), data=data, subset=index))
}
set.seed(1)
boot(Auto, boot.fn, 1000)
