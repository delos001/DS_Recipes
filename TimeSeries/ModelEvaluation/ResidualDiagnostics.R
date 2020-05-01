

# example from dow jones data  (see onenote)

dj2 <- window(dj, end=250)
plot(dj2, main="Dow Jones Index (daily ending 15 Jul 94)", 
  ylab="", xlab="Day")
res <- residuals(naive(dj2))
plot(res, main="Residuals from naive method", 
  ylab="", xlab="Day")
Acf(res, main="ACF of residuals")
hist(res, nclass="FD", main="Histogram of residuals")
