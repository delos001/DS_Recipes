

# IN THIS SCRIPT:
# DNORM
# PNORM
# QNORM
# RNORM

# use help() to find out more about each
# reads normAL var x where mean = 3, sd = 2 (variance = 4)
x<-seq(-5,10,by-0.1)
dnorm(x,mean=3,sd=2)
pnorm(x,mean=3,sd=2)
qnorm(x,mean=3,sd=2)
rnorm(x,mean=3,sd=2)

#----------------------------------------------------------
# DNORM: 
# dnorm: gets values on density function, 
dnorm(x, mean=3,sd=2^2): 

dnorm(0,0,1)   # out: 0.39423


# DNORM  to plot normal density curve
set.seed(124)
means<-replicate(1000,mean(sample(Nile,100,replace=TRUE)))
str(means)
mm<-mean(means)
x<-seq(min(means),max(means),1)
std<-sd(means)
hist(means,freq=FALSE, 
     xlab="Nile Flow",
     col='blue',
     main='Nile Flow Means \n1000 samples at n=100')

curve(dnorm(x,mean=mm,sd=std),col = "orange", 
      add=TRUE, lwd = 2)
abline(v=mm,col='red',lwd=2,lty=2)
