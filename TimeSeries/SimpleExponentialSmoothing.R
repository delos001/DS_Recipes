


mydata_flu= mydata$Influenza.Deaths
flu_ts = ts(mydata_flu, frequency = 52, start=c(2009,40))

flu_decomp = decompose(flu_ts)
flu_decomp$seasonal
flu_decomp$trend
flu_decomp$random

plot(flu_decomp)

flu_seas_adj = flu_ts - flu_decomp$seasonal

flu_seas_adj_SES = ses(flu_seas_adj, h=20)
flu_seas_adj_SES1 = ses(flu_seas_adj, alpha=0.2, initial="simple", h=20)
flu_seas_adj_SES2 = ses(flu_seas_adj, alpha=0.5, initial="simple", h=20)
flu_seas_adj_SES3 = ses(flu_seas_adj, alpha=0.8, initial="simple", h=20)

plot(flu_seas_adj, type="l",
     xlab="Weekly Data", ylab="Influenza Deaths (adjusted)",
     main="Seasonally Decomposed Simple Exponential Smoothing: Influenza Deaths 2009-2017")
lines(fitted(flu_seas_adj_SES1), col="red", type="l")
lines(fitted(flu_seas_adj_SES2), col="blue", type="l")
lines(fitted(flu_seas_adj_SES3), col="green", type="l")
