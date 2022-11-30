

# PREDICT 422 Practical Machine Learning
# Perceptron Learning Algorithm (Threshold Logic Unit)


import numpy as np
import matplotlib.pyplot as plt
import random

# Define the Class "Perceptron"
class Perceptron:
def __init__(self):
"""This function initializes the Perceptron class"""

# Initialize weights to 0 and 0.4, threshold to 0.3, and learning rate to 0.25
self.wgt = [0, 0.4]
self.threshold = 0.3
self.learningRate = 0.25

def perceptronResponse(self, x):
"""This function computes the activation a and compares it to the threshold
value. If a >= threshold, then return perceptron response of 1. Otherwise,
if a < threshold, then return perceptron response of 0.
"""

# Compute the activation (inner product of weight vector and input vector)
a = x[0] * self.wgt[0] + x[1] * self.wgt[1]

# Compare the activation with threshold, and assign 0 or 1 (the perceptron output y)
if a >= self.threshold:
return 1
else:
return 0

def updateWeightVector(self, x, error):
"""This function updates the vector of weights, such that:
wgt' = wgt + learningRate * (t - y) * x,
where t is the desired output and y is the perceptron output,
and error is defined as (t - y)
"""

# Update the weight vector 
self.wgt[0] += self.learningRate * error * x[0]
self.wgt[1] += self.learningRate * error * x[1]

def training(self, trainingSet):
"""This function uses the training set to learn. Ensure that
the vectors contain three elements for x1, x2, and t.
"""

count = 1
# Training stops after looping over ALL training samples
for x in trainingSet:

# Get the Perceptron response (output y)
y = self.perceptronResponse(x)

# If the Perceptron output (y) equals the desired output (t)
if x[2] == y:
# Set error = x[2] - y = 0
error = 0

# Plot the point to show how classified (colored blue for correct Perception output) 
plt.plot(x[0], x[1], 'sb')
# If the Perceptron output (y) does not equal the desired output (t)
else: 
# Then compute the error (t - y)
error = x[2] - y

# Update the weights
self.updateWeightVector(x, error)

# Plot the point to show how classified (colored red for incorrect Perception output)
plt.plot(x[0], x[1], 'sr') 

# Print information about the sample
print "Sample: (", x[0], ",", x[1], ") | Desired Output:", x[2], "| Perceptron Output:", y, "| Error:", error, "| Weight:", self.wgt

# Plot the sample points every 5th record in the training set 
if count % 5 == 0:
plt.xlabel('x1')
plt.ylabel('x2')
plt.title('Training Set Results')
plt.axis([-0.5, 1.5, -0.5, 1.5])
plt.grid(True)
plt.show()
count += 1

# Plot the possible training set points and separating hyperplane (i.e. linear classifier)
xx = np.arange(0., 1.5, 0.01)
yy = (self.threshold / self.wgt[1]) - (self.wgt[0]/self.wgt[1])*xx
plt.xlabel('x1')
plt.ylabel('x2')
plt.title('Perceptron Linear Classifier')
plt.plot(0, 0, 'sr')
plt.annotate('0', xy = (0,0), 
             xytext = (.1, .1), 
             arrowprops = dict(arrowstyle = '->'))
plt.plot(0, 1, 'sr')
plt.annotate('0', xy = (0,1), 
             xytext = (.1, .9), 
             arrowprops = dict(arrowstyle = '->'))
plt.plot(1, 0, 'sr')
plt.annotate('0', xy = (1,0), 
             xytext = (.9, .1), 
             arrowprops = dict(arrowstyle = '->'))
plt.plot(1, 1, 'sb')
plt.annotate('1', xy = (1,1), 
             xytext = (.9, .9), 
             arrowprops = dict(arrowstyle = '->'))
line1, = plt.plot(xx, yy, 'm--')
plt.axis([-0.2, 1.2, -0.2, 1.2])
plt.legend([line1], ['TLU Linear Classifier'], loc = "center left")
plt.grid(True)
plt.show()

# This function generates a random dataset 
def generateSample(n):
""" Generate a 2-dimensional dataset with n samples, where
the sample contains x1, x2 and t. Possible sample values are from
logical AND function (0, 0, 0), (1, 0, 0), (0, 1, 0), and (1, 1, 1).
"""

sample = []
for i in range(0, n):
x1 = random.random()
x2 = random.random()

if x1 <= 0.5: x1 = 0
else: x1 = 1
if x2 <= 0.5: x2 = 0
else: x2 = 1

if (x1 and x2 == 1): t = 1
else: t = 0

sample.append([x1, x2, t]) 

return sample

# Generate a training set
try:
train = int(raw_input("Enter the number records in the training set: "))
except ValueError:
print "Not a number!!!!"
trainingSet = generateSample(train)

# Create a Perceptron class instance
perceptronInstance = Perceptron()

# Execute the Perceptron Learning Algorithm to learn from the training set
print ""
print ""
print "TRAINING SET RESULTS - PERCEPTRON LEARNING ALGORITHM"
perceptronInstance.training(trainingSet)

# Generate a test set
print ""
print ""
try:
test = int(raw_input("Enter the number records in the test set: "))
except ValueError:
print "Not a number!!!!"
testSet = generateSample(test)

# Run the Perception test on the test set
print ""
print ""
print "TEST SET RESULTS - PERCEPTRON LEARNING ALGORITHM"
for sample in testSet:
y = perceptronInstance.perceptronResponse(sample)
if y != sample[2]:
print "Error!!!!!"
if y == 1:
print "(x1, x2) = (", sample[0], ", ", sample[1], "), t = ", sample[2], "--> y = ", y, " (Color = Blue)"
plt.plot(sample[0], sample[1], "ob")
else:
print "(x1, x2) = (", sample[0], ", ", sample[1], "), t = ", sample[2], "--> y = ", y, " (Color = Red)"
plt.plot(sample[0], sample[1], "or")
plt.xlabel('x1')
plt.ylabel('x2')
plt.title('Test Set Results')
plt.axis([-0.5, 1.5, -0.5, 1.5])
plt.grid(True)
plt.show()
