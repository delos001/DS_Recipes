

# tbats can be used on seasonal trend data when the frequency 
# is too high for Holt Winter

# flut_ts is the time series data (see preparing for details on how this was setup
flu_fit_tbats = tbats(flu_ts)

# gives a forecast based on the results of the tbats output
flu_fit_test = forecast(flu_fit_tbats, h=100)

# plots forecast for h=52  (which is 52 weeks in this case because 
# this example is of weekly flu data)
plot(flu_fit_test)

tbats.components(flu_fit_tbats) # produces the components

# adds a line that is the fitted values (predicted values laid over 
# the original data set)
lines(fitted(flu_fit_tbats), col="red")
