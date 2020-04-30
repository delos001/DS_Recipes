

# run tsoutliers on the data (in this example, it 
# has been previously seasonally adjusted).  
library(tsoutliers)


flu_seas_adj_OL = tsoutliers(flu_seas_adj, 
                             iterate = 2, 
                             lambda=NULL)

# create a vector containing the outlier index numbers
flu_seas_adj_OL_index = c( 14, 15, 16, 17, 18, 66, 
                          67, 68, 118, 119, 120, 171, 
                          172, 173, 272, 273, 274, 275, 
                          276, 277, 278, 326, 327, 328, 
                          329, 330, 336, 384, 385, 386, 
                          387)
flu_seas_adj_OL_VALs = flu_seas_adj[flu_seas_adj_OL_index]

# NOTE: function also gives suggested replacements for 
# the outliers which you can use to replace the outliers 
# if appropriate use this code to set it up so you can 
# identify the outliers by coloring them differently in 
# the plot
mycol=rep(NA, 500)
myshape=rep(NA, 500)
mycol[flu_seas_adj_OL_index]="dark red"
myshape[flu_seas_adj_OL_index]=4

# provides SES and projects 20 weeks in future
flu_seas_adj_SES = ses(flu_seas_adj, h=20)

# vary alphas 
flu_seas_adj_SES1 = ses(flu_seas_adj, 
                        alpha=0.1,    # low alpha gives more smooth forecast
                        initial="simple", 
                        h=20)
flu_seas_adj_SES2 = ses(flu_seas_adj, 
                        alpha=0.5,   # increased alpha hugs the data more closely
                        initial="simple", 
                        h=20)
flu_seas_adj_SES3 = ses(flu_seas_adj, 
                        alpha=0.8, 
                        initial="simple", 
                        h=20)

plot(flu_seas_adj,          # plot original data
     type="l", lwd=1, col="dark grey",
     xlab="Weekly Data", ylab="Influenza Deaths (adjusted)",
     main="Seasonally Decomposed Simple Exponential Smoothing: Influenza Deaths 2009-2017")

lines(fitted(flu_seas_adj_SES1),  # adds line with the forecast for alpha = 0.1
      col="red", type="l", lwd=1, lty=3)
lines(fitted(flu_seas_adj_SES2),  # adds line with the forecast for alpha = 0.5
      col="blue", type="l", lwd=1, lty=3)
lines(fitted(flu_seas_adj_SES3),  # adds line with the forecast for alpha = 0.8
      col="green", type="l", lwd=1, lty=3)

points(flu_seas_adj, col=mycol, pch=myshape)

# creates legend for original data, SES curves, and outliers
legend("topleft", 
       lty = 1, 
       col = c("black", "red", "blue", "green", "dark red"),
       c("orig data", 
         expression(alpha==0.1), 
         expression(alpha==0.5), e
         xpression(alpha==0.8),
         "outliers"),
       pch=1)
