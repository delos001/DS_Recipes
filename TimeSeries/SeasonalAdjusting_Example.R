
# If you have a seasonal time series that can be described 
# using an additive model, you can seasonally adjust the time 
# series by estimating the seasonal component, and subtracting 
# the estimated seasonal component from the original time series. 
# We can do this using the estimate of the seasonal component 
# calculated by the “decompose()” function.

library(forecast)
library(TTR)

mydata=read.csv(file.path("NCHSData52.csv"),sep=",")

mydata_ts=mydata[,3]
mydata_ts=ts(mydata_ts, frequency=52, start=c(2009,40))

plot.ts(mydata_ts)

mydata_decomp = decompose(mydata_ts)
mydata_decomp$seasonal

# subracts seasonal comp from actual value, yt, to get seasonally adjusted
mydata_season_adjust = mydata_ts - mydata_decomp$seasonal

plot(mydata_season_adjust)
