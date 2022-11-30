
#----------------------------------------------------------------------
# BASIC SYNTAX
# provides the residual for each observation
# gives the leverage of each observation
# give the studentized residual for each observation
# calculates the influence of each observation

# *note: you would put the model name in the parenthesis.  
#   ie: resid(lm.fit) where lm.fit is linear model 

resid() 
hatvalues() 
rstudent() 
cooks.distance() 

which.max(rstudent(lm.fit3))
max(rstudent(lm.fit3))


#----------------------------------------------------------------------
# PREDICTED VS RESIDUAL PLOT
plot(predict(lm.fit10e), rstudent(lm.fit10e))


#----------------------------------------------------------------------
PLOT FIT MODEL
plots the following: 
#   residual vs. fitted (with trend curve), 
#   QQ plot, sqr(stand residuals) vs. fitted val with trend curve, and 
#   standardized residuals vs. leverage with trend curve

par(mfrow=c(2,2))
plot(lm.fit10e)
par(mfrow=c(1,1))
