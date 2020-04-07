
library(rpart)
car.test.frame
x=rpart(car.test.frame[,c(1,4,6,7,8)],cp=0)
predict(x)
cor(car.test.frame[,1],predict(x))^2

par(mai=c(0.1, 0.1, 0.1, 0.1))
plot(x, main="Regression Tree: car.test.frame", col=3, compress=TRUE, branch=0.2,
     uniform=TRUE)
text(x, cex=0.6, col=4, use.n = TRUE, fancy = TRUE, fwidth = 0.4, fheight = 0.4, bg=c(5))

clustreg.cars.1=clustreg(car.test.frame[,c(1,4,5,6,7,8)],1,1,1121,1)
clustreg.cars.2=clustreg(car.test.frame[,c(1,4,5,6,7,8)],2,1,1121,10)
clustreg.cars.3=clustreg(car.test.frame[,c(1,4,5,6,7,8)],3,24,1121,10)

args(clustreg)
function(dat,k,tries,sed,niter)

