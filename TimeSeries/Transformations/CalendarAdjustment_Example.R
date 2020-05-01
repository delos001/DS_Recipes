


# Some variation seen in seasonal data may be due to simple 
# calendar effects. In such cases, it is usually much easier 
# to remove the variation before fitting a forecasting model.

# For example, if you are studying monthly milk production on 
# a farm, then there will be variation between the months simply 
# because of the different numbers of days in each month in 
# addition to seasonal variation across the year.


# this is from the milk production example
monthdays <- rep(c(31,28,31,30,31,30,31,31,30,31,30,31),14)
monthdays[26 + (4*12)*(0:2)] <- 29

par(mfrow = c(2,1))
plot(milk, 
     main = "Monthly milk production per cow",
     ylab = "Pounds",
     xlab = "Years")
plot(milk/monthdays, 
     main = "Average milk production per cow per day", 
     ylab = "Pounds", 
     xlab = "Years")
