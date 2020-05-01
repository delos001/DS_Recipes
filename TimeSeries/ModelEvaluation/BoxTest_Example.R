
if result exceeds the significance level of 0.05: indicates a lack of support for non-zero autocorrelations

flu_seas_fit = Arima(log_flu_ts, 
                     order=c(2,1,2), 
                     seasonal=c(0,1,1))

tsdisplay(residuals(flu_seas_fit))

Box.test(residuals(flu_seas_fit), 
         lag=52, 
         fitdf=4, 
         type="Ljung")
