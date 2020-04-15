
#Data set 2: 5 year inflation
inflation = read.csv(file.path("5yrInflationRate_US.csv"), sep=",", header=TRUE)
head(inflation)
inflation_sort = inflation[order(inflation$Time),]
head(inflation_sort)

inflation2 = inflation_sort[,2]
head(inflation2)

plot.ts(inflation2)
inflation_ts = ts(inflation2, frequency=12, start=1950)
plot(inflation_ts, main="5yr Inflation Rate, US 1950-2017")

plot(stl(inflation_ts, "per"), main="5yr Inflation Rate, US 1950-2017")

nsdiffs(inflation_ts)
ndiffs(inflation_ts)

acf(inflation_ts)
pacf(inflation_ts)

inflation_arima1 = auto.arima(inflation_ts)
inflation_arima1
plot(forecast(inflation_arima1, h=60), ylab="Livestock Totals USA")
lines(ma(inflation_ts, 5), col="green")
fit_inflation_0.2 = ses(inflation_ts, alpha=0.2, initial="simple", h=20)
fit_inflation_0.8 = ses(inflation_ts, alpha=0.8, initial="simple", h=20)
lines(fitted(inflation_arima1), col="red")
lines(fitted(fit_inflation_0.8), col="blue")
lines(fitted(fit_inflation_0.2), col="yellow")
