# THERE ARE TWO EXAMPLE IN THIS SCRIPT


#----------------------------------------------------------
#----------------------------------------------------------
# EXAMPLE 1
#----------------------------------------------------------
#----------------------------------------------------------
# A variation from Holt’s linear trend method is achieved by 
# allowing the level and the slope to be multiplied rather than added

# alpha is smoothing paramenter, beta controls the trend component



# an exponential fit, but this one is damped to control a constant 
# exponential growth or decline trend. (note graph below with project lines)
fit3 <- holt(air, alpha=0.8, beta=0.2, damped=TRUE, initial="simple", h=5) 

# plots fit2 (see HW linear example for the fit2 code)
plot(fit2, 
     type="o", 
     ylab="Air passengers in Australia (millions)", 
     xlab="Year", 
     fcol="white")

# adds line of eac fit in the plot to compare on same graph
lines(fitted(fit1), col="blue") 
lines(fitted(fit2), col="red")
lines(fitted(fit3), col="green")

# these plot the mean fits on the graph
lines(fit1$mean, col="blue", type="o") 
lines(fit2$mean, col="red", type="o")
lines(fit3$mean, col="green", type="o")

legend("topleft", 
       lty=1, 
       col=c("black","blue","red","green"), 
       c("Data","Holt's linear trend",
         "Exponential trend","Additive damped trend"))



#----------------------------------------------------------
#----------------------------------------------------------
# EXAMPLE 2
#----------------------------------------------------------
#----------------------------------------------------------

# This is an example comparing exponential, damped, and exponential damped

fit1 <- ses(livestock2)
fit2 <- holt(livestock2)
fit3 <- holt(livestock2,exponential=TRUE)
fit4 <- holt(livestock2,damped=TRUE)
fit5 <- holt(livestock2,exponential=TRUE,damped=TRUE)

fit1$model
accuracy(fit1) 
accuracy(fit1,livestock) 

plot(fit2$model$state)
plot(fit4$model$state)

# compares multiple modesl from the lines above and from the 
# HW linear trend component example
plot(fit3, type="o", 
     ylab="Livestock, sheep in Asia (millions)", 
     flwd=1, 
     plot.conf=FALSE)

lines(window(livestock,start=2001), type = "o")
lines(fit1$mean,col=2)
lines(fit2$mean,col=3)
lines(fit4$mean,col=5)
lines(fit5$mean,col=6)
legend("topleft", lty=1, 
       pch=1, col=1:6,
       c("Data","SES","Holt's","Exponential",
         "Additive Damped","Multiplicative Damped"))
