
# fit a logistic model for wage >250 and <=250 which corresponds 
#     to binomial response of 1 and 0 respectively
# we make predictions using predict function
# # since this logistic, the default type="link" in glm. 
fit=glm(I(wage>250)~poly(age,4), 
        data=Wage, 
        family=binomial)
preds=predict(fit, 
              newdata=list(age=age.grid), 
              se=TRUE)


# so pfit is created to equal the formula above for the preds$fit   
#     (note calling names(preds) will show the varibles available in the preds output)
# fit and se.fit are variables in the preds variable  (call names(preds) to see).  
# This line creates the two bands that are 2 standard errors from the fitted line
#     This predicts the actual values for the standard error lines using the 
#         second formula above. 

pfit = exp(preds$fit)/(1+exp(preds$fit))
se.bands.logit = cbind(preds$fit + 2*preds$se.fit, 
                       preds$fit - 2*preds$se.fit)
se.bands = exp(se.bands.logit)/(1+exp(se.bands.logit))


# plot the probability that the wage is greater than 250, given age on the x axis
# jitter creates blocks that show the density.  
#     "jitters" the values a little so observations with same value don't 
#           overlap so much (ie: thicker blocks show more people at that age).  
#           I(wage>250 is divided by 5 to allow the density blocks (highlighted 
#           in yellow below) to appear at top of the graph).  
#       The grey blocks at the top are people (and corresponding age) that make >250
# The pch"|" is the pipe which tells what symbol to apply to the blocks.
plot(age,I(wage>250), xlim=agelims, 
     type="n", 
     ylim=c(0, 0.2))
points(jitter(age), I((wage>250)/5), 
       cex=0.5, 
       pch="|", 
       col="darkgrey")


lines(age.grid, pfit, lwd=2, col="blue")
matlines(age.grid, se.bands, lwd=1, col="blue", lty=3)
