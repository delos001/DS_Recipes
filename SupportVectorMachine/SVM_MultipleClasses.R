# EXAMPLE FROM ISLR BOOK

library(e1071)

set.seed(1)

# add 50 more values in each column to existing x matrix (
#   see SVM non linear for original x matrix)
x = rbind(x,matrix(rnorm(50*2), ncol=2))

# at 50 more values to existing y vector 
#   (see SVM non linear for original y vector)
y=c(y,rep(0,50))

# when y is 0 or 2, x is x+2, else it is just the original x value
x[y==0,2]=x[y==0,2]+2

dat=data.frame(x=x, y=as.factor(y))
par(mfrow=c(1,1))
# plot x values, color by y values 
# (y is either 0, 1, or 2 so add 1 to each y value gives it a different color)
plot(x, col = (y+1))

# create svm model for the three classes
svmfit=svm(y~., data=dat, kernel="radial", cost=10, gamma=1)
plot(svmfit, dat)
