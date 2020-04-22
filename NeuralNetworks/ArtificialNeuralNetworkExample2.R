

## Example 1: Create a ANN to perform square rooting

library(neuralnet)  # For Neural Network

# Generate 50 random numbers uniformly distributed between 0 and 100
# and store them as a dataframe
traininginput <-  as.data.frame(runif(50, 
                                      min = 0, 
                                      max = 100))
trainingoutput <- sqrt(traininginput)

# Column bind the data into one variable
trainingdata <- cbind(traininginput,trainingoutput)
colnames(trainingdata) <- c("Input","Output")

# Train the neural network
# Going to have 10 hidden layers
# Threshold is a numeric value specifying the threshold for the partial
# derivatives of the error function as stopping criteria.
net.sqrt <- neuralnet(Output ~ Input, 
                      trainingdata, 
                      hidden = 10, 
                      threshold = 0.01)
print(net.sqrt)

# Plot the neural network
plot(net.sqrt)

# Test the neural network on some training data
testdata <- as.data.frame((1:10)^2) # generate some squared numbers
net.results <- compute(net.sqrt, 
                       testdata) # run them through the neural network

# Let's see what properties net.sqrt has
ls(net.results)

# Let's see the results
print(net.results$net.result)

# Let's display a better version of the results
cleanoutput <- cbind(testdata,sqrt(testdata), 
                     as.data.frame(net.results$net.result))
colnames(cleanoutput) <- c("Input","Expected Output","Neural Net Output")
print(cleanoutput)
