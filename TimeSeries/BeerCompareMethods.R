

beer2 <- window(ausbeer,start=1992,end=2006-.1)

beerfit1 <- meanf(beer2,h=11)
beerfit2 <- rwf(beer2,h=11)
beerfit3 <- snaive(beer2,h=11)

plot(beerfit1, plot.conf=FALSE,
  main="Forecasts for quarterly beer production")
lines(beerfit2$mean,col=2)
lines(beerfit3$mean,col=3)
lines(ausbeer)
legend("topright", lty=1, col=c(4,2,3),
  legend=c("Mean method","Naive method","Seasonal naive method"))



beer3 <- window(ausbeer, start=2006)
accuracy(beerfit1, beer3)
accuracy(beerfit2, beer3)
accuracy(beerfit3, beer3)
