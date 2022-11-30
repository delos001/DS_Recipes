library(flexmix)

?flexmix
library(ISLR)

head(Auto)
cr.1=flexmix(mpg~cylinders+weight, k=5, data=Auto)
summary(cr.1)
