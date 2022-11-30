

# produces confidence intervals and prediction intervals 
#     (in this example, prediction interval is specified) for the 
#     specified values of the predictor variable, ie: lstat=c(5,10,15))
#	uses lm.fit model, sets the out put to a dataframe
# reads: the 95%  prediction interval associated with lstat value of 10 is (24.47, 25063)

predict(lm.fit, data.frame(lstat=c(5,10,15)), interval = "prediction")
