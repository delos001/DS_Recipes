

mydata=read.csv(file.path("NCHSData52.csv"),
                sep=",", 
                header=TRUE)

meanf(mydata$All_Deaths,1)

plot(mydata[,"All_Deaths"], 
     main="Pneumonia and Influnza Deaths: 2009 - 2017", 
     xlab="Week", 
     ylab="Total Deaths", 
     type="l")

plot(mydata[,"Pneumonia.Deaths"], 
     main="Pneumonia Deaths: 2009 - 2017", 
     xlab="Week", 
     ylab="Total Deaths", 
     type="l")

plot(mydata[,"Influenza.Deaths"], main="Influnza Deaths: 2009 - 2017", 
     xlab="Week", ylab="Total Deaths", type="l")

plot(mydata[,"Percent.of.Deaths.Due.to.Pneumonia.and.Influenza"], 
     main="Percent of Influnza and Pneumonia Deaths: 2009 - 2017", 
     xlab="Week", 
     ylab="% of Total Deaths", 
     type="l")


# sets the data set as a time series data set.  
# frequency is the number of observations in a year 
#         (could be 12 for month or 4 for quarterly, etc).  
# start allows you to say when the data starts (ie: which 
#         year and which week the data set starts in this case)
mydata_ts=mydata_ts[,3]
mydata_ts=ts(mydata, frequency=52, start=c(2009,40))

plot.ts(mydata_ts)

# GUIDANCE:
# the seasonal fluctuations are roughly constant in size over time 
# and do not seem to depend on the level of the time series, and the 
# random fluctuations also seem to be roughly constant in size over 
# time: if yes: consider additive model

# the size of the seasonal fluctuations and random fluctuations seem to 
# increase with the level of the time series: if yes, consider 
# transformation first - (see transformation tab for more detail/code)
# 	NOTE: this should adjust the plot so the seasonal fluctuations and 
#    random fluctuations in the log-transformed time series appear to be 
#    roughly constant over time and do NOT depend on the level of the time series.
# THUS: log transformed time series can probably be described using an additive model.


log.mydata_ts = log(mydata_ts)
plot.ts(log.mydata_ts)
