
# USE CROSS VALIDATION TO FIND THE OPTIMAL d VALUE: 
#     this is alternative method to writing all the possible 
#     polynomials and using ANOVA to compare (above)

set.seed(1)
library(boot)
all.deltas=rep(NA, 10)  # will be replaced by values later
# for each i 1 to 10 (where i will be the d value of which you are trying to find the optimal)
# fit a glm model for wage using age as predictor for each polynomial value 1 through 10
# put the resutling delta value in the all.deltas vector
for (i in 1:10){
  glm.fit = glm(wage~poly(age, i), 
                data=Wage)
  all.deltas[i] = cv.glm(Wage, 
                         glm.fit, 
                         K=10)$delta[2]
}
plot(1:10, 
     all.deltas, 
     xlab="Deg", 
     ylab = "CV error", 
     type="l", 
     pch=20, 
     lwd=2,
     ylim=c(1590, 1700))  # define limit for readability
min.point=min(all.deltas)
sd.points=sd(all.deltas)
# cacluates 0.2 times st deviation for each point above and below the minimum delta value
abline(h=min.point+0.2*sd.points, 
       col="red", 
       lty="dashed")
abline(h=min.point-0.2*sd.points, 
       col="red", 
       lty="dashed")
legend("topright", "0.2 Stdev lines", lty="dashed", col="red")

# from this graph, we would select d=3 for the smallest degree giving 
#     reasonably small cross-validation error.
# using the degree of 3 as optimal, plot polynomial regression line on the data
plot(wage~age, 
     data=Wage, 
     col="darkgrey")
agelims=range(Wage$age)
age.grid=seq(from=agelims[1], 
             to=agelims[2])
# fits the model using a 3rd degree polynomial
lm.fit=lm(wage~poly(age,3), 
          data=Wage)
# gets predicted values using each value in the created age range
lm.pred=predict(lm.fit, 
                data.frame(age=age.grid))
lines(age.grid, 
      lm.pred, 
      col="blue", 
      lwd=2)
