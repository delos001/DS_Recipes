
# A variation from Holt’s linear trend method is achieved by 
# allowing the level and the slope to be multiplied rather than added

# alpha is smoothing paramenter, beta controls the trend component



# an exponential fit, but this one is damped to control a constant 
# exponential growth or decline trend. (note graph below with project lines)
fit3 <- holt(air, alpha=0.8, beta=0.2, damped=TRUE, initial="simple", h=5) 

plot(fit2, type="o", ylab="Air passengers in Australia (millions)", xlab="Year", 
     fcol="white")
lines(fitted(fit1), col="blue") 
lines(fitted(fit2), col="red")
lines(fitted(fit3), col="green")
lines(fit1$mean, col="blue", type="o") 
lines(fit2$mean, col="red", type="o")
lines(fit3$mean, col="green", type="o")
legend("topleft", lty=1, col=c("black","blue","red","green"), 
   c("Data","Holt's linear trend","Exponential trend","Additive damped trend"))

