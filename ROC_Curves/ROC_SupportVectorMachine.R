# SVMs and support vector classifiers output class labels for each observation. 
# However, it is also possible to obtain fitted values for each observation, 
# which are the numerical scores used to obtain the class labels. 
# For an SVM with a non-linear kernel, the equation that yields the fitted value 
# is given in (9.23). In essence, the sign of the fitted value determines on which 
# side of the decision boundary the observation lies.

# Therefore, the relationship between the fitted value and the class prediction for 
# a given observation is simple: if the fitted value exceeds zero then the observation 
# is assigned to one class, and if it is less than zero then it is assigned to the other. 
# In order to obtain the fitted values for a given SVM model fit, we use 
# decision.values=TRUE when fitting svm(). Then the predict() function will output the 
# fitted values.


library(ROCR)

# We first write a short function to plot an ROC curve given a vector 
# containing a numerical score for each observation, pred, and a vector 
# containing the class label for each observation, truth
rocplots=function(pred, truth, ...){
  predob=prediction(pred, truth)
  perf=performance(predob, "tpr", "fpr")  # true positive rate, false positive rate
  plot(perf, ...)
}


# fit a svm on the training data set using a radial kernel, gamma value of 2, 
# and cost of 1.  decision.values=T is desribed above
svmfit.opt=svm(y~., data=dat[train,], kernel="radial", gamma=2,
               cost=1, decision.values=TRUE)

# create fitted values variable:  
#   this gets the predicted values of the model above 
#   (from the training data of the data set).
fitted=attributes(predict(svmfit.opt, dat[train,], 
                          decision.values = TRUE))$decision.values

par(mfrow=c(1,2))
# plot the ROC plot using the model function we created above
rocplot(fitted, dat[train,"y"], main="Training Data")

# repeate the model but use a higher gamma value to produce a more flexible fit
svmfit.flex=svm(y~., data=dat[train,], kernel ="radial",
                    gamma=50, cost=1, decision.values=T)
fitted=attributes(predict(svmfit.flex,dat[train ,],
                          decision.values=T))$decision.values

# plot new roc curve
# add it to the existing plot and color it red to distinguish from previous plot
rocplot (fitted,
         dat[train,"y"], 
         add =T,
         col ="red ")

# the code above is repeated except it is applied to test data and 
# ROC plot is created on the results.
fitted=attributes(predict(svmfit.opt, dat[-train,],
                          decision.values=TRUE))$decision.values
rocplot(fitted, dat[-train,"y"], main="Test Data")
fitted=attributes(predict(svmfit.flex,dat[-train,],
                          decision.values = TRUE))$decision.values
rocplot(fitted, dat[-train,"y"], add=TRUE, col="red")
