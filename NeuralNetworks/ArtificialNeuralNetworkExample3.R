# Example 2: Create a ANN for prediction

# We give a brief example of regression with neural networks and comparison with
# multivariate linear regression. The data set is housing data for 506 census tracts of
# Boston from the 1970 census. The goal is to predict median value of owner-occupied homes.

# Load the data and inspect the range (which is 1 - 50)
library(mlbench)
data(BostonHousing)
summary(BostonHousing$medv)

# Build the multiple linear regression model
lm.fit <- lm(medv ~ ., data = BostonHousing)
lm.predict <- predict(lm.fit)

# Calculate the MSE and plot
mean((lm.predict - BostonHousing$medv)^2) # MSE = 21.89483
par(mfrow = c(2,1))
plot(BostonHousing$medv, lm.predict, 
     main = "Linear Regression Predictions vs Actual (MSE = 21.9)", 
     xlab = "Actual", 
     ylab = "Predictions", 
     pch = 19, 
     col = "brown")

# Build the feed-forward ANN (w/ one hidden layer)
library(nnet)        # For Neural Network
nnet.fit <- nnet(medv/50 ~ ., 
                 data = BostonHousing, 
                 size = 2) # scale inputs: divide by 50 to get 0-1 range
nnet.predict <- predict(nnet.fit)*50 # multiply 50 to restore original scale

# Calculate the MSE and plot 
mean((nnet.predict - BostonHousing$medv)^2) # MSE = 16.56974
plot(BostonHousing$medv, 
     nnet.predict, main = "Artificial Neural Network Predictions vs Actual (MSE = 16.6)",
     xlab = "Actual", 
     ylab = "Predictions",
     pch = 19, 
     col = "blue")

# Next, we use the function train() from the package caret to optimize the ANN 
# hyperparameters decay and size, Also, caret performs resampling to give a better 
# estimate of the error. We scale linear regression by the same value, so the error 
# statistics are directly comparable.

library(mlbench)
data(BostonHousing)
library(caret)

# Optimize the ANN hyperpameters and print the results
mygrid <- expand.grid(.decay = c(0.5, 0.1), 
                      .size = c(4, 5, 6))
nnet.fit2 <- train(medv/50 ~ ., 
                   data = BostonHousing, 
                   method = "nnet", 
                   maxit = 1000, 
                   tuneGrid = mygrid, 
                   trace = FALSE)
print(nnet.fit2)

# Scale the linear regression and print the results
lm.fit2 <- train(medv/50 ~ ., 
                 data = BostonHousing, 
                 method = "lm") 
print(lm.fit2)
