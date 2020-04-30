

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
