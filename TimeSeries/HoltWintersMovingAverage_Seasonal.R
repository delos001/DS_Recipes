

# The holt winters seasoanl additive method is preferred when 
#   the seasonal variations are roughly contstant through the season
# The holt winters seasonal multiplicative method is preferred when 
#   the seasonal variations are changing proportional to the level 
#   of the series (ie: as time changes, season magnitude changes)

# NOTE: this won't work with weekly data (frequency=52...gives error 
#    that frequency is too high)


# specify time series start stop or use the ts function 
# (see preparing TS data)
aust <- window(austourists, start=2005)

fit1 <- hw(aust, seasonal = "additive")  # holtwinters for seasonal additive
fit2 <- hw(aust, seasonal = "multiplicative") # holtwinters for seasonal multiplicative

# lot the holt winters smooth data (from model 2)
plot(fit2,
     ylab = "International visitor night in Australia (millions)",
     xlab = "Year",
     type = "o", fcol = "white")

lines(fitted(fit1), col="red", lty=2)
lines(fitted(fit2), col="green", lty=2)
lines(fit1$mean, type="o", col="red")
lines(fit2$mean, type="o", col="green")
legend("topleft",
       lty=1, pch=1, col=1:3, 
       c("data","Holt Winters' Additive",
         "Holt Winters' Multiplicative"))

# this section of code will give you the level, slope, and seasonal 
# component for both fittted models
states <- cbind(fit1$model$states[,1:3], 
                fit2$model$states[,1:3])
colnames(states) <- c("level", "slope", "seasonal",
                      "level", "slope", "seasonal")

plot(states, xlab="Year")
fit1$model$state[,1:3]

fitted(fit1)
fit1$mean
