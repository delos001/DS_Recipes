

#  write a short function to plot an ROC curve given a vector 
#   containing a numerical score for each observation, pred, 
#   and vector containing class label for each observation, truth
library(ROCR)
rocplots = function(pred, truth, ...){
  predob = prediction(pred, truth)  # stores whether predicted value = actual value (did it predict correctly)

  perf = performance(predob, "tpr", "fpr")  # tpr= true positive rate, fpr=false positive rate
  plot(perf, ...)
}


# SVMs and support vector classifiers output class labels for each observation. 
# However, it is also possible to obtain fitted values for each observation, which 
# are the numerical scores used to obtain the class labels. For an SVM with a 
# non-linear kernel, the equation that yields the fitted value is given in (9.23). 
# In essence, the sign of the fitted value determines on which side of the decision 
# boundary the observation lies.

# fit a svm on training data set using a radial kernel, gamma value of 2, and cost of 1.  
# decision.values=T is desribed above
svmfit.opt=svm(y~., 
               data=dat[train,], 
               kernel="radial", 
               gamma=2,
               cost=1, 
               decision.values=TRUE)
# create fitted values variable:  gets predicted values of model
fitted=attributes(predict(svmfit.opt, 
                          dat[train,], 
                          decision.values = TRUE)
                 )$decision.values


par(mfrow=c(1,2))
# plot the ROC plot using the model and using the function we created above.
rocplot(fitted, 
        dat[train,"y"], 
        main="Training Data")

# repeate the model but use a higher gamma value to produce a more flexible fit
svmfit.flex=svm(y~., 
                data=dat[train,], 
                kernel ="radial",
                gamma=50, 
                cost=1, 
                decision.values = T)

fitted=attributes(predict(svmfit.flex,dat[train ,],  # get the fitted values again
                          decision.values=T))$decision.values

# plot the new roc curve, where you add it to the existing plot 
# and color it red to distinguish from previous plot
rocplot (fitted,
         dat[train,"y"], 
         add =T,
         col = "red ")

# code above is repeated except applied to test data and ROC plot created
fitted=attributes(predict(svmfit.opt, 
                          dat[-train,],
                          decision.values = TRUE)
                 )$decision.values
rocplot(fitted, 
        dat[-train,"y"], 
        main = "Test Data")
fitted=attributes(predict(svmfit.flex,
                          dat[-train,],
                          decision.values = TRUE)
                 )$decision.values
rocplot(fitted, 
        dat[-train,"y"], 
        add=TRUE, 
        col="red")
