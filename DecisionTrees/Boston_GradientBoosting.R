library(gbm)

train=sample(1:nrow(Boston), nrow(Boston)/2)
set.seed(1)

boost.boston=gbm(medv~., data=Boston[train,],distribution="gaussian",
                 n.trees=5000, interaction.depth=4)


summary(boost.boston)


par(mfrow=c(1,2))
plot(boost.boston, i="rm")
plot(boost.boston, i="lstat")
par(mfrow=c(1,1))

yhat.boost=predict(boost.boston, newdata=Boston[-train,],n.trees=5000)
mean((yhat.boost-boston.test)^2)
