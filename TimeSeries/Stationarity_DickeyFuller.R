

Library(tseries)  # library needed for adf.test

flu_ts = ts(mydata_flu, frequency=52, start=c(2009,40))

# "stationary" tells are to set hypothesis test to test stationarity
# The null-hypothesis for an ADF test is that the data are 
# non-stationary (alternative hypothesis is data are stationary). 
# So large p-values are indicative of non-stationarity, and small 
# p-values suggest stationarity.   
flu_adf = adf.test(flu_ts, alternative="stationary")
