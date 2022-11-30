library(ISLR)
fix(Hitters)
dim(Hitters)
Hitters[1:4,]
head(Hitters)
tail(Hitters)
attributes(Hitters)

sum(is.na(Hitters$Salary))
sum(is.na(Hitters))
Hitters=na.omit(Hitters)
sum(is.na(Hitters))
dim(Hitters)


library(leaps)
regfit.full = regsubsets(Salary~., Hitters)
summary(regfit.full)

regfit.full = regsubsets(Salary~., data=Hitters, nvmax=19)
reg.summary=summary(regfit.full)
reg.summary

names(reg.summary)
reg.summary$rsq
reg.summary$adjr2
reg.summary$which

par(mfrow =c(2,2))
plot(reg.summary$rss , xlab=" Number of Vars ",ylab=" RSS", type="l")

plot(reg.summary$adjr2 , xlab =" Number of Vars ", ylab=" Adj RSq",type="l")
which.max(reg.summary$adjr2)
points(11, reg.summary$adjr2[11], col="red", cex=2, pch=20)

plot(reg.summary$cp, xlab="Number of Vars", ylab="CP", type="l")
which.min(reg.summary$cp)
points(10, reg.summary$cp[10], col="red", cex=2, pch=20)

plot(reg.summary$bic, xlab="Number of Vars", ylab="BIC", type="l")
which.min(reg.summary$bic)
points(6, reg.summary$bic[6], col="red", cex=2, pch=20)

par(mfrow=c(1,1))


plot(regfit.full, scale="r2")
plot(regfit.full, scale="adjr2")
plot(regfit.full, scale="Cp")
plot(regfit.full, scale="bic")


coef(regfit.full, 6)
summary(regfit.full, 6)

#forward and backward

regfit.fwd=regsubsets(Salary~., data=Hitters ,nvmax=19, method = "forward")
summary(regfit.fwd)
regfit.bwd=regsubsets(Salary~., data=Hitters ,nvmax=19, method = "backward")
summary(regfit.bwd)

coef(regfit.fwd, 7)
coef(regfit.bwd, 7)

reg.sumfwd = summary(regfit.fwd)
reg.sumfwd
names(reg.sumfwd)

names(reg.sumfwd)
reg.sumfwd$rsq
reg.sumfwd$adjr2

par(mfrow=c(2,2))
plot(reg.sumfwd$rsq, xlab="#Vars", ylab="Rsq", type="l")
plot(reg.sumfwd$adjr2, xlab="#Vars", ylab="adjr2", type="l")
points(which.max(reg.sumfwd$adjr2), reg.sumfwd$adjr2[which.max(reg.sumfwd$adjr2)], col="red",
       cex=2, pch=20)

plot(reg.sumfwd$cp, xlab="#Vars", ylab="cp", type="l")
points(which.min(reg.sumfwd$cp), reg.sumfwd$cp[which.min(reg.sumfwd$cp)], col="red",
       cex=2, pch=20)

plot(reg.sumfwd$bic, xlab="#Vars", ylab="bic", type="l")
points(which.min(reg.sumfwd$bic), reg.sumfwd$bic[which.min(reg.sumfwd$bic)], col="red",
       cex=2, pch=20)

par(mfrow=c(1,1))

plot(regfit.fwd, scale="r2")
plot(regfit.fwd, scale="adjr2")
plot(regfit.fwd, scale="Cp")
plot(regfit.fwd, scale="bic")

set.seed (1)
train=sample (c(TRUE ,FALSE), nrow(Hitters ),replace = TRUE)
test =(!train )

regfit.best=regsubsets(Salary~., data=Hitters[train,], nvmax=19)

test.mat=model.matrix(Salary~., data=Hitters[test,])

val.errors=rep(NA,19)
for (i in 1:19){
  coefi=coef(regfit.best, id=i)
  pred=test.mat[,names(coefi)]%*%coefi
  val.errors[i] = mean((Hitters$Salary[test]-pred)^2)
}
val.errors
which.min(val.errors)
coef(regfit.best, 10)

predict.regsubsets = function(object, newdata, id, ...){
  form=as.formula(object$call[[2]])
  mat=model.matrix(form, newdata)
  coefi=coef(object, id=id)
  xvars=names(coefi)
  mat[,xvars]%*%coefi
}

regfit.best=regsubsets(Salary~., data=Hitters, nvmax=19)
coef(regfit.best,10)

k=10
set.seed(1)
folds=sample(1:k, nrow(Hitters), replace=TRUE)

cv.errors=matrix(NA, k, 19, dimnames=list(NULL, paste(1:19)))
cv.errors

for (j in 1:k) {
  best.fit=regsubsets(Salary~., data=Hitters[folds!=j,], nvmax=19)
  for (i in 1:19){
    pred=predict(best.fit,Hitters[folds==j,], id=i)
    cv.errors[j,i]=mean( (Hitters$Salary[folds==j]-pred)^2)
  }
}

mean.cv.errors=apply(cv.errors, 2, mean)
mean.cv.errors

par(mfrow=c(1,1))
plot(mean.cv.errors, type="b")

reg.best=regsubsets(Salary~., data=Hitters, nvmax=19)
coef(reg.best,11)

library(glmnet)

x=model.matrix(Salary~., Hitters)[,-1]
y=Hitters$Salary

grid=10^seq(10,-2, length=100)
ridge.mod=glmnet(x,y,alpha=0, lambda=grid)

dim(coef(ridge.mod))

ridge.mod$lambda[50]
coef(ridge.mod)[,50]
ridge.mod$lambda
sqrt(sum(coef(ridge.mod)[-1,50]^2))

ridge.mod$lambda[60]
coef(ridge.mod)[,60]
sqrt(sum(coef(ridge.mod)[-1,60]^2))

predict(ridge.mod, s=50, type="coefficients")[1:20,]

set.seed(1)
train=sample(1:nrow(x), nrow(x)/2)
test=(-train)
y.test=y[test]

ridge.mod=glmnet(x[train,], y[train], alpha=0, lambda=grid, thresh=1e-12)
ridge.pred=predict(ridge.mod, s=4, newx=x[test,])
mean((ridge.pred-y.test)^2)

ridge.pred=predict(ridge.mod, s=1e10, newx=x[test,])
mean((ridge.pred-y.test)^2)

ridge.pred = predict(ridge.mod, exact=T, 
                  x=model.matrix(Salary~., Hitters)[train,-1],
                  y=Hitters$Salary[train], 
                  type="coefficients")[1:20]
ridge.pred = predict(ridge.mod, exact=T, 
                     x[train,],
                     y[train], 
                     type="coefficients")[1:20]

mean((ridge.pred-y.test)^2)
lm(y~x, subset=train)

set.seed(1)
cv.out=cv.glmnet(x[train,],y[train],nfolds=10, alpha=0)
plot(cv.out)
bestlam=cv.out$lambda.min
bestlam

ridge.pred=predict(ridge.mod, s=bestlam, newx=x[test,])
mean((ridge.pred - y.test)^2)

out=glmnet(x,y,alpha=0)
predict(out, type="coefficients", s=bestlam)[1:20,]

#Lasso

lasso.mod=glmnet(x[train,], y[train], alpha=1, lambda=grid)
plot(lasso.mod)

set.seed(1)
cv.out=cv.glmnet(x[train,], y[train],alpha=1)
plot(cv.out)
bestlam=cv.out$lambda.min
lasso.pred=predict(lasso.mod, s=bestlam, newx=x[test,])
mean((lasso.pred-y.test)^2)

out=glmnet(x,y,alpha=1, lambda=grid)
lasso.coef=predict(out, type="coefficients", s=bestlam)[1:20,]
lasso.coef

#PCR
library(pls)
set.seed(2)
pcr.fit=pcr(Salary~., data=Hitters, scale=TRUE, validation="CV")

summary(pcr.fit)

validationplot(pcr.fit, val.type = "MSEP")

set.seed(1)
pcr.fit=pcr(Salary~., data=Hitters, subset=train, scale=TRUE, validation="CV")
validationplot(pcr.fit, val.type="MSEP")

pcr.pred=predict(pcr.fit, x[test,], ncomp=7)
mean((pcr.pred-y.test)^2)

pcr.fit=pcr(y~x, scale=TRUE, ncomp=7)
summary(pcr.fit)

#partial least squares regression
set.seed(1)
pls.fit=plsr(Salary~., data=Hitters, subset=train, scale=TRUE, validation="CV")
summary(pls.fit)

validationplot(pls.fit, val.type = "MSEP")

pls.pred=predict(pls.fit, x[test,], ncomp=2)
mean((pls.pred-y.test)^2)

pls.fit=plsr(Salary~., data=Hitters, scale=TRUE, ncomp=2)
summary(pls.fit)
