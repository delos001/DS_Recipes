

example using rpart library

library(rpart)
car.test.frame

# sets variable containing the decision tree splits:
x=rpart(car.test.frame[,c(1,4,6,7,8)],cp=0)  



predict(x)
cor(car.test.frame[,1],predict(x))^2

par(mai=c(0.1, 0.1, 0.1, 0.1))

# this will produce a plot of a tree with branches
plot(x, main="Regression Tree: car.test.frame", col=3, compress=TRUE, branch=0.2,
     uniform=TRUE)

# puts the values and the numbser on lines and in boxes
text(x, cex=0.6, col=4, use.n = TRUE, fancy = TRUE, fwidth = 0.4, fheight = 0.4, bg=c(5))
