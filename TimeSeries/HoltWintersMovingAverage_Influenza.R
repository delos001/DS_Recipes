

library(forecast)

mydata=read.csv(file.path("NCHSData52.csv"),sep=",")

mydata_ts=mydata[,3]
mydata_ts=ts(mydata_ts, frequency=52, start=c(2009,40))

plot.ts(mydata_ts)

mydata_exp_smooth = HoltWinters(mydata_ts, beta=FALSE, gamma=FALSE
	l.start=7.8)


mydata_exp_smooth



mydata_exp_smooth$fitted
plot(mydata_exp_smooth)

mydata_exp_smooth$SSE

mydata_exp_smooth_pred = forecast(mydata_exp_smooth, h=52)

mydata_exp_smooth_pred
plot(mydata_exp_smooth_pred)

plot(forecast(mydata_exp_smooth, h=52))




















acf(mydata_exp_smooth_pred$residuals, lag.max=20)














Box.test(mydata_exp_smooth_pred$residuals, lag=20, type="Ljung-Box")
