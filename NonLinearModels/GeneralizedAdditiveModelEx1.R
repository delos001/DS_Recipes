set.seed(1)
library(ISLR)
library(leaps)

attach(College)

train = sample(length(Outstate), 
               length(Outstate)/2)
test = -train
College.train = College[train, ]
College.test = College[test, ]

reg.fit = regsubsets(Outstate ~ ., 
                     data = College.train, 
                     nvmax = 17, 
                     method = "forward")

reg.summary = summary(reg.fit)

par(mfrow = c(1, 3))
plot(reg.summary$cp, 
     xlab = "Number of Variables", 
     ylab = "Cp", 
     type = "l")

min.cp = min(reg.summary$cp)
std.cp = sd(reg.summary$cp)
abline(h = min.cp + 0.2 * std.cp, 
       col = "red", 
       lty = 2)
abline(h = min.cp - 0.2 * std.cp, 
       col = "red", 
       lty = 2)
plot(reg.summary$bic, 
     xlab = "Number of Variables", 
     ylab = "BIC", 
     type = "l")

min.bic = min(reg.summary$bic)
std.bic = sd(reg.summary$bic)
abline(h = min.bic + 0.2 * std.bic, 
       col = "red", 
       lty = 2)
abline(h = min.bic - 0.2 * std.bic, 
       col = "red", 
       lty = 2)
plot(reg.summary$adjr2, 
     xlab = "Number of Variables", 
     ylab = "Adjusted R2", 
     type = "l", 
     ylim = c(0.4, 0.84))

max.adjr2 = max(reg.summary$adjr2)
std.adjr2 = sd(reg.summary$adjr2)
abline(h = max.adjr2 + 0.2 * std.adjr2, 
       col = "red", 
       lty = 2)
abline(h = max.adjr2 - 0.2 * std.adjr2, 
       col = "red", 
       lty = 2)


# All cp, BIC and adjr2 scores show that size 6 is the minimum size 
# for the subset for which the scores are withing 0.2 standard deviations 
# of optimum. We pick 6 as the best subset size and find best 6 variables 
# using entire data.
reg.fit = regsubsets(Outstate ~ ., 
                     data = College, 
                     method = "forward")
coefi = coef(reg.fit, id = 6)
names(coefi)

# Fit a GAM on the training data, using out-of-state tuition as the 
# response and the features selected in the previous step as the predictors. 
# Plot the results, and explain your findings.
gam.fit = gam(Outstate ~ Private + 
              s(Room.Board, df = 2) + 
              s(PhD, df = 2) + 
              s(perc.alumni, df = 2) + 
              s(Expend, df = 5) + 
              s(Grad.Rate, df = 2), 
              data = College.train)

par(mfrow = c(2, 3))
plot(gam.fit, se = T, col = "blue")

# Evaluate the model obtained on the test set, and explain the results obtained.
gam.pred = predict(gam.fit, 
                   ollege.test)

gam.err = mean((College.test$Outstate - gam.pred)^2)
gam.err

gam.tss = mean((College.test$Outstate - mean(College.test$Outstate))^2)
test.rss = 1 - gam.err/gam.tss
# We obtain a test R-squared of 0.77 using GAM with 6 predictors. 
# This is a slight improvement over a test RSS of 0.74 obtained using OLS
test.rss


# For which variables, if any, is there evidence of a non-linear 
# relationship with the response?
# Non-parametric Anova test shows a strong evidence of non-linear 
# relationship between response and Expend, and a moderately strong 
# non-linear relationship (using p value of 0.05) between response and 
# Grad.Rate or PhD.
summary(gam.fit)
