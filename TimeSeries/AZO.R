AZO <- read.csv(file.path("/Users/sheilanesselbush/Desktop", "AZO.csv"), sep = ",")

head(AZO)

AZO$log_AZO.open <- log(1+AZO$Open)
AZO$log_AZO.close <- log(1+AZO$Close)
AZO$log_AZO.high <- log(1+AZO$High)
AZO$log_AZO.low <- log(1+AZO$Low)

library(psych)
library(moments)
print.summary <- function(data,vars) {
  all.stats <- describe(AZO[,vars])
  summary.stats <-
    all.stats[,c('mean','median','sd','skew','kurtosis','min','max')]
  print(summary.stats,digits=5)
}

#Use closing price for the month
print.summary(AZO,c('log_AZO.open','log_AZO.close','log_AZO.high','log_AZO.low'))

#Test the null hypothesis that the mean of each of the series log returns is zero.
t.test(AZO$log_AZO.close)

# REJECT the null hypothesis, mean of the log returns is not 0

#### SKEWNESS TEST ####
require(moments)

s_AZO=skewness(AZO$log_AZO.close)/sqrt(6/length(AZO$log_AZO.close))
pv_AZO=2*(1-pnorm(abs(s_AZO)))
print(paste("Skewness Statistic:",s_AZO[1]))
print(paste("P-value:",pv_AZO))

# p-value larger than 0.05, do not reject the NULL

k_AZO=kurtosis(AZO$log_AZO.close)/sqrt(24/length(AZO$log_AZO.close))
pv2_AZO <- 2*(1-pnorm(abs(k_AZO)))
print(paste("Kurtosis Statistic:",k_AZO[1]))
print(paste("p-value:",pv2_AZO))

# Do not reject the null

#Obtain the empirical density plot of the daily log returns of each series, and select an appropriate distribution (Gaussian, t, etc.).
d1=density(AZO$log_AZO.close)
par(mfcol=c(1,2))
plot(d1$x,d1$y,xlab='returns',ylab='density',main='Histogram: AZO Log
     Returns',type='l')


#The conclusion is that the data follows an aproximately t-distribution

######################
#Box-Jenkins methodology to perform univariate time series model fitting to each of the series. 
require(tseries)
adf.test(AZO$log_AZO.close, alternative = "stationary")

##RULE#######################################################################
##large p-values are indicative of non-stationarity, and small p-values suggest stationarity.
##Using the usual 5% threshold, differencing is required if the p-value is greater than 0.05.
#############################################################################


#Conclusion: data must be differenced
#Differenced KO
AZOdiff=diff(AZO$log_AZO.close)
# remove first NA observation
AZOdiff =AZOdiff[-1]       


######## Check seasonality: AZO ##########
#step 1
acf(AZOdiff)
pacf(AZOdiff)

#step 2
require(forecast)

ns <- nsdiffs(AZOdiff)
if(ns > 0) {
  xstar <-
    diff(AZO$log_AZO.close,lag=frequency(AZO$log_AZO.close),differences=ns)
} else {
  xstar <- AZO$log_AZO.close
}
nd <- ndiffs(xstar)
if(nd > 0) {
  xstar <- diff(xstar,differences=nd)
}

# Data is not seasonal

##### FIND ORDER: LMVTX #########
require(fUnitRoots)
require(fBasics)
model1a=ar(as.vector(AZO$Close), method="mle")
model1a$order

# The order is 3

#Model: AZO##############################
# Past, difference, error
# Tried with different orders --> 3 instead of 1, did not improve AIC much
model2=arima(AZOdiff,order=c(1,1,0), include.mean=F)
model2
model3=arima(AZOdiff,order=c(0,0,1), include.mean=F)
model3
model4=arima(AZOdiff,order=c(0,1,1), include.mean=F)
model4
model5=arima(AZOdiff,order=c(0,1,0), include.mean=F)
model5


fit <- auto.arima(AZOdiff)
# Can be used to check if model is missed --> auto selects one

# Model with lowest AIC picked - Model 2

tsdiag(model2, gof=12)

# Looks good, only one residual outside the bounds


#### Other diagnostics ####
Acf(residuals(model2))
Box.test(residuals(model2), lag=24, fitdf=4, type="Ljung")


#Forecast AZO#######
model2p=predict(model2,6)
names(model2p)
model2p$pred
model2p$se
lcl=model2p$pred-1.96*model2p$se
ucl=model2p$pred+1.96*model2p$se
lcl
ucl
#also use

final <- forecast(model2, 6)
x <- as.data.frame(final)
x <- x['Hi 80']
x$log_AZO.close <- x$`Hi 80`
x <- x['log_AZO.close']
y <- AZO['log_AZO.close']
pred <- rbind(y, x)
exp <- exp(pred)

# 6 predictions are differences, manually converted in excel.
# Converted to rate of return in excel!

# Could pick one of the outer values (still need to be transformed)
# End with monthly returns in percents
# Rates based on closing prices
# 6 months, for active management --> famous mutual fund because he was very active
# Stay short term to be more accurate
