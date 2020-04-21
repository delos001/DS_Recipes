
#-------------------------------------------------------
# EXAMPLE USING LINEAR MODEL FROML BOSTON DATA SET
library(ISLR)

attach(Boston)
lm.fit=lm(medv~lstat)

confint(lm.fit)


#-------------------------------------------------------
# EXAMPLE 2
lm.fit = lm(medv~lstat, data=Boston)
predict(lm.fit, data.frame(lstat=c(5,10,15)), interval = "confidence")
