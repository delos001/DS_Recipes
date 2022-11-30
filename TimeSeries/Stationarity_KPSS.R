
# Another unit root test is the Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test

library(tseries)

flu_ts = ts(mydata_flu, frequency=52, start=c(2009,40))


# This reverses the hypotheses, so the null-hypothesis is that the 
# data are stationary. In this case, small p-values (e.g., less than 
# 0.05) suggest that differencing is required.

flu_kpss = kpss.test(flu_ts)
