
#----------------------------------------------------------
#----------------------------------------------------------
BASE R
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# Histogram with mean and median summary lines
cells <- seq(from = 0.0, to = 3.5, by = 0.5)
hist(mag, breaks = cells, col = "red", right = FALSE,
     main = "Histogram of Magnitude", xlab = "Magnitude")
abline(v = mean(mag), col = "green", lwd = 2, lty = 2)
abline(v = median(mag), col = "blue", lwd = 2, lty = 2)
