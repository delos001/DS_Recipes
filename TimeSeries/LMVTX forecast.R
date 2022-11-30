setwd("C:/Users/nm49027/Documents/Personal/PREDICT 460/Final Project/")
head(LMVTX)

LMVTX$log_LMVTX.open <- log(1+LMVTX$Open)
LMVTX$log_LMVTX.close <- log(1+LMVTX$Close)
LMVTX$log_LMVTX.high <- log(1+LMVTX$High)
LMVTX$log_LMVTX.low <- log(1+LMVTX$Low)

library(psych)
print.summary <- function(data,vars) {
  all.stats <- describe(LMVTX[,vars])
  summary.stats <-
    all.stats[,c('mean','median','sd','skew','kurtosis','min','max')]
  print(summary.stats,digits=5)
}

#Use closing price for the month
print.summary(LMVTX,c('log_LMVTX.open','log_LMVTX.close','log_LMVTX.high','log_LMVTX.low'))

#Test the null hypothesis that the mean of each of the series log returns is zero.
t.test(LMVTX$log_LMVTX.close)

#### SKEWNESS TEST ####
require(moments)

s_LMVTX=skewness(LMVTX$log_LMVTX.close)/sqrt(6/length(LMVTX$log_LMVTX.close))
pv_LMVTX=2*(1-pnorm(abs(s_LMVTX)))
print(paste("Skewness Statistic:",s_LMVTX[1]))
print(paste("P-value:",pv_LMVTX))

k_LMVTX=kurtosis(LMVTX$log_LMVTX.close)/sqrt(24/length(LMVTX$log_LMVTX.close))
pv2_LMVTX <- 2*(1-pnorm(abs(k_LMVTX)))
print(paste("Kurtosis Statistic:",k_LMVTX[1]))
print(paste("p-value:",pv2_LMVTX))

#Obtain the empirical density plot of the daily log returns of each series, and select an appropriate distribution (Gaussian, t, etc.).
d1=density(LMVTX$log_LMVTX.close)
par(mfcol=c(1,2))
plot(d1$x,d1$y,xlab='returns',ylab='density',main='Histogram: LMVTX Log
Returns',type='l')


#The conclusion is that the data follows an aproximately t-distribution

######################
#Box-Jenkins methodology to perform univariate time series model fitting to each of the series. 
require(tseries)
adf.test(LMVTX$log_LMVTX.close, alternative = "stationary")

##RULE#######################################################################
##large p-values are indicative of non-stationarity, and small p-values suggest stationarity.
##Using the usual 5% threshold, differencing is required if the p-value is greater than 0.05.
#############################################################################


#Conclusion: data must be differenced
#Differenced KO
LMVTXdiff=diff(LMVTX$log_LMVTX.close)
# remove first NA observation
LMVTXdiff =LMVTXdiff[-1]       


######## Check seasonality: LMVTX ##########
#step 1
acf(LMVTX$log_LMVTX.close)
pacf(LMVTX$log_LMVTX.close)

#step 2
require(forecast)

ns <- nsdiffs(LMVTX$log_LMVTX.close)
if(ns > 0) {
  xstar <-
    diff(LMVTX$log_LMVTX.close,lag=frequency(LMVTX$log_LMVTX.close),differences=ns)
} else {
  xstar <- LMVTX$log_LMVTX.close
}
nd <- ndiffs(xstar)
if(nd > 0) {
  xstar <- diff(xstar,differences=nd)
}


##### FIND ORDER: LMVTX #########
require(fUnitRoots)
require(fBasics)
model1a=ar(as.vector(LMVTX$Close), method="mle")
model1a$order




#Model: LMVTX##############################
model2=arima(LMVTX$log_LMVTX.close,order=c(1,1,0), include.mean=F)
model2
model3=arima(LMVTX$log_LMVTX.close,order=c(0,0,1), include.mean=F)
model3
model4=arima(LMVTX$log_LMVTX.close,order=c(0,1,1), include.mean=F)
model4
model4=arima(LMVTX$log_LMVTX.clos,order=c(0,1,0), include.mean=F)
model4

tsdiag(model4, gof=12)


#### Other diagnostics ####
Acf(residuals(model4))
Box.test(residuals(model4), lag=24, fitdf=4, type="Ljung")


#Forecast LMVTX#######
model4p=predict(model4,20)
names(model4p)
model4p$pred
model4p$se
lcl=model4p$pred-1.96*model4p$se
ucl=model4p$pred+1.96*model4p$se
lcl
ucl
#also use

forecast(model4, 20)
plot(forecast(model4, 20))

