

# Example 3: Create a ANN for classification

# Predict the identification of Iris plant Species on the basis of plant 
# attribute measurements: Sepal.Length, Sepal.Width, Petal.Length, Petal.Width

library(RSNNS)

# Load and store the 'iris' data
data(iris)

# Generate a sample from the 'iris' data set
irisSample <- iris[sample(1:nrow(iris), length(1:nrow(iris))), 1:ncol(iris)]
irisValues <- irisSample[, 1:4]
head(irisValues)
irisTargets <- irisSample[, 5]
head(irisTargets)

# Generate a binary matrix from an integer-valued input vector representing class labels
irisDecTargets <- decodeClassLabels(irisTargets)
head(irisDecTargets)

# Split the data into the training and testing set, and then normalize
irisSample <- splitForTrainingAndTest(irisValues, irisDecTargets, ratio = 0.15)
irisSample <- normTrainingAndTestSet(irisSample)

# Train the Neural Network (Multi-Layer Perceptron)
nn3 <- mlp(irisSample$inputsTrain, irisSample$targetsTrain, size = 2, learnFuncParams = 0.1, maxit = 100, 
	inputsTest = irisSample$inputsTest, targetsTest = irisSample$targetsTest)
print(nn3)

# Predict using the testing data
testPred6 <- predict(nn3, irisSample$inputsTest)

# Calculate the Confusion Matrices for the Training and Testing Sets
confusionMatrix(irisSample$targetsTrain, fitted.values(nn3))
confusionMatrix(irisSample$targetsTest, testPred6)

# Calculate the Weights of the Newly Trained Network
weightMatrix(nn3)

# Plot the Iterative Error of both training (black) and test (red) error
# This shows hows the Number of Iterations Affects the Weighted SSE
plotIterativeError(nn3, main = "# of Iterations vs. Weighted SSE")
legend(80, 80, legend = c("Test Set", "Training Set"), col = c("red", "black"), pch = 17)

# See how changing the Learning Rate Affects the Average Test Error
err <- vector(mode = "numeric", length = 10)
learnRate = seq(0.1, 1, length.out = 10)
for (i in 10){
	fit <- mlp(irisSample$inputsTrain, irisSample$targetsTrain, size = 2, learnFuncParams = learnRate[i], maxit = 50, 
	  inputsTest = irisSample$inputsTest, targetsTest = irisSample$targetsTest)
	err[i] <- mean(fit$IterativeTestError)
}

# Plot the Effect of Learning Rate vs. Average Iterative Test Error
plot(learnRate, err, xlab = "Learning Rate", ylab = "Average Iterative Test Error",
	main = "Learning Rate vs. Average Test Error", type = "l", col = "brown")
