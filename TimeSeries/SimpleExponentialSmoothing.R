
# Simple exponential smoothing   
# (see chapter 7 of Forecasting Principles and Practice

# Use this for non season and non-trend time series data
# note: the "mydata" data set is seasonal so not appropriate 
# for simple exponential smoothing therefore, this code is 
# for demonstration purposes only



mydata_flu= mydata$Influenza.Deaths
flu_ts = ts(mydata_flu, frequency = 52, start=c(2009,40))

flu_decomp = decompose(flu_ts)
flu_decomp$seasonal
flu_decomp$trend
flu_decomp$random

plot(flu_decomp)

# remove the seasonal component from the data
flu_seas_adj = flu_ts - flu_decomp$seasonal

#simple exponential smoothing for seasonally adjusted flu data
# with an alpha of 0.2, 0.5, 0.8 (see text for alpha impact), 
# initial=simple is how R initializes the forecast
flu_seas_adj_SES = ses(flu_seas_adj, h=20)
flu_seas_adj_SES1 = ses(flu_seas_adj, alpha=0.2, 
                        initial="simple", h=20)
flu_seas_adj_SES2 = ses(flu_seas_adj, alpha=0.5, 
                        initial="simple", h=20)
flu_seas_adj_SES3 = ses(flu_seas_adj, alpha=0.8, 
                        initial="simple", h=20)

plot(flu_seas_adj, type="l",       # plot the original data
     xlab="Weekly Data", 
     ylab="Influenza Deaths (adjusted)",
     main="Seasonally Decomposed Simple Exponential Smoothing: Influenza Deaths 2009-2017")

# plot the predicted lines over top of the plot from line above
lines(fitted(flu_seas_adj_SES1), col="red", type="l") 
lines(fitted(flu_seas_adj_SES2), col="blue", type="l")
lines(fitted(flu_seas_adj_SES3), col="green", type="l")
