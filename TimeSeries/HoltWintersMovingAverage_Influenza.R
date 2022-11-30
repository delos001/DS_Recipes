
# Simple exponential smoothing with HOLT WINTERS function
# NOTE: couldn't get this to work (see litle book of R for 
#		time series (electronic copy) for code
# See Little Book of R for Time Series (electronic copy for this code)

# not for use with seasonal or trend time series data
# the random fluctuation in the time series is roughly constant 
# in magnitude over time: probably appropriate to use additive 
# model so we can make forecast using simple exponential smoothing

# note: the "mydata" data set is seasonal so not appropriate for simple 
# exponential smoothing therefore, this code is for demonstration 
# purposes only

library(forecast)

mydata=read.csv(file.path("NCHSData52.csv"),sep=",")

mydata_ts=mydata[,3]

# create time series data set for weeks (freq=52)
mydata_ts=ts(mydata_ts, 
	     frequency=52, 
	     start=c(2009,40))  # starting at 2009, week 40.

plot.ts(mydata_ts)


# for simple exponential smoothing, beta and gamma must 
#	be false (without trend and without seasonal component)
# l.start: It is common in simple exponential smoothing to use 
# 	the first value in the time series as the initial value for the
#	level. For example, in the mydata time series, the first value 
# 	of 7.8 is found for week 40 of 2009.
mydata_exp_smooth = HoltWinters(mydata_ts, 
				eta=FALSE, 
				gamma=FALSE, 
				l.start=7.8)


# The output of HoltWinters() tells us that the estimated value of 
# the alpha parameter is about 0.999 for this data set. This is very
# close to 1, telling us that the forecasts are based on both recent 
# and less recent observations (although somewhat more weight is 
# placed on recent observations).
mydata_exp_smooth


# The forecasts made by HoltWinters() are stored in a named element of 
# this list variable called “fitted”,  (yhat values)
mydata_exp_smooth$fitted
plot(mydata_exp_smooth)

# As a measure of the accuracy of the forecasts, we can calculate the 
# sum of squared errors for the in-sample forecast errors, that is, the 
# forecast errors for the time period covered by our original time series.
mydata_exp_smooth$SSE

# predict (forecast) the values for future time periods you specify 
# (using h=52 in this case to predict 52 weeks in future since data 
# points are weekly)
mydata_exp_smooth_pred = forecast(mydata_exp_smooth, h=52)

mydata_exp_smooth_pred

# plots the predicted values for the timepoint you specify 
# (smaller grey area is the 80% prediction interval, larger grey area 
# is the 90% prediction area)
plot(mydata_exp_smooth_pred)

plot(forecast(mydata_exp_smooth, h=52))  # another way to plot


# calculate a correlogram of the in-sample forecast errors
acf(mydata_exp_smooth_pred$residuals, lag.max=20)


# To test whether there is significant evidence for non-zero correlations 
# at lags 1-20, we can carry out a Ljung-Box test. This can be done in R 
# using the “Box.test()”, function. The maximum lag that we want to look 
# at is specified using the “lag” parameter in the Box.test() function. 
# For example, to test whether there are non-zero autocorrelations at lags 
# 1-20, for the in-sample forecast errors for London rainfall data, we type:
#OUT:
#Box-Ljung test
# data: rainseriesforecasts2$residuals
# X-squared = 17.4008, df = 20, p-value = 0.6268

Box.test(mydata_exp_smooth_pred$residuals, 
	 lag=20, type="Ljung-Box")
# Here the Ljung-Box test statistic is 17.4, and the p-value is 0.6, so 
# there is little evidence of non-zero autocorrelations in the in-sample 
# forecast errors at lags 1-20.

