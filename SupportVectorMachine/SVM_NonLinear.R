
# StatsLearning Lect12 R SVM B 111213
# https://www.youtube.com/watch?v=L3n2VF7yKkk&feature=youtu.be
#   IMPORTANT: view this video as it has better code to 
#   get better graphs than what are in the standard svm library


library(e1071)

set.seed(1)

# create 2 column matrix 200 rows filled with randomly generated number
x=matrix(rnorm(200*2), ncol=2)
x[1:100,]=x[1:100,]+2  # for first hundred rows (1:100), set x to x+2
x[101:150,]=x[101:150,]-2
y=c(rep(1,150), rep(2,50))
dat=data.frame(x=x, y=as.factor(y))

plot(x, col=y)

train=sample(200,100)
svmfit=svm(y~., data=dat[train,], kernel="radial", gamma=1, cost=1)




plot(svmfit, dat[train,])



















summary(svmfit)

svmfit=svm(y~., data=dat[train,], kernel="radial", gamma=1, cost=1e5)
plot(svmfit, dat[train,])


















set.seed(1)
tune.out=tune(svm, y~., data=dat[train,], kernel="radial",
              ranges=list(cost=c(0.1, 1, 10, 100, 1000),
                          gamma=c(0.5, 1, 2, 3, 4)))
summary(tune.out)
names(tune.out)

table(true=dat[-train,"y"], pred=predict(tune.out$best.model,
                        newdata=dat[-train,]))
