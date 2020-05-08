
#----------------------------------------------------------
# EXAMPLES
# the green lines are the medians
# from here you can create 2x2 chi squared table and calculate independence
plot(schools$X, 
     schools$Y,
     main = "Expenditures versus Personal Income", 
     xlab = "Per capita monthly personal income", 
     ylab = "Per capita annual expenditure on public education", 
     col = "red", 
     pch = 16)
abline(v = median(schools$X), 
       col = "green", 
       lty = 2, 
       lwd = 2)
abline(h = median(schools$Y), 
       col = "green", 
       lty = 2, 
       lwd = 2)
