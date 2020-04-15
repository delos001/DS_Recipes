library(TTR)
library(tseries)
library(forecast)

mydata = read.csv(file.path("NCHSData52.csv"), sep=",", header=TRUE)

head(mydata)

myfludata = mydata$Influenza.Deaths
head(myfludata)

plot.ts(myfludata)

flu_ts = ts(myfludata, frequency = 52, start=c(2009,40))
plot.ts(flu_ts)

plot(stl(flu_ts, "per"), main="Influenza Deaths 2009-2017 Decomposed Time Series")
#results show large seasonal component with relatively small trend component
#results show remainder/random component has one very large spike 2015

flu_adf = adf.test(flu_ts, alternative="stationary")
flu_adf
#result: Dickey-Fuller = -5.6284, Lag order = 7, p-value = 0.01

flu_kpss = kpss.test(flu_ts)
flu_kpss

#function to determine if differencing is needed
nsdiffs(flu_ts)
ndiffs(flu_ts)

#macro to combine nsdiffs and ndiffs and do the differencing at same time
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

nd
ns

Acf(flu_ts)
Pacf(flu_ts)

flu_seas_diff1 = diff(flu_ts, lag=frequency(flu_ts), differences=1)
plot(flu_seas_diff1, main="Seasonal difference = 1")
flu_seas_diff2 = diff(flu_ts, lag=frequency(flu_ts), differences=2)
plot(flu_seas_diff2, main="Seasonal difference = 2")
flu_seas_diff3 = diff(flu_ts, lag=frequency(flu_ts), differences=3)
plot(flu_seas_diff3, main="Seasonal difference = 3")
flu_seas_diff4 = diff(flu_ts, lag=frequency(flu_ts), differences=4)
plot(flu_seas_diff4, main="Seasonal difference = 4")

Acf(flu_seas_diff1)
Acf(flu_seas_diff2)
Acf(flu_seas_diff3)
Acf(flu_seas_diff4)

Pacf(flu_seas_diff1)
Pacf(flu_seas_diff2)
Pacf(flu_seas_diff3)
Pacf(flu_seas_diff4)


#the above wasn't working: seasonality remained despite differencing
#add one to original data because the one zero is messing up boxcox

flu_ts_1 = flu_ts + 1
ln_flu_ts_1 = log(flu_ts_1)
plot.ts(ln_flu_ts_1)
lmbd_flu_ts_1 = BoxCox.lambda(flu_ts_1)
bc_flu_ts_1=BoxCox(flu_ts_1, lmbd_flu_ts_1)
plot(bc_flu_ts_1)

var(ln_flu_ts_1)
var(bc_flu_ts_1)
#go with boxcox because it had lower variance

plot(stl(bc_flu_ts_1, "per"), main="Influenza Deaths 2009-2017 Decomposed Time Series (Box Cox)")
plot(stl(ln_flu_ts_1, "per"), main="Influenza Deaths 2009-2017 Decomposed Time Series (ln)")


#separate the components
flu_ts_1_decomp = decompose(ln_flu_ts_1)
flu_ts_1_decomp$seasonal
flu_ts_1_decomp$trend
flu_ts_1_decomp$random

#remove the seasonal components
flu_ts_1_sea_adj = ln_flu_ts_1 - flu_ts_1_decomp$seasonal
plot(flu_ts_1_sea_adj)

flu_adf = adf.test(flu_ts_1_sea_adj)
flu_adf
#result: Dickey-Fuller = -5.6284, Lag order = 7, p-value = 0.01

flu_kpss = kpss.test(flu_ts_1_sea_adj, null=c("Level", "Trend"))
flu_kpss

#run acf and pacf on data with seasonal component removed
Acf(flu_ts_1_sea_adj)
Pacf(flu_ts_1_sea_adj)

#run auto.arima on the seasonally removed data
flu_fit1 = auto.arima(flu_ts_1_sea_adj)
flu_fit1
plot(forecast(flu_fit1, h=52), ylab="Influenza Deaths (log scale)")
lines(fitted(flu_fit1), col="red")

#function to determine if differencing is needed
nsdiffs(flu_ts_1_sea_adj)
ndiffs(flu_ts_1_sea_adj)

#macro to combine nsdiffs and ndiffs and do the differencing at same time
ns = nsdiffs(flu_ts)
if (ns > 0) {
  ns_store = diff(flu_ts_1_sea_adj, lag=frequency(flu_ts_1_sea_adj), differences=ns)
} else {
  ns_store = flu_ts_1_sea_adj
}

nd = ndiffs(flu_ts_1_sea_adj)
if(nd > 0) {
  nd_store = diff(ns_store, differences=nd)
}

nd
ns
#plots the results after differencing done
plot.ts(nd_store)

flu_ts_1_sea_adj_diff1 = nd_store
plot.ts(flu_ts_1_sea_adj_diff1)
#after plotting the above line, There don't seem to be trends but there are now clumps

#run acf and pacf on the differenced seasonally adjusted data
Acf(flu_ts_1_sea_adj_diff1)
Pacf(flu_ts_1_sea_adj_diff1)

#run auto.arima on the sesonally removed differenced data
flu_fit2 = auto.arima(flu_ts_1_sea_adj_diff1)
flu_fit2
plot(forecast(flu_fit2, h=52), ylab="Influenza Deaths (log scale)")
lines(fitted(flu_fit2), col="red")


#run auto.arima on the seasonally removed data
flu_fit1 = auto.arima(flu_ts_1_sea_adj_diff1)
flu_fit1
plot(forecast(flu_fit1, h=52), ylab="Influenza Deaths (log scale)")
lines(fitted(flu_fit1), col="red")

