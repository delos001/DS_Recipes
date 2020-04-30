


# produces plot with one difference for the log_flu_ts data 
# using a frequency of 52 (for 52 weeks in a year)
tsdisplay(diff(log_flu_ts, 52))
# does a second differencing and produces the plots 
tsdisplay(diff(diff(log_flu_ts, 52)))


# this runs arima for seasonal data (its manually specified 
# that could be done based on the acf and pacf plots from the 
# tsdisplay lines above creates a acf and pacf for the residuals 
# (no lines shoudl be above threshold which would be considered 
# being random like white noise) box test to test whether residuals 
# are random??
flu_seas_fit = Arima(log_flu_ts, 
                     order=c(2,1,2), 
                     seasonal=c(0,1,1))
tsdisplay(residuals(flu_seas_fit))
Box.test(residuals(flu_seas_fit), 
         lag=52, 
         fitdf=4, 
         type="Ljung")

plot(forecast(flu_seas_fit, h=104))  # plots the forecasted values 104 weeks ahead


# same thing except using auto.arima so R will specify the parameters
flu_seas_fit_auto = auto.arima(log_flu_ts)

# turns off the shortcuts so R picks a better model (but takes more time to run)
flu_seas_fit_auto2 = auto.arima(log_flu_ts, 
                                stepwise=FALSE, 
                                approximation = FALSE)

# auto.arima() with differencing specified to be d=0 and D=1, and 
# allowing larger models than usual. 
flu_seas_fit_auto3 = auto.arima(log_flu_ts, 
                                max.order=8, 
                                lambda=0, 
                                d=0, D=0,
                                stepwise = FALSE, 
                                approximation=FALSE)
