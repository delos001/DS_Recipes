


# CI when not given data: only given sample mean, sample var, 
#    number of observations

# have to get quantiles from qt using half percent quantiles 
#   (0.005, 0.995), 24 degrees of freedom, left tail
t.values <- qt(c(0.005, 0.995), 24, lower.tail = TRUE)
std <- sd(data.set)/sqrt(25)
mu <- mean(data.set)
c(signif(mu+t.values[1]*std, digits=5), signif(mu+t.values[2]*std, digits=5))
