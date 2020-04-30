

# The holt winters seasoanl additive method is preferred when 
#   the seasonal variations are roughly contstant through the season
# The holt winters seasonal multiplicative method is preferred when 
#   the seasonal variations are changing proportional to the level 
#   of the series (ie: as time changes, season magnitude changes)



aust <- window(austourists,start=2005)
fit1 <- hw(aust,seasonal="additive")
fit2 <- hw(aust,seasonal="multiplicative")

plot(fit2,ylab="International visitor night in Australia (millions)",
     type="o", fcol="white", xlab="Year")
lines(fitted(fit1), col="red", lty=2)
lines(fitted(fit2), col="green", lty=2)
lines(fit1$mean, type="o", col="red")
lines(fit2$mean, type="o", col="green")
legend("topleft",lty=1, pch=1, col=1:3, 
  c("data","Holt Winters' Additive","Holt Winters' Multiplicative"))

states <- cbind(fit1$model$states[,1:3],fit2$model$states[,1:3])
colnames(states) <- c("level","slope","seasonal","level","slope","seasonal")
plot(states, xlab="Year")
fit1$model$state[,1:3]
fitted(fit1)
fit1$mean
