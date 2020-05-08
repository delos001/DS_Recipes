
#----------------------------------------------------------
#----------------------------------------------------------
# BASE R
#----------------------------------------------------------
#----------------------------------------------------------


#----------------------------------------------------------
# BASIC SCATTER PLOT MATRIX
plot(mydata[,c(2:4,9)]) # gives matrix plot of scatter plots for columns 2-4 and col 9


#----------------------------------------------------------
# BASIC SCATTER PLOT 
x=rnorm(100)
y=rnorm(100)
plot(x,y,
     xlab = "this is xaxis",
     ylab = "this is yaxis",
     main = "Plot of X vs Y",
     col = 'green',
     pch = '10',
     cex = '1.0'
    )
legend('bottomleft',
       legend=c('Stndev(x) = 2',
                'Stndev(y) = 1'))

identify(x, y, name) # allows you to hover over and click points




#----------------------------------------------------------
#----------------------------------------------------------
# GGPLOT
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# EXAMPLE
ggplot(mydata,
       aes(x=mydata$RINGS,
           y=mydata$VOLUMEc)) +
geom_point(aes(colour=mydata$RINGS), 
           size=2, 
           show.legend=FALSE) +
scale_colour_gradient(low='red', high='blue') +
xlab('Rings')+ylab('Volume (cm^3)')

ggplot(mydata,
       aes(x=mydata$RINGS,
           y=mydata$WHOLE)) +
geom_point(aes(colour=mydata$RINGS, 
               size=2, 
               show.legend=FALSE, )) + 
scale_colour_gradient(low='red',high='blue') +
xlab('Rings') +
ylab('Whole (g)')


#----------------------------------------------------------
# EXAMPLE with geom text and geom smoothing
```{r echo=FALSE}
ggplot(stAEs,aes(x = MOS_s,y = ZeroAE_perc_s)) +
	geom_point(aes(color = SiteGroup), 
	           position = position_jitter(width = .05,height = .05)) +
  ggtitle(label = "Percentage of Subjects with Zero AEs vs. Months on Study") +
	geom_smooth(method = 'lm') +
	geom_text(aes(label = Site), size = 3, 
	          position = position_jitter(width = .05, height = .05))
```


#----------------------------------------------------------
# EXAMPLE 2
# function to plot scatter plot matrix (like the pairs function)

par(mfrow = c(3, 3))
par(mar=c(5, 6, 4, 1) + .1)  # use this so you can see the labels
for (k in colNames1){
     for (i in colNames2){
          plot(feat_eda[, c(k, i)], 
               col=feat_eda$city)
          legend("bottomright", 
                 legend=levels(feat_eda$city), 
                 col = 1:length(feat_eda$city), 
                 pch = 1)
     }
}
par(mfrow = c(1,1))


#----------------------------------------------------------
# SCATTER PLOT WITH REGRESSION LINES

p <- ggplot(schools, 
            aes(x = X, y = Y)) + 
geom_point(aes(color = region), 
           size = 3) +
ggtitle("Plot of Expenditures versus Income Colored by Region")

p + 
geom_abline(intercept = 92.29, 
                slope=0.0305) + 
geom_abline(intercept = 35.38,
            slope=0.0305)
