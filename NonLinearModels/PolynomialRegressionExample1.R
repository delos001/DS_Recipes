

# regression polynomial

library(ISLR)
attach(Wage)

# poly argument makes it so you don't have to spell out: age+age^2+age^3+age^4
# poly function also produces regression in which each variable polynomial is 
#     orthogonal (ie: it reduces colinearity).  
#     It forms a matrix in which each column is a linear combination of the 
#       variables age, age, age^2, age^3, age^4
fit=lm(wage~poly(age,4), 
       data=Wage)

coef(summary(fit))
coef(fit)
summary(fit)

# if you don't want the orthoginal matrix columns (like from code above), use raw=T.
#     this effects the coefficient values but does not affect the fitted values
fit2=lm(wage~poly(age, 4, raw=T), 
        data=Wage)

coef(summary(fit2))

# alternative method equivalent to fit2
fit2a=lm(wage~age+I(age^2)+I(age^3)+I(age^4), 
         data=Wage)
fit2b=lm(wage~cbind(age, age^2, age^3, age^4), 
         data=Wage)


# create min value and max value (range) of the age variable
# creates a sequence of numbers: min value (agelims[1])  to max value (agelims[2])
# create new var: predicted values based on the fit model.  
#   this uses new data to plug into the fit model output 
#     (age.grid sequence from above).  also adds standard error
# create new var:  Gives standard error bands: 
#     this adds 2 x standard error value to the predict fit value and 
#       subtracts 2 x standard error value from predicted fit value
agelims=range(age)
agelims
age.grid=seq(from=agelims[1], 
             to=agelims[2])
age.grid
preds=predict(fit, 
              newdata=list(age=age.grid), 
              se=TRUE)
se.bands=cbind(preds$fit + 2*preds$se.fit, 
               preds$fit-2*preds$se.fit)

par(mfrwo=c(1,2), 
    mar=c(4.5, 4.5, 1,1), 
    oma=c(0,0,4,0))
plot(age, wage, xlim=agelims, cex=0.5, col="darkgrey")
title("Degree-1 Polynomial", outer=T)
lines(age.grid, preds$fit, lwd=2, col="blue")
matlines(age.grid, se.bands, lwd=1, col="blue", lty=3)


# these two lines show that there is no meaningful difference between 
#   using the poly function (orthogonal column variables) described above, 
#   from the model that types out each varaible: age, age, age^2, age^3, age^4.  
# We see the maximum absolute value of the difference between the two is very 
#   small (nearly zero)
preds2 =predict (fit2 ,
                 newdata =list(age=age.grid),
                 se=TRUE)
max(abs(preds$fit - preds2$fit ))


# In performing a polynomial regression we must decide on the degree of the 
# polynomial to use. One way to do this is by using hypothesis tests. We now fit 
# models ranging from linear to a degree-5 polynomial and seek to determine the 
# simplest model which is sufficient to explain the relationship between wage 
# and age. We use the anova() function, which performs an analysis of variance 
# (ANOVA, using an F-test) in order to test the null hypothesis that a model M #
# variance 1 is sufficient to explain  the data against the alternative hypothesis 
# that a more complex modelM2 is required. In order to use the anova() function, 
# 1 and M2 must be nested models: the predictors in M1 must be a subset of the 
# predictors in M2. In this case, we fit five different models and sequentially 
# compare the simpler model to the more complex model.
fit.1 = lm(wage~age, data=Wage)
fit.2 = lm(wage~poly(age,2), data=Wage)
fit.3 = lm(wage~poly(age,3), data=Wage)
fit.4 = lm(wage~poly(age,4), data=Wage)
fit.5 = lm(wage~poly(age,5), data=Wage)

anova(fit.1, fit.2, fit.3, fit.4, fit.5)

# Explanation of output:
# The p-value comparing the linear Model 1 to the quadratic Model 2 is essentially 
# zero (<10−15), indicating that a linear fit is not sufficient. Similarly the p-value  
# comparing the quadratic Model 2 to the cubic Model 3 is very low (0.0017), so the 
# quadratic fit is also insufficient. The p-value comparing the cubic and degree-4  
# polynomials, Model 3 and Model 4, is approximately 5% while the degree-5 polynomial 
# Model 5 seems unnecessary because its p-value is 0.37. Hence, either a cubic or  a 
# quartic polynomial appear to provide a reasonable fit to the data, but lower- or 
# higher-order models are not justified.
# NOTE: ANOVA can also work if there are other variables in the model as well. 
# ex: fit .3= lm(wage∼education +poly(age ,3) ,data=Wage)
