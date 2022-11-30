funcname(input1, input2)

x=c(1,3,2,5)
x

x=c(1,6,2)
x
y=c(1,4,3)
y
?funcname
length(x)
length(y)
x+y
ls()
character
rm(list=ls())
ls()

y=c(1,2,3,4)
x=matrix(data=y,nrow=2, ncol=2)
x

rm(list=ls())
x=rnorm(50)
x
y=x+rnorm(50,mean=50,sd=0.1)
y
cor(x,y)

set.seed(1303)
rnorm(50)

set.seed(3)
y=rnorm(100)
mean(y)
var(y)
sqrt(var(y))

x=rnorm(100)
y=rnorm(100)
plot(x,y)
plot(x,y,xlab="this is xaxis",ylab="this is yaxis",main="Plot of X vs Y")

pdf("Figure.pdf")
plot(x,y,col="green")
dev.off()

x=seq(1,10)
x
x=seq(-pi,pi,length=50)
x

y=x
f=outer(x,y,function (x,y)cos(y)/(1+x^2))
contour(x,y,f)

contour(x,y,f,nlevels=45, add=T)

fa=(f-t(f))/2
contour (x,y,fa,nlevels=15)


image(x,y,fa)
persp(x,y,fa)
persp(x,y,fa,theta=30)
persp(x,y,fa,theta=30, phi=20)
persp(x,y,fa,theta=30, phi=70)
persp(x,y,fa,theta=30, phi=40)

A=matrix(1:16,4,4)
A
A[2,3]

A[c(1,3),c(2,4)]
A[1:3,2:4]
A[,1:2]
A[-c(1,3),]
A[-c(1,3),-c(1,3,4)]

auto=read.table("Auto.txt", header=T, na.strings="?")

dim(Auto)
dim(auto)
auto[1:4,]
data(auto)
head(auto)
names(auto)
plot(auto$cylinders, auto$mpg)

attach(auto)
cylinders=as.factor(cylinders)
plot(cylinders, mpg)
plot(cylinders, mpg, col="red")
plot(cylinders, mpg, col="red", varwidth=T)
plot(cylinders, mpg, col="red", varwidth=T, horizontal=T)
plot(cylinders, mpg, col="red", varwidth=T, xlab="cylinders", ylab="MPG")

hist(mpg)
hist(mpg, col=2)
hist(mpg, col=2, breaks=15)

pairs(auto)
pairs(~mpg+displacement+horsepower+weight+acceleration, auto)

plot(horsepower,mpg)
identify(horsepower, mpg, name)

summary(auto)
summary(auto$mpg)
summary(mpg)

college=read.csv("College.csv")
rownames(college)=college[,1]
college=college[,-1]
summary(college)
pairs(college)
pairs(college[,1:10])

attach(college)
Private=as.factor(Private)
plot(Private, Outstate)

Elite=rep("No",nrow(college))
Elite[college$Top10perc>50]="Yes"
Elite=as.factor(Elite)
college=data.frame(college,Elite)

summary(Elite)
plot(Elite, Outstate)

range(elite)
range(Elite)
range(mpg)
summary(auto)
sd(auto)
sd(mpg)
sd(Elite)
str(auto)

read.csv(college.csv)
library(MASS)
Boston
str(Boston)

pairs(Boston)
attach(Boston)
pairs(~tax + black, Boston)

y=x

f=outer(x,y,function(x,y)cos(y)/(1+x^2))
contour(x,y,f)
contour(x,y,f,nlevels=45,add=T)
fa=(f-t(f))/2
contour(x,y,fa,nlevels=15)

dim(iris)

dim(iris)
names(iris)
str(iris)
attributes(iris)
iris[1:5,]
head(iris)
quantile(iris$Sepal.Length)
quantile(iris$Sepal.Length, c(0.1, 0.3, 0.65))

par(mfrow = c(1,2))
hist(iris$Sepal.Length)
plot(density(iris$Sepal.Length))

table(iris$Species)
par(mfrow = c(1,2))
pie(table(iris$Species))
barplot(table(iris$Species))

cov(iris$Sepal.Length, iris$Petal.Length)
cov(iris[,1:4])

cor(iris$Sepal.Length, iris$Petal.Length)
cor(iris[,1:4])

aggregate(Sepal.Length ~ Species, summary, data=iris)

par(mfrow = c(1,3))
boxplot(Sepal.Length ~ Species, data=iris)
with(iris, plot(Sepal.Length, Sepal.Width, col=Species, pch=as.numeric(Species)))
plot(jitter(iris$Sepal.Length), jitter(iris$Sepal.Width))

par(mfrow = c(1,1))
pairs(iris)
library(scatterplot3d)
scatterplot3d(iris$Petal.Width, iris$Sepal.Length, iris$Sepal.Width)

distMatrix=as.matrix(dist(iris[,1:4]))
heatmap(distMatrix)
library(lattice)
levelplot(Petal.Width~Sepal.Length*Sepal.Width, iris, cuts=3, col.regions=grey.colors(10)[10:1])

par(mfrow = c(1,1))
filled.contour(volcano, color=terrain.colors, asp=1,
               plot.axes=contour(volcano, add=T))
persp(volcano, theta=25, phi=30, expand=0.5, col="lightblue")

library(MASS)
parcoord(iris[1:4], col=iris$Species)
library(lattice)

set.seed(3)
y=rnorm(100)
parallelplot(~iris[1:4] | Species, data=iris)