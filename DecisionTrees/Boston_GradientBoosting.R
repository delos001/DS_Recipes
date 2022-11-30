
# GBM library example

# Other examples:
# from ISLR: http://blog.princehonest.com/stat-learning/ch8/10.html
# another example, Q11 on ISLR p335: 
#   this one predicts based on probabilities greater than specified threshold:
#   http://blog.princehonest.com/stat-learning/ch8/11.html




# distribution="gaussian" since this is a regression problem; 
# if it were a binary classification problem, we would use distribution="bernoulli".



library(gbm)

train = sample(1:nrow(Boston), nrow(Boston)/2)
set.seed(1)


# boost model to predict the medv, using Boston data on the train set:  
#     distribution: distribution="gaussian" since this is a regression problem;  
#     if it were a binary classification problem, we would use 
#         distribution="bernoulli".  
# Interaction.depth limits the depth of each tree
boost.boston = gbm(medv~., 
                   data=Boston[train,],
                   distribution = "gaussian",
                   n.trees = 5000, 
                   interaction.depth = 4)


summary(boost.boston)  # produces summary and a plot


# We see that lstat and rm are by far the most important variables. 
# We can also produce partial dependence plots for these two variables. 
# These plots illustrate the marginal effect of the selected variables 
#     on the response after integrating out the other variables.  
# In these plots, median house prices are increasing with rm and decreasing with lstat
par(mfrow=c(1,2))
plot(boost.boston, i="rm")
plot(boost.boston, i="lstat")
par(mfrow=c(1,1))

# predict the values using the boosted model to predict on the test data
yhat.boost=predict(boost.boston, 
                   newdata = Boston[-train,],
                   n.trees = 5000)

mean((yhat.boost-boston.test)^2)  # get the MSE: 11.8
