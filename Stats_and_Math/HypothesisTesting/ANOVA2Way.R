
# Factorial Design
# Performs multiple experiments at once: can look at effect of more 
#   than one variable simulataneously
# With more than 1 observation per cell, it is possible to detect the 
#   presence of an interaction

# gives you a chance to detect an interaction between the factors: 
#     occurrs when the effects of one treatment vary according to 
#     the levels of treatment of the other effect.  ex: the effect of 
#     type (below) may not be the same when size (below) is changed or 
#     vice versa.
# Black p450 for factorial design hypothesis: row effects, column effects, 
#   interaction effects
# Noise is the dependent variable and it will be looked at with respect to 
#   independent factors


schools <- read.csv("schools.csv",sep=",")

result <- aov(Y~region+year+region*year,schools)
summary(result)
# comparison expenditures across time, from region to region to region (expenditures by region, year, and year/region together)
#              Df Sum Sq Mean Sq F value   Pr(>F)    
# region        3 188843   62948  23.263 2.62e-12 ***
# year          1   2006    2006   0.741    0.391    
# region:year   3   9194    3065   1.133    0.338    
# Residuals   142 384240    2706                     
# ---
# Signif. codes:  
# 0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# interpretation: region remains the dominant source in explaining 
#   variation (due to low P value) year not statistically significant
# interaction term not statisticall significant


# To take full advantage of aov() and lm() functions, it is necessary 
#   to use various "extractor" functions.  Verzani shows a number of 
#   these in Table 11.1 page 368.  summary() is one example.  
#   The residuals and the fitted values will be examined.
r <- residuals(result)
fitt <- fitted(result)

par(mfrow = c(1,2))
hist(r, col = "red", main = "Histogram of Residuals", xlab = "Residual")
boxplot(r, col = "red", main = "Boxplot Residuals", ylab = "Residual")
par(mfrow = c(1,1))

skewness(r)   # for normal dist should be 0
kurtosis(r)   # for normal dist should be 3


# see bivariate plot for plotting multiple variables
# after creating bivariate plot,  you can create 2x2 chi squared table and 
# calculate independence
plot(schools$X, schools$Y,main = "Expenditures versus Personal Income", 
     xlab = "Per capita monthly personal income", ylab = "Per capita annual 
     expenditure on public education", col = "red", pch = 16)
abline(v = median(schools$X), col = "green", lty = 2, lwd = 2)
abline(h = median(schools$Y), col = "green", lty = 2, lwd = 2)
