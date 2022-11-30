# TWO EXAMPLES IN THIS SCRIPT

# Holt's Linear Method Simple Exponential Smoothing

# can be used with trend data that is not seasonal 
# (but not with high frequency ie: 52 weeks or above)
# alpha is smoothing paramenter, beta controls the trend 
# component

#----------------------------------------------------------
#----------------------------------------------------------
# EXAMPLE 1
#----------------------------------------------------------
#----------------------------------------------------------

# create a window with the time series specs 
# (NOTE: you don't have to do this.  Rather, you can 
# use the ts functionality to designate (see preparing 
# TS data tab for details)
air <- window(ausair,
              start=1990, end=2004)

# holt=function, alpha is smoothing parameter for level 
# (controls weight decay as observations get older), 
# beta is smoothing parameter for trend
fit1 <- holt(air, 
             alpha=0.8, beta=0.2, 
             initial="simple", 
             h=5) 

# same as above but fits an exponetial fit instead of linear in the above line
fit2 <- holt(air, 
             alpha=0.8, beta=0.2, 
             initial="simple",
             exponential=TRUE, 
             h=5) 

fit1$model$state  # give model results
fitted(fit1)   # predict function 
# gets the mean of fit1 (note that this linear so the 
# mean will be have slope of 1: horizontal line)
fit1$mean



fit3 <- holt(air, alpha=0.8, beta=0.2, damped=TRUE, initial="simple", h=5) 
plot(fit2, type="o", ylab="Air passengers in Australia (millions)", xlab="Year", 
     fcol="white", plot.conf=FALSE)
lines(fitted(fit1), col="blue") 
lines(fitted(fit2), col="red")
lines(fitted(fit3), col="green")
lines(fit1$mean, col="blue", type="o") 
lines(fit2$mean, col="red", type="o")
lines(fit3$mean, col="green", type="o")
legend("topleft", lty=1, col=c("black","blue","red","green"), 
   c("Data","Holt's linear trend","Exponential trend","Additive damped trend"))

# prints level and slope for fit2 which is the holt linear trend method
plot(fit2$model$state)



#----------------------------------------------------------
#----------------------------------------------------------
# EXAMPLE 2
#----------------------------------------------------------
#----------------------------------------------------------

livestock2 <- window(livestock,         # set time series limits
                     start = 1970, end = 2000)

# simple exponential smoothing (note: for non seasonal non trend data)
fit1 <- ses(livestock2)
fit2 <- holt(livestock2)  # linear holt
fit3 <- holt(livestock2,exponential=TRUE)  # exponential hold
fit4 <- holt(livestock2,damped=TRUE)       # damped hold
fit5 <- holt(livestock2,exponential=TRUE,damped=TRUE)  # exponential damped holt

fit1$model   # gets results of fit1
accuracy(fit1)           # training set
accuracy(fit1,livestock) # test set

# plots the level and trend components (a constant trend slope 
# indicates trend is linear and a decreasing slope indicates the 
# trend is leveling off
plot(fit2$model$state)
plot(fit4$model$state)

plot(fit3, type="o",    # plot fit 3
     ylab="Livestock, sheep in Asia (millions)", 
     flwd=1, 
     plot.conf=FALSE)

lines(window(livestock,start=2001), type="o") # lines have circles at data points
# draws lines for forecast values for each of the fitted models
lines(fit1$mean,col=2)
lines(fit2$mean,col=3)
lines(fit4$mean,col=5)
lines(fit5$mean,col=6)
legend("topleft", 
       lty=1, pch=1, col=1:6,
    c("Data","SES","Holt's","Exponential",
      "Additive Damped","Multiplicative Damped"))
