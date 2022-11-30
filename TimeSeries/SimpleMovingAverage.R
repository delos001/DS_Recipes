
# for non-seasonal nontrend data


mydata_flu= mydata$Influenza.Deaths
flu_ts = ts(mydata_flu, 
            frequency = 52, 
            start=c(2009,40))
plot(flu_ts)

# only use this if you have seasonal data: this will allow 
# you to decompose so you can get rid of the seasonal 
# component and use simple moving average
flu_decomp = decompose(flu_ts)
flu_decomp$seasonal
flu_decomp$trend
flu_decomp$random
plot(flu_decomp)

# removes the seasonal component so you can apply SMA below
flu_seas_adj = flu_ts - flu_decomp$seasonal

#sma for seasonally adjusted flu data
flu_ts_sma = SMA(flu_seas_adj, n=6)  

plot(flu_ts_sma, 
     type="l",
     xlab="Time", 
     ylab="Pnuemonia Deaths: Trend + Random Components", 
     main="Seasonally Decomposed Pneumonia Death 2009-2017")
