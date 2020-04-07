#Delosh, Jason Predict 401 SEC 60 Programming with R Test 2
require(moments)
#Q1a
x<-seq(0,6)

q1a1<-dbinom(x,100,0.01)
q1a2<-dpois(x,1.0)
q1a3<-dhyper(x,20,2000,100)

q1bind<-rbind(q1a1,q1a2,q1a3)

barplot(q1bind, beside = TRUE,
        main="Probability Outcome Distribution",
        xlab="Successes", ylab='Probability',
        col=c('red', 'green','blue'),
        legend.text=c('red=binomial','green=Poisson',
                      'blue=Hypergeometric'),
        args.legend=list(x=25,y=0.3),
        names.arg=c(x))

#Q1b 
#probabilities with binomial distribution
q1b1<-dbinom(50,100,0.5)
#probabilities with normal distribution and continuity correction
q1b2<-pnorm(50+0.5,50,sqrt(100*0.5*0.5),lower.tail = TRUE)-
  pnorm(50-0.5,50,sqrt(100*0.5*0.5),lower.tail=TRUE)

#probabilities with binomial distribution
q1b3<-pbinom(42,100,0.5, lower.tail=TRUE)
#probabilities with normal distribution: mean= np, stdev=sqrt(npq)
q1b4<-pnorm(42+0.5,50,sqrt(100*0.5*0.5), lower.tail=TRUE)

#probabilities with binomial distribution
q1b5<-pbinom(58,100,0.5, lower.tail=FALSE)
#probabilities with normal distribution: mean= np, stdev=sqrt(npq)
q1b6<-pnorm(58-0.5,50,sqrt(100*0.5*0.5), lower.tail=FALSE)

q1bind<-cbind(c('i','ii','iii'),
              rbind(c(q1b1,q1b2),c(q1b3,q1b4),c(q1b5,q1b6)))
colnames(q1bind)<-c('problem','binomial','normal')
q1bind

#Q1c
n<-100
p<-0.01
q1cEv1<-sum(dbinom(seq(0,n),n,p)*seq(0,n))
q1cEv2<-(n*p)
q1cVar1<-sum(((q1cEv1-(seq(0,n)))^2)*dbinom(seq(0,n),n,p))
q1cVar2<-n*p*(1-p)
sprintf ('Expected Value Using dbinom: %s', q1cEv1)
sprintf ('Expected Value Using 100*0.01: %s', q1cEv2)
sprintf ('Variance Using dbinom: %s', q1cVar1)
sprintf ('Variance Using 100*0.01*(1-0.01): %s', q1cVar2)


#Q2
set.seed(1234)
q2a<-rexp(n=100,rate=1)

par(mfrow=c(1,2))
boxplot(q2a, col = "blue", range = 1.5, 
        main = "Random Exponential Sample", 
        ylab = "Magnitude", notch = TRUE)

qqnorm(q2a,
        ylab='Random Exponential Sample Quantiles',
        main='QQ Plot of Random Exponential \n Sample (n=100)',
        col='red')
qqline(q2a,col='green')

boxplot.stats(q2a)

par(mfrow=c(1,1))

#Q2b
boxplot.stats(q2a,coef=1.5,do.conf = TRUE, do.out = TRUE)
boxplot.stats(q2a,coef=3.0,do.conf = TRUE, do.out = TRUE)
quantile(q2a,0.75)+1.5*IQR(q2a)
quantile(q2a,0.75)+3.0*IQR(q2a)

#Q2c
x<-q2a
y <- 3*((x^(1/3)) - 1)
par(mfrow=c(1,2))
boxplot(y, col = "blue", range = 1.5, 
        main = "Random Exponential Sample with \n Box-Cox Trans", 
        ylab = "Magnitude", notch = TRUE)

qqnorm(y,
       ylab='Sample Quantiles',
       main='QQ Plot of Random Exponential \n Box-Cox Trans (n=100)',
       col='red')
qqline(y,col='green')
par(mfrow=c(1,1))

boxplot.stats(y,coef=1.5,do.conf = TRUE, do.out = TRUE)
boxplot.stats(y,coef=3.0,do.conf = TRUE, do.out = TRUE)
quantile(y,0.75)+1.5*IQR(y)
quantile(y,0.75)+3.0*IQR(y)

#Q3
data(ChickWeight)
index <- (ChickWeight$Time == 21)&((ChickWeight$Diet == "1")|(ChickWeight$Diet == "3"))
result <- subset(ChickWeight[index,], select = c(weight, Diet))
result$Diet <- factor(result$Diet)
str(result)

t.test(result$weight~result$Diet,alternative=c('two.sided'),
       mu=0,paired=FALSE,
       var.equal = TRUE, conf.level=0.95)

data(ChickWeight)
index <- (ChickWeight$Diet == "3")
pre <- subset(ChickWeight[index,], Time == 20, 
              select = c(weight))$weight
post <- subset(ChickWeight[index,], Time == 21, 
               select = c(weight))$weight

plot (pre,post, main='Diet 3 Weight: Time=20 vs. Time=21',
      col='blue',pch=20,
      xlab='Weight Time=20',ylab='Weight Time=21')

var(pre)
var(post)
var(post-pre)

#Q3c
change<-mean(post)-mean(pre)
std<-sd(post-pre)
change
error<-qt(0.975, df=length(pre)-1)*std/sqrt(length(pre))
ci<-c(change-error,change+error)
ci

#Q4a
data(Nile)
m <- mean(Nile)
std <- sd(Nile)
x <- seq(400, 1400,1)
hist(Nile, freq = FALSE, col = "darkblue", xlab = "Flow",
    main = "Histogram of Nile River Flows 1871 to 1970")
curve(dnorm(x, mean=m, sd=std), col="orange", lwd=2, add=TRUE)

par(mfrow=c(1,2))
qqnorm(Nile, main='Q-Q Plot: Nile River \n Flows 1871 to 1970',
       ylab='Sample Quantiles for Nile River Flows',
       col='blue')
qqline(Nile,col='red')

boxplot(Nile, main='Boxplot: Nile River \n Flows 1871 to 1970',
        ylab='Magnitude Nile River Flows',
        notch=TRUE,col='light blue', range=1.5)
par(mfrow=c(1,1))

boxplot.stats(Nile, coef=1.5, do.conf=TRUE, do.out=TRUE)

#Q4b
set.seed(124)
mean.q4b <- numeric(0)
N <- 10000
for (k in 1:N){
  mean.q4b[k] <- mean(sample(Nile, 25, replace = TRUE))
}
mm<-mean(mean.q4b)
x<-seq(min(mean.q4b),max(mean.q4b),1)
std<-sd(mean.q4b)
hist(mean.q4b,freq=FALSE, 
     xlab="Nile Flow", ylim=c(0,0.013),
     col='blue',
     main='Nile Flow Means \n1000 samples at n=25')

curve(dnorm(x,mean=mm,sd=std),col = "orange", 
      add=TRUE, lwd = 2)
abline(v=mm,col='red',lwd=2,lty=2)
legend("top", legend = c("mean = 918.9","standard deviation = 33.8"))
smeanstat<-c(mm, std)
smeanstat

#Q4c
set.seed(127)

mean.q4c <- numeric(0)
N <- 10000
for (k in 1:N){
  mean.q4c[k] <- mean(sample(Nile, 100, replace = TRUE))
}
mm<-mean(mean.q4c)
x<-seq(min(mean.q4c),max(mean.q4c),1)
std<-sd(mean.q4c)
hist(mean.q4c,freq=FALSE, 
     xlab="Nile Flow",
     col='blue',
     main='Nile Flow Means \n1000 samples at n=100')

curve(dnorm(x,mean=mm,sd=std),col = "orange", 
      add=TRUE, lwd = 2)
abline(v=mm,col='red',lwd=2,lty=2)

smeanstat<-c(mm, std)
smeanstat




#Q5
#q5a
data(Seatbelts)
Seatbelts <- as.data.frame(Seatbelts)
Seatbelts$Month <- seq(from = 1, to = nrow(Seatbelts))
Seatbelts <- subset(Seatbelts, select = c(DriversKilled, Month))
summary(Seatbelts)
killed <- factor(Seatbelts$DriversKilled > 118.5, labels = c("below", "above"))
month <- factor(Seatbelts$Month > 96.5, labels = c("below", "above"))

library(ggplot2)
ddata<-median(Seatbelts$DriversKilled)
mdata<-median(Seatbelts$Month)
ggplot(Seatbelts,aes(x=Seatbelts$Month,y=Seatbelts$DriversKilled))+
  geom_point(size=2, aes(color=killed))+ 
  geom_hline(aes(yintercept=median(Seatbelts$DriversKilled, na.rm=TRUE), 
                 color='Median_Killed'),linetype="dashed")+
  geom_vline(aes(xintercept=median(Seatbelts$Month, na.rm=TRUE), 
                 color='Median_Month'),linetype='dashed')+
  xlab('Month (1969-1984')+ylab('Drivers Killed')+
  ggtitle("Monthly Casualties, Britian 1969-84")

#q5b
q5b<-with(Seatbelts,table(month,killed))
addmargins(q5b)
chisq.test(q5b, correct=FALSE)
chisq.test(q5b, correct=FALSE)$expected

#q5c

r1 <- c(37,59)
r2 <- c(59, 37)
coef <- (rbind(r1,r2))
v <- c(96, 96)
result(coef,v)

coef%*%result(coef,v)

o <- as.table(rbind(c(37,59),c(59,37)))
x <- addmargins(o)
x

e11 <- x[3,1]*x[1,3]/x[3,3]
e12 <- x[3,2]*x[1,3]/x[3,3]
e21 <- x[3,1]*x[2,3]/x[3,3]
e22 <- x[3,2]*x[2,3]/x[3,3]

exp<-c(e11, e12, e21, e22)
e<-matrix(exp,nr=2,byrow=T)
e

x<-sum((o-e)**2/e)
mychi<- function(x){


  if (x>qchisq(0.95,df=1)) {
      answer<-c("Reject Null Hypothesis")
  }
  else {
      answer<-c("Do Not Reject Null Hypothesis")
  }
  return(answer)
}
stat
answer

  
mychi<- function(x){
  
  
  if (x>qchisq(0.95,df=1)) {
    answer<-c(stat, "Reject Null Hypothesis")
  }
  else {
    answer<-c(stat, "Do Not Reject Null Hypothesis")
  }
  return(answer)
  return(stat)
}
  
  
  