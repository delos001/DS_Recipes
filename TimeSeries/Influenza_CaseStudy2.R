library(TTR)
library(tseries)
library(forecast)

mydata = read.csv(file.path("NCHSData52.csv"), 
                  sep = ",", 
                  header = TRUE)

mydata_flu = mydata$Influenza.Deaths

# turn your data into a time series formatted data set
flu_ts = ts(mydata_flu, frequency=52, 
            start=c(2009,40))

plot.ts(flu_ts)

#seasonal differencing

plot(diff(log(flu_ts),52), 
     xlab="Year", 
     ylab="Annual Changes in Flu Deaths (log scale)")

# seasonal differencing of the log of your data 
# (log used if variance is high across date range).  
# 52 is the frequency to difference (ie: for each time point, 
# it goes back 52 weeks and subtracts that number from each 
# time point.)
# Dickey Fuller test to see if the data is stationary
flu_adf = adf.test(flu_ts, 
                   alternative="stationary")
flu_adf
#result: Dickey-Fuller = -5.6284, Lag order = 7, p-value = 0.01

# like dickey fuller, tests for stationarity
flu_kpss = kpss.test(flu_ts)
flu_kpss


# This code will automatically difference the data 
# (regular differencing and seasonal) based on the nsdiffs 
# and ndiffs function
ns = nsdiffs(flu_ts)
if (ns > 0) {
  ns_store = diff(flu_ts, lag=frequency(flu_ts), differences=ns)
} else {
  ns_store = flu_ts
}

nd = ndiffs(flu_ts)
if(nd > 0) {
  nd_store = diff(ns_store, differences=nd)
}

# This is your new data that has been differenced  
# (NOTE: this is manuall differencing if you want to 
# manually do it. auto.arima will difference it for you too)
nd
ns

Acf(flu_ts)
Pacf(flu_ts)
#ARIMA
#################################### 
#non-differenced data

flu_arima = auto.arima(flu_ts, seasonal=TRUE)
plot(forecast(flu_arima, h=52))

# Acf and PACF plot to see if data is stationary
Acf(flu_ts)
Pacf(flu_ts)

#differenced data
# this section of code manually differences the data based on 
# the number of differences you want it to make  
since the frequency is specified, this is seasonal differencing.
flu_seas_diff1 = diff(flu_ts, lag=frequency(flu_ts), differences=1)
plot(flu_seas_diff1, main="Seasonal difference = 1")
flu_seas_diff2 = diff(flu_ts, lag=frequency(flu_ts), differences=2)
plot(flu_seas_diff2, main="Seasonal difference = 2")
flu_seas_diff3 = diff(flu_ts, lag=frequency(flu_ts), differences=3)
plot(flu_seas_diff3, main="Seasonal difference = 3")
flu_seas_diff4 = diff(flu_ts, lag=frequency(flu_ts), differences=4)
plot(flu_seas_diff4, main="Seasonal difference = 4")

# plot the acf plots for each difference
Acf(flu_seas_diff1)
Acf(flu_seas_diff2)
Acf(flu_seas_diff3)
Acf(flu_seas_diff4)

#the above shows seasonal differencing is not work so taking log
# since there are zeros in the data, when you take the log, at 
# 1 then subtract log(1) back out later 
# note: taking the log reduces variance in the data over time
log_flu_ts = log(flu_ts+1)-log(1)
plot(log_flu_ts, xlab="Year", ylab="Annual Changes in Flu Deaths (log scale)",
     main="Log transformed Influenza Deaths 2009 to 2017")


# this is repeating the above code on the log transformed data
flu_adf = adf.test(log_flu_ts, alternative="stationary")
flu_adf
#result: Dickey-Fuller = -6.5392, Lag order = 7, p-value = 0.01

flu_kpss = kpss.test(log_flu_ts)
flu_kpss


# again, this code will automate the differencing
ns = nsdiffs(log_flu_ts)
if (ns > 0) {
  ns_store = diff(log_flu_ts, lag=frequency(log_flu_ts), differences=ns)
} else {
  ns_store = log_flu_ts
}

nd = ndiffs(log_flu_ts)
if(nd > 0) {
  nd_store = diff(ns_store, differences=nd)
}

# gives you your differenced data
nd
ns

Acf(flu_ts)
Pacf(flu_ts)

# NOTE: while chunk of code in the above line will do it automatically if 
# the ndiffs detect differencing is needed, you might want to do it manually.  
# For the data used in this example, the above code didn't detect the need 
# for differencing so I had to manually difference the data (use the acf and 
# pacf test to tell how much differencing)
flu_sdiff1 = diff(log_flu_ts, lag=frequency(log_flu_ts), differences=2)
plot(flu_sdiff1, main="Seasonal difference = 1")

# this code is in case there is a second seasonality in the data: it adjusts the frequency 
#adds a second level of seasonal differencing in case there are multiple seasons in the data
#flu_sdiff2 = diff(flu_sdiff1, lag=frequency(log_flu_ts)*2, differences=1)
#plot(flu_sdiff2, main="Seasonal difference = 1")

flu_ndiff = diff(flu_sdiff1, difference=1)
plot(flu_ndiff, main="Influenze Deaths: sdiff=1, ndiff=1",
     ylab= "Annual Changes in Influenza Deaths (weekly log scale)")

Acf(flu_ndiff)
Pacf(flu_ndiff)


# FINALLY DOING THE ARIMA------------------------------------------------
flu_fit = auto.arima(log_flu_ts, seasonal = TRUE)
flu_fit
plot(forecast(flu_fit, h=52), ylab="Influenza Deaths (log scale)")
lines(fitted(flu_fit), col="red")


# same as above but checks if leaving out "seasonal" helps 
# note: it doesn't change results.  NOTE: it didn't for this example
flu_fit2 = auto.arima(log_flu_ts)
flu_fit2
plot(forecast(flu_fit2, h=52), ylab="Influenza Deaths")
lines(fitted(flu_fit2), col="red")

# this code is using the Arima function to manually set d and q.  
# Note that lower case arima does this but doesn't have all the other 
# functionality to forecast so you capital Arima.
#try out manual setting for AR and MA
flu_fit_070 = Arima(log_flu_ts, order=c(7,0,7))
flu_fit_425 = Arima(log_flu_ts, order=c(4,2,5))
flu_fit_100 = Arima(log_flu_ts, order=c(1,0,0))
flu_fit_001 = Arima(log_flu_ts, order=c(0,0,1))
flu_fit_101 = Arima(log_flu_ts, order=c(1,0,1))
flu_fit_111 = Arima(log_flu_ts, order=c(1,1,1))
flu_fit_212 = Arima(log_flu_ts, order=c(2,1,2))


# get the AIC values from each model.  
# Lowest AIC suggest better model but read ch8 of forecasting 
# principals and practices for more info
flu_fit$aic
flu_fit_070$aic
flu_fit_425$aic
flu_fit_100$aic
flu_fit_001$aic
flu_fit_101$aic
flu_fit_111$aic
flu_fit_212$aic

#plot lines from lowest AIC values from above
lines(fitted(flu_fit_070), col="green")
lines(fitted(flu_fit_425), col="yellow")
lines(fitted(flu_fit_212), col="orange")

#seasonally adjusted data
flu_seasadj = seasadj(stl(log_flu_ts, s.window="periodic"))
plot(flu_seasadj)
tsdisplay(diff(flu_seasadj),main="")

flu_seasadj_fit = auto.arima(flu_seasadj)
summary(flu_seasadj_fit)
flu_seasadj_fit


Acf(residuals(flu_seasadj_fit))
Box.test(residuals(flu_seasadj_fit), lag=104, fitdf=4, type="Ljung")
plot(forecast(flu_seasadj_fit, h=52), ylab="Influenza Deaths (log scale)")

#seasonal data

tsdisplay(diff(log_flu_ts, 52))
tsdisplay(diff(diff(log_flu_ts, 52)))

flu_seas_fit = Arima(log_flu_ts, order=c(2,1,2), seasonal=c(0,1,1))
tsdisplay(residuals(flu_seas_fit))
Box.test(residuals(flu_seas_fit), lag=52, fitdf=4, type="Ljung")

plot(forecast(flu_seas_fit, h=104))

flu_seas_fit_auto = auto.arima(log_flu_ts)
flu_seas_fit_auto2 = auto.arima(log_flu_ts, stepwise=FALSE, approximation = FALSE)
flu_seas_fit_auto3 = auto.arima(log_flu_ts, max.order=8, 
                                stepwise = FALSE, approximation=FALSE)



#from youtube demo
flu_fit101 = arima(flu_ts, order=c(4,1,2))
flu_fit101_pred = predict(flu_fit101, n.ahead=52)
plot(flu_ts)
lines(flu_fit101_pred$pred, col="red")
lines(flu_fit101_pred$pred + 2*flu_fit101_pred$se, col="green")
lines(flu_fit101_pred$pred - 2*flu_fit101_pred$se, col="green")

