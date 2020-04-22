

library(gam)

# the s tells the gam function to use a smoothing spline and 
# the specify the number of degrees of freedom (4 for year, 5 for age)
# all the terms for equation 7.16 are fit simultaneously taking 
#     each other into account to explain the response
gam.m3 = gam(wage~s(year, 4) + 
             s(age,5) + 
             education, 
             data = Wage)

# this will plot the gam model from above.  
par(mfrow=c(1,3))
plot(gam.m3, se=TRUE, col="blue")
par(mfrow=c(1,1))
summary(gam.m3)

# a GAM that excludes year (M1)
gam.m1 = gam(wage~s(age,5) + 
             education, 
             data = Wage)

# a GAM that uses a linear function of year (M2)
gam.m2 = gam(wage~year+s(age,5) + 
             education, 
             data=Wage)

# ANOVA testing to determine which of 3 models is best
# line 2 shows compelling evidence that GAM with a linear 
#   function of year is better than the GAM that doesn't have year.  
#   However, line 3 shows no evidence that a non-linear function 
#       of year is needed (pvalue=0.349)
anova(gam.m1, gam.m2, gam.m3, test="F")
# output:
#Analysis of Deviance Table
#Model 1: wage ~ s(age, 5) + education
#Model 2: wage ~ year + s(age, 5) + education
#Model 3: wage ~ s(year, 4) + s(age, 5) + education
#  Resid. Df Resid. Dev Df Deviance       F    Pr(>F)    
#1      2990    3711731                                  
#2      2989    3693842  1  17889.2 14.4771 0.0001447 ***
#3      2986    3689770  3   4071.1  1.0982 0.3485661 


# Summary pvalues for year and age correspond to a null hypothesis of a 
# linear relationship vs. the alternative of a non-linear relationship.  
# A large pvalue for GAM3 (which uses a nonlinear relationship for year) 
# indicates that a linear function is more appropriate than the non-linear 
# (this is also seen in the ANOVA above)
summary(gam.m3)
deviance(gam.m1)
deviance(gam.m2)

# predict from gam object
preds=predict(gam.m2, newdata=Wage)
# we can use local regression fits as building blocks in a GAM using the lo function
gam.lo=gam(wage~s(year, df=4) + 
           lo(age, span=0.7) + 
           education, 
           data=Wage)

par(mfrow=c(1,3))
plot.gam(gam.lo, se=TRUE, col="red")
par(mfrow=c(1,1))

# uses the lo function to create interactions before calling the gam() function: 
#     fits a two term model in which the 1st term is an interactions between year 
#     and age, fit by a local regression surface.
gam.lo.i=gam(wage~lo(year, 
                     age, 
                     span=0.5) + 
             education, 
             data=Wage)


library(akima)  # calls the akima library so you can plot a 2-dimensional surface
par(mfrow=c(1,2))  # plot produces a 2 plot matrix
plot(gam.lo.i)  
par(mfrow=c(1,1))
