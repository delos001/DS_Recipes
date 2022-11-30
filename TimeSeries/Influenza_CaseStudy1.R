

mydata=read.csv(file.path("NCHSData52.csv"),sep=",", header = TRUE)
head(mydata)
tail(mydata)

s_mean_all=meanf(mydata$All_Deaths,1)
s_mean_flu=meanf(mydata$Influenza.Deaths,1)
s_mean_pne=meanf(mydata$Pneumonia.Deaths,1)

plot(mydata[,"All_Deaths"], main="Pneumonia and Influnza Deaths: 2009 - 2017", 
     xlab="Week", ylab="Total Deaths", type="l")

plot(mydata[,"Pneumonia.Deaths"], main="Pneumonia Deaths: 2009 - 2017", 
     xlab="Week", ylab="Total Deaths", type="l")

plot(mydata[,"Influenza.Deaths"], main="Influnza Deaths: 2009 - 2017", 
     xlab="Week", ylab="Total Deaths", type="l")

plot(mydata[,"Percent.of.Deaths.Due.to.Pneumonia.and.Influenza"], 
     main="Percent of Influnza and Pneumonia Deaths: 2009 - 2017", 
     xlab="Week", ylab="% of Total Deaths", type="l")


#________________________________________________________________________
#pneumonia analysis
mydata_pne= mydata$Pneumonia.Deaths
head(mydata_pne)
tail(mydata_pne)

pne_ts =ts(mydata_pne, frequency = 52, start=c(2009,40))

plot(pne_ts, ylab="Pneumonia Deaths", xlab="Year")
plot(stl(pne_ts, "per"))
##simple moving average 
library(TTR)
pne_ts_sma = SMA(pne_ts, n=6)
plot.ts(pne_ts_sma, type="l")
#smoothing got rid of potentially an important change in the peaks so SMA
#will not be used.

#decomponse the time series
pne_decomp = decompose(pne_ts)
pne_decomp$seasonal
pne_decomp$trend
pne_decomp$random

plot(pne_decomp)

#use seasonal adjustment to remove the seasonal component
pne_seas_adj = pne_ts - pne_decomp$seasonal
plot(pne_seas_adj)

pne_seas_adj_SES = ses(pne_seas_adj)
plot(pne_seas_adj_SES)

#Holt's Linear trend method (allows for forecasting with a trend)

pne_ts_HL = holt(pne_ts, alpha=0.1, h=5)
plot(pne_ts_HL)
lines(fitted(pne_ts_HL), col="red")

#Holt's Seasonal Method
pne_fit1 = hw(pne_ts, seasonal="additive", h=2)
pne_fit2 = hw(pne_ts, seasonal="multiplicative", h=2)
plot(pne_fit1, ylab = "Pneumonia Deaths", xlab="Year", type= "l", fcol="white")
lines(fitted(pne_fit1), col="red", lty=2)
lines(fitted(pne_fit2), col="green", lty=2)
lines(pne_fit1$mean, type="l", col="red")
lines(pne_fit2$mean, type="l", col="green")
legend("bottomleft", lty = 1, pch = 1, col=1:3,
       c("data", "Holt Winters' Additive", "Holt Winters' Multiplicative"))

pne_fit1$mean
pne_fit2$mean

pne_fit_tbats = tbats(pne_ts)
pne_fit_test = forecast(pne_fit_tbats, h=100)
plot(pne_fit_test)
tbats.components(pne_fit_tbats)
lines(fitted(pne_fit_tbats), col="red")

#_______________________________________________________________________________
#Influenza analysis
mydata_flu= mydata$Influenza.Deaths
flu_ts = ts(mydata_flu, frequency = 52, start=c(2009,40))
plot(flu_ts)

#decomponse the time series
flu_decomp = decompose(flu_ts)
flu_decomp$seasonal
flu_decomp$trend
flu_decomp$random

#sma for seasonally adjusted flu data
flu_ts_sma = SMA(flu_seas_adj, n=6)
plot(flu_ts_sma, type="l",xlab="Time", 
     ylab="Pnuemonia Deaths: Trend + Random Components", 
     main="Seasonally Decomposed Pneumonia Death 2009-2017")

#look at simple moving average of trend component to analyze trend component
flu_decomp_trend=na.omit(flu_decomp$trend)
flut_trend_SMA = SMA(flu_decomp_trend, n=50)
plot.ts(flut_trend_SMA)

#get seasonally adjusted data (subtract seasonal component from the original data set)
plot(flu_decomp)
flu_seas_adj = flu_ts - flu_decomp$seasonal
meanf(flu_decomp$trend)

#idenitfy outliers in the seasonally adjusted data
library(tsoutliers)
flu_seas_adj_OL = tsoutliers(flu_seas_adj, iterate = 2, lambda=NULL)
flu_seas_adj_OL
flu_seas_adj_OL_index = c( 14, 15, 16, 17, 18, 66, 67, 68, 118, 119,
                           120, 171, 172, 173, 272, 273, 274, 275, 276, 277, 278, 326, 
                           327, 328, 329, 330, 336, 384, 385, 386, 387)
flu_seas_adj_OL_VALs = flu_seas_adj[flu_seas_adj_OL_index]
flu_seas_adj_OL_VALs

mycol=rep(NA, 500)
myshape=rep(NA, 500)
mycol[flu_seas_adj_OL_index]="dark red"
myshape[flu_seas_adj_OL_index]=4

#simple exponential smoothing for seasonally adjusted flu data
flu_seas_adj_SES = ses(flu_seas_adj, h=20)
flu_seas_adj_SES1 = ses(flu_seas_adj, alpha=0.1, initial="simple", h=20)
flu_seas_adj_SES2 = ses(flu_seas_adj, alpha=0.5, initial="simple", h=20)
flu_seas_adj_SES3 = ses(flu_seas_adj, alpha=0.8, initial="simple", h=20)

plot(flu_seas_adj, type="l", lwd=1, col="dark grey",
     xlab="Weekly Data", ylab="Influenza Deaths (adjusted)",
     main="Seasonally Decomposed Simple Exponential Smoothing: Influenza Deaths 2009-2017")
lines(fitted(flu_seas_adj_SES1), col="red", type="l", lwd=1, lty=3)
lines(fitted(flu_seas_adj_SES2), col="blue", type="l", lwd=1, lty=3)
lines(fitted(flu_seas_adj_SES3), col="green", type="l", lwd=1, lty=3)
points(flu_seas_adj, col=mycol, pch=myshape)

legend("topleft", lty=1, col=c("black", "red", "blue", "green", "dark red"),
       c("orig data", expression(alpha==0.1), expression(alpha==0.5), expression(alpha==0.8),
         "outliers"),
       pch=1)

#Trying tbats analysis because HoltWinters cannot analyze data with freq=52
#tbats analysis
flu_fit_tbats = tbats(flu_ts)
flu_fit_test = forecast(flu_fit_tbats, h=52)
plot(flu_fit_test, xlab="Weekly Data", ylab="Influenze Deaths",
     main="Exponential Smoothing Forecast for Influenza Deaths: 2009-2017")
tbats.components(flu_fit_tbats)
lines(fitted(flu_fit_tbats), col="red")



#holtwinters FPP code

fit1=holt(flu_ts, alpha = 0.8, beta = 0.2, initial = "simple", h=5)
fit2=holt(flu_ts, alpha = 0.8, beta = 0.2, initial = "simple", exponential=TRUE, h=5)

fit1$model$state
fitted(fit1)
fit1$mean

fit1
plot.ts(mydata_flu)
lines(fitted(fit1), col="red")
lines(fit1)
plot.ts(fit1)



flu_ets=ets(flu_ts, model="ZZZ", damped=NULL, alpha=NULL, beta=NULL,
    gamma=NULL, phi=NULL, additive.only=FALSE, lambda=NULL,
    lower=c(rep(0.0001,3), 0.8), upper=c(rep(0.9999,3),0.98),
    opt.crit=c("lik","amse","mse","sigma","mae"), nmse=3,
    bounds=c("both","usual","admissible"),
    ic=c("aicc","aic","bic"), restrict=TRUE)

flu_ets=stlf(flu_ts, model="ZZZ", damped=NULL, alpha=NULL, beta=NULL,
            gamma=NULL, phi=NULL, additive.only=FALSE, lambda=NULL,
            lower=c(rep(0.0001,3), 0.8), upper=c(rep(0.9999,3),0.98),
            opt.crit=c("lik","amse","mse","sigma","mae"), nmse=3,
            bounds=c("both","usual","admissible"),
            ic=c("aicc","aic","bic"), restrict=TRUE)

flu_stlf = stlf(flu_ts, h = 52, s.window = "periodic", t.window = NULL,
                robust = FALSE, lambda = NULL, biasadj = FALSE)

flu_stlf_forecast = forecast(flu_stlf, h=52, 
                             level=c(80,95), fan=FALSE, simulate=FALSE,
                             bootstrap="FALSE", npaths=5000, PI=TRUE,
                             lambda=flu_stlf$lambda)
plot(flu_stlf_forecast)

plot(flu_stlf)








