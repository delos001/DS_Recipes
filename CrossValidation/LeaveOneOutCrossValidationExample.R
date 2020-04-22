


# NOTE: this is basic formula but is not efficient and slow.  
#   Better to use the line below:

# gets ISLR data
# gets boot function

require(ISLR)
require(boot)
glm.fit=glm(mpg~horsepower, data=Auto)
cv.glm(Auto, glm.fit)$delta


#----------------------------------------------------------
# EXAMPLE 2

# takes the fit as the argument (the fit of a glm model for example)
# sets vector h: "influence" extracts the element h from the residual fit. 
#     (note h is leverage reflecting the amount an observation influences its own fit).  
#     NOTE $h is what tells it to get the h value
# this computes the quantity of the formula above.  "residuals" gives you 
#     the residuals from the fit
loocv=function(fit){
	h=lm.influence(fit)$h
	
	mean((residuals(fit)/(1-h))^2)
}
loocv(glm.fit)


cv.error=rep(0,5)
degree=1:5
for(d in degree){
	glm.fit=glm(mpg~poly(horsepower, d), data=Auto)
	cv.error[d]=loocv(glm.fit)  # set cv.error to hold results of loocv function using glm.fit object
}
plot(degree, cv.error, type="b")



#----------------------------------------------------------
# EXAMPLE 3
# Uses boot function

# glm performs linear regrssion when the "family=binomial" 
#   argument is left out
# produces regression results (gives AIC rather than Rsqr 
#   since it is generalized linear mondel)
# cv.glm: This function calculates the estimated K-fold 
#   cross-validation prediction error for generalized linear models
# cv.err$delta vector contain the cross-validation results.  
#    For this example, the numbers are identical and correspond to LOOCV
library(boot)
glm.fit=glm(mpg~horsepower, data=Auto)
summary(glm.fit)
cv.err = cv.glm(Auto, glm.fit)
cv.err$delta
