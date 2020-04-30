# TWO EXAMPLES IN THIS SCRIPT

# Holt's Linear Method Simple Exponential Smoothing

# can be used with trend data that is not seasonal 
# (but not with high frequency ie: 52 weeks or above)
# alpha is smoothing paramenter, beta controls the trend 
# component


# create a window with the time series specs 
# (NOTE: you don't have to do this.  Rather, you can 
# use the ts functionality to designate (see preparing 
# TS data tab for details)
air <- window(ausair,start=1990,end=2004)

# holt=function, alpha is smoothing parameter for level 
# (controls weight decay as observations get older), 
# beta is smoothing parameter for trend
fit1 <- holt(air, alpha=0.8, beta=0.2, initial="simple", h=5) 

# same as above but fits an exponetial fit instead of linear in the above line
fit2 <- holt(air, alpha=0.8, beta=0.2, initial="simple", exponential=TRUE, h=5) 
fit1$model$state
fitted(fit1)
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


plot(fit2$model$state)
