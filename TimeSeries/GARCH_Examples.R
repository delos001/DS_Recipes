

# http://shishirshakya.blogspot.com/2015/07/garch-model-estimation-backtesting-risk.html
# https://www.r-bloggers.com/a-practical-introduction-to-garch-modeling/

#----------------------------------------------------------
# BASIC EXAMPLE 1
gspec.ru <- ugarchspec(mean.model=list(
      armaOrder=c(0,0)), distribution="std")
gfit.ru <- ugarchfit(gspec.ru, sp5.ret[,1])
coef(gfit.ru)

plot(sqrt(252) * gfit.ru$fit$sigma, type='l')  # plot in-sample volatility estimates


#----------------------------------------------------------
# BASIC EXAMPLE 2
# requires Rmetrics suite
gfit.fg <- garchFit(data=sp5.ret[,1], cond.dist="std")
coef(gfit.fg)

plot(sqrt(252) * gfit.fg$sigma.t, type="l")  # plot in-sample volatility estimates


#----------------------------------------------------------
# BASIC EXAMPLE 3
gfit.ts <- garch(sp5.ret[,1])  # It is restricted to the normal distribution
coef(gfit.ts)

plot(sqrt(252) * gfit.ts$fitted.values[, 1], type="l")  # plot in-sample volatility estimates


#----------------------------------------------------------
# BASIC EXAMPLE 4
# This package fits an EGARCH model with t distributed errors
gest.te <- tegarch.est(sp5.ret[,1])
gest.te$par

gfit.te <- tegarch.fit(sp5.ret[,1], gest.te$par)

# The plotting function is pp.timeplot is an indication that 
# the names of the input returns are available on the output — 
# unlike the output in the other packages up to here.
pp.timeplot(sqrt(252) * gfit.te[, "sigma"])

