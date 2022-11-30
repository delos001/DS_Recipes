#plot the data
autoplot(visits)

#decompost the data via SEATS to get seasonally adj data
decomp = seas(visits)
autoplot(decomp)
visits.SA = seasadj(decomp)

#plot the trend and SA data on top of the normal data
autoplot(visits, series="Data") +
autolayer(trend(decomp), series="Trend") +
autolayer(visits.SA, series="Seasonally Adj") +
scale_color_manual(values=c("gray", "red", "blue"), 
                   breaks=c("Data", 
                            "Trend", 
                            "Seasonally Adj")) +
labs(title="Monthly Recreational Visits\nArches Nat'l Park", 
     x="Year", 
     "Recreational Visits")

#forecast SA data using SES
fit.ses.low = ses(visits.SA, h=6, alpha=0.4)
fit.ses.med = ses(visits.SA, h=6, alpha=0.7)
fit.ses.high = ses(visits.SA, h=6, alpha=0.9)
#make a list of all outputs
fits = list(fit.ses.low, fit.ses.med, fit.ses.high)
#graph the results
autoplot(window(visits.SA, start=2009), 
         series="Actual - SA", size=1) +
autolayer(window(visits, start=2009), 
          series="Actual - Orig") +
autolayer(window(fit.ses.low$fitted, start=2009), 
          series="alpha = 0.4", size=1) +
autolayer(window(fit.ses.med$fitted, start=2009), 
          series="alpha = 0.7", size=1) +
autolayer(window(fit.ses.high$fitted, start=2009), 
          series="alpha = 0.9", size=1) +
scale_color_manual(values=c("gray", "black", "red", 
                            "blue", "springgreen3"),
                   breaks=c("Actual - Orig", 
                            "Actual - SA", 
                            "alpha = 0.4", 
                            "alpha = 0.7", 
                            "alpha = 0.9")) +
labs(title="Monthly Recreational Visits - Arches Nat'l Park", 
     subtitle="Seasonally Adj", 
     x="Year", 
     y="Recreational Visits")

#calculate the accuracy measures
for(i in fits){
  a = accuracy(i)
  print(a)
}

#create a dataframe of all SES values
all.fits = as.data.frame(cbind("SA_data"=visits.SA, 
                               "low_alpha"=fit.ses.low$fitted, 
                               "med_alpha"=fit.ses.med$fitted,
                               "high_alpha"=fit.ses.high$fitted))

#residuals analysis
resid.low = fit.ses.low$residuals
resid.med = fit.ses.med$residuals
resid.high = fit.ses.high$residuals

#plot the residuals
autoplot(window(resid.low, start=2009), 
         series = "alpha = 0.4") +
autolayer(window(resid.med, start=2009), 
          series="alpha = 0.7") +
autolayer(window(resid.high, start=2009), 
          series="alpha= 0.9") +
geom_hline(yintercept = 0, 
           color="black") +
labs(title="Residual of SES", 
     x="Year", 
     y="Recreational Visits")
