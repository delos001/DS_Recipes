

# PREDICT 422 Practical Machine Learning

# Course Project - Example R Script File

# OBJECTIVE: A charitable organization wishes to develop a machine learning
# model to improve the cost-effectiveness of their direct marketing campaigns
# to previous donors.

# 1) Develop a classification model using data from the most recent campaign that
# can effectively capture likely donors so that the expected net profit is maximized.

# 2) Develop a prediction model to predict donation amounts for donors - the data
# for this will consist of the records for donors only.

# load the data
library(fBasics)
charity <- read.csv("charity.csv", sep = ",", header = TRUE) # load the "charity.csv" file
str(charity)
dim(charity)
attributes(charity)
head(charity)
tail(charity)
names(charity)

range <- function(x) {max(x, na.rm = TRUE) - min(x, na.rm = TRUE)}
summary_stats = function(x) {
  stats = data.frame(rbind(range(x),
                            min(x, na.rm=TRUE),
                            quantile(x, probs = c(0.10), na.rm = TRUE),                           
                            quantile(x, probs = c(0.25), na.rm = TRUE),
                            mean(x, na.rm = TRUE),
                            median(x, na.rm = TRUE),
                            quantile(x, probs = c(0.75), na.rm = TRUE),
                            quantile(x, probs = c(0.90), na.rm = TRUE),
                            max(x, na.rm=TRUE),
                            sd(x, na.rm = TRUE),
                            var(x, na.rm = TRUE)),
  row.names = c("Range", "Min", "Q10", "Q25", "Mean", "Med", "Q75", "Q90", 
                "Max", "SD", "Var"))
  colnames(stats)=colnames(x)
  return(stats)
}

round(t(data.frame(apply(charity[, 11:21], 2, summary_stats))),2)

addmargins(table(charity$donr,charity$reg1))
addmargins(table(charity$donr,charity$reg2))
addmargins(table(charity$donr,charity$reg3))
addmargins(table(charity$donr,charity$reg4))
addmargins(table(charity$donr,charity$reg1+
                   charity$reg2+charity$reg3+charity$reg4))
addmargins(table(charity$donr,charity$home))
addmargins(table(charity$donr,charity$chld))
addmargins(table(charity$donr,charity$hinc))
addmargins(table(charity$donr,charity$genf))
addmargins(table(charity$donr,charity$wrat))


round(addmargins(prop.table(table(charity$donr,charity$reg1))),3)
round(addmargins(prop.table(table(charity$donr,charity$reg2))),3)
round(addmargins(prop.table(table(charity$donr,charity$reg3))),3)
round(addmargins(prop.table(table(charity$donr,charity$reg4))),3)
round(addmargins(prop.table(table(charity$donr,charity$reg1+charity$reg2+
                                    charity$reg3+charity$reg4))),3)
round(addmargins(prop.table(table(charity$donr,charity$home))),3)
round(addmargins(prop.table(table(charity$donr,charity$chld))),3)
round(addmargins(prop.table(table(charity$donr,charity$hinc))),3)
round(addmargins(prop.table(table(charity$donr,charity$genf))),3)
round(addmargins(prop.table(table(charity$donr,charity$wrat))),3)

for (i in 2:10){
  ftable.i=round(addmargins(prop.table(table(charity$donr,charity[,i]))),3)
  print(ftable.i)
}


#print histograms for all continuous vars
par(mfrow=c(3,3))
for (i in 11:21){
  hist(charity[,i], col="red", main=c("Histogram: ", colnames(charity)[i]),
       xlab=colnames(charity)[i])
}
par(mfrow=c(1,1))

#print box plots for all continuous vars
par(mfrow=c(3,3))
for (i in 11:21){
  boxplot(charity[,i], col="blue", main=c("Boxplot: ", colnames(charity)[i]))
}
par(mfrow=c(1,1))

#histogram and boxplot side by side
par(mfrow=c(3,2))
for (i in 11:21){
  hist(charity[,i], col="red", main=c("Histogram: ", colnames(charity)[i]),
       xlab=colnames(charity)[i])
  boxplot(charity[,i], col="blue", main=c("Boxplot: ", colnames(charity)[i]))
}
par(mfrow=c(1,1))

#view correlation among continuous variables
pairs(charity[,11:21])
cor.num=cor(charity[,11:21])
round(cor.num,3)

#histogram for 3 categorical number variables 
hist(charity$chl)
hist(charity$hinc)
hist(charity$wrat)

#qqplot for all variables
par(mfrow=c(2,3))
for (i in 11:21){
  qqnorm(charity[,i], ylab=colnames(charity)[i])
  qqline(charity[,i])
}
par(mfrow=c(1,1))


#------------------------------------------------------------------------------------------
#     decision tree variable importance
#------------------------------------------------------------------------------------------

library(tree)
train=charity[charity$part=="train",]
head(train)
tree.charity1 =  tree(donr~ reg1 + reg2 + reg3 + reg4 + home + genf 
                      + chld + hinc + wrat + avhv + incm + inca + plow 
                      + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                      train)

tree.charity1
summary(tree.charity1)
plot(tree.charity1)
text(tree.charity1, pretty=0, cex=0.6, pos=1, offset=0)
#variables used in tree.charity1: "chld" "home" "reg2" "reg1" "hinc" "wrat" "tdon"

library(gbm)
boost.charity1 = gbm(donr~reg1 + reg2 + reg3 + reg4 + home + genf 
                     + chld + hinc + wrat + avhv + incm + inca + plow 
                     + npro + tgif + lgif + rgif + tdon + tlag + agif,
                     data=train, 
                     distribution="bernoulli", 
                     n.trees = 5000,
                     interaction.depth=4)

summary(boost.charity1)
par(mfrow=c(1,2))
plot(boost.charity1, i="chld")
plot(boost.charity1, i="reg2")
par(mfrow=c(1,1))


#first step moves the dependent var columns to columns 1:3 (for ease of variable selection)
charity.a = charity[,c(22:24,2:21)]
head(charity.a) 
#------------------------------------------------------------------------------------------
#     create new variables
#------------------------------------------------------------------------------------------

### Create new file for transformations
charity.c=charity.a

#create cal variable to elimiate correlation of avhv and incm
charity.c$C_avhv_incm = charity.c$avhv/charity.c$incm
qqnorm(charity.c$C_avhv_incm)
qqline(charity.c$C_avhv_incm)

#create calc variable to eliminate correlation of plow and avhv variable  **
charity.c$C_plow_avhv = charity.c$avhv + charity.c$avhv*(0.5-(charity.c$plow)/100)
qqnorm(charity.c$C_plow_avhv)
qqline(charity.c$C_plow_avhv)

#create calc variable to eliminate correlation of plow and incm variable
charity.c$C_plow_incm = charity.c$incm + charity.c$incm*(0.5-(charity.c$plow)/100)
qqnorm(charity.c$C_plow_incm)
qqline(charity.c$C_plow_incm)

#crate calc variable to elimiante correlation of lgif and rgif
charity.c$C_lgif_rgif = charity.c$rgif/charity.c$lgif
qqnorm(charity.c$C_lgif_rgif)
qqline(charity.c$C_lgif_rgif)

#create calc variable to eliminate correlation of lgif and agif **
charity.c$C_agif_lgif = charity.c$agif/charity.c$lgif
qqnorm(charity.c$C_agif_lgif)
qqline(charity.c$C_agif_lgif)

#create calc variable to eliminate correlation of rgif and agif
charity.c$C_rgif_agif = charity.c$rgif/charity.c$agif
qqnorm(charity.c$C_rgif_agif)
qqline(charity.c$C_rgif_agif)

head(charity.c)
str(charity.c)

#histogram and boxplot side by side for calculated variables
par(mfrow=c(2,3))
for (i in 24:29){
  hist(charity.c[,i], col="red", main=c("Histogram: ", colnames(charity.c)[i]),
       xlab=colnames(charity.c)[i])
  boxplot(charity.c[,i], col="blue", main=c("Boxplot: ", colnames(charity.c)[i]))
  qqnorm(charity.c[,i], ylab=colnames(charity.c)[i])
  qqline(charity.c[,i])
}
par(mfrow=c(1,1))

par(mfrow=c(2,3))
for (i in 24:29){
  qqnorm(charity.c[,i], ylab=colnames(charity.c)[i])
  qqline(charity.c[,i])
}
par(mfrow=c(1,1))

#-------------------------------------------------------------------------------------
#     predictor transformations
#-------------------------------------------------------------------------------------

charity.d = charity.c


#CREATE dummy code transformations of varaibles_______________________________________

#dummy code child variable
charity.d$chld.0=ifelse(charity.d$chld==0,1,0)
charity.d$chld.1=ifelse(charity.d$chld==1,1,0)
charity.d$chld.2_5=ifelse(charity.d$chld>=2,1,0)

head(charity.d)

#dummy code household income
charity.d$hinc.0_2.5=ifelse(charity.d$hinc<=2.5,1,0)
charity.d$hinc.2.5_5=ifelse(charity.d$hinc>2.5 & charity.d$hinc<5.5,1,0)
charity.d$hinc.5_max=ifelse(charity.d$hinc>=5.5,1,0)

tail(charity.d)

#re-categorize and dummy code the wrat variable (based on freq table findings)
charity.d$wrat.0_3.5=ifelse(charity.d$wrat<=3.5,1,0)
charity.d$wrat.3.5_5=ifelse(charity.d$wrat>3.5 & charity.d$wrat<6,1,0)
charity.d$wrat.6_max=ifelse(charity.d$wrat>=6,1,0)

tail(charity.d)

#bin plow variable
addmargins(table(charity.d$donr,charity.d$plow))

charity.d$plow.0_5=ifelse(charity.d$plow<=4, 1, 0)
charity.d$plow.5_15=ifelse(charity.d$plow>=5 & charity.d$plow<=15, 1, 0)
charity.d$plow.15_max=ifelse(charity.d$plow>15, 1, 0)

addmargins(table(charity.d$donr,charity.d$npro))
charity.d$npro.0_30=ifelse(charity.d$npro<=30, 1, 0)
charity.d$npro.40_50=ifelse(charity.d$npro>30 & charity.d$npro<=50, 1, 0)
charity.d$npro.50_70=ifelse(charity.d$npro>50 & charity.d$npro<=70, 1, 0)
charity.d$npro.70_90=ifelse(charity.d$npro>70 & charity.d$npro<=90, 1, 0)
charity.d$npro.90_max=ifelse(charity.d$npro>90, 1, 0)

head(charity.d)

#CREATE Log transformations and capped of varaibles_______________________________
charity.t =  charity.d

#ln transformation continuous variables (all variables except npro and tdon)
charity.t$ln.avhv=sign(charity.t$avhv)*log(abs(charity.t$avhv)+1)
charity.t$ln.incm=sign(charity.t$incm)*log(abs(charity.t$incm)+1)
#charity.t$ln.inca=sign(charity.t$inca)*log(abs(charity.t$inca)+1)  (incm is better)
#charity.t$ln.plow=sign(charity.t$plow)*log(abs(charity.t$plow)+1)
#charity.t$ln.npro=sign(charity.t$npro)*log(abs(charity.t$npro)+1)
charity.t$ln.tgif=sign(charity.t$tgif)*log(abs(charity.t$tgif)+1)
charity.t$ln.lgif=sign(charity.t$lgif)*log(abs(charity.t$lgif)+1)
charity.t$ln.rgif=sign(charity.t$rgif)*log(abs(charity.t$rgif)+1)
charity.t$ln.tdon=sign(charity.t$tdon)*log(abs(charity.t$tdon)+1)
charity.t$ln.tlag=sign(charity.t$tlag)*log(abs(charity.t$tlag)+1)
charity.t$ln.agif=sign(charity.t$agif)*log(abs(charity.t$agif)+1)

#log transform the newly calculated variables
charity.t$ln.C_avhv_incm=sign(charity.t$C_avhv_incm)*log(abs(charity.t$C_avhv_incm)+1)
charity.t$ln.C_plow_avhv=sign(charity.t$C_plow_avhv)*log(abs(charity.t$C_plow_avhv)+1)
charity.t$ln.C_plow_incm=sign(charity.t$C_plow_incm)*log(abs(charity.t$C_plow_incm)+1)
#charity.t$ln.C_plow_inca=sign(charity.t$C_plow_inca)*log(abs(charity.t$C_plow_inca)+1)
charity.t$sqr.C_agif_lgif=sqrt(charity.c$C_agif_lgif)
charity.t$ln.C_lgif_rgif=sign(charity.t$C_lgif_rgif)*log(abs(charity.t$C_lgif_rgif)+1)
charity.t$ln.C_rgif_agif=sign(charity.t$C_rgif_agif)*log(abs(charity.t$C_rgif_agif)+1)

str(charity.t)

#look at distributions to see if transformations were of value
par(mfrow=c(2,3))
for (i in 47:60){
  hist(charity.t[,i], col="red", main=c("Histogram: ", colnames(charity.t)[i]),
       xlab=colnames(charity.t)[i])
  boxplot(charity.t[,i], col="blue", main=c("Boxplot: ", colnames(charity.t)[i]))
  qqnorm(charity.t[,i], ylab=colnames(charity.t)[i])
  qqline(charity.t[,i])
}
par(mfrow=c(1,1))

#print QQplots to compare with pre-tranformed variables
par(mfrow=c(2,3))
for (i in 47:60){
  qqnorm(charity.t[,i], ylab=colnames(charity.t)[i])
  qqline(charity.t[,i])
}
par(mfrow=c(1,1))


#recheck basic stats from function created in EDA section above
round(t(data.frame(apply(charity.t[, 24:60], 2, summary_stats))),2)

#boosting to determine variable importance with calculated and tx vars
library(gbm)
train2=charity.t[charity.t$part=="train",]
boost.charity2 = gbm(donr~
                       #binary vars: original
                       reg1 + reg2 + reg3 + reg4 + home + genf +
                       
                       #numerical categorical (original) remove if dummy var used
                       #chld + hinc + wrat +
                       
                       #continuous (original)
                       #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                       #remove if using dummy variables
                       #plow + npro +
                       
                       #dummy variables
                       chld.0 + chld.1 + chld.2_5 +
                       hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                       wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                       plow.0_5 + plow.5_15 + plow.15_max +
                       npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                       
                       #ln transformation of original variables
                       ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                       
                       #ln transformation of calculated variables
                       ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                       ln.C_lgif_rgif + ln.C_rgif_agif, 
                data=train2,
                distribution = "bernoulli",
                n.trees = 5000,
                interaction.depth=4)

summary(boost.charity2)
par(mfrow=c(1,2))
plot(boost.charity2, i="chld.0")
plot(boost.charity2, i="hinc.2.5_5")
par(mfrow=c(1,1))

# add further transformations if desired
# for example, some statistical methods can struggle when predictors are highly skewed
# set up data for analysis

data.train <- charity.t[charity.t$part=="train",]
x.train <- data.train[,4:60]
c.train <- data.train[,1] # donr
n.train.c <- length(c.train) # 3984
y.train <- data.train[c.train==1,2] # damt for observations with donr=1
n.train.y <- length(y.train) # 1995

data.valid <- charity.t[charity$part=="valid",]
x.valid <- data.valid[,4:60]
c.valid <- data.valid[,1] # donr
n.valid.c <- length(c.valid) # 2018
y.valid <- data.valid[c.valid==1,2] # damt for observations with donr=1
n.valid.y <- length(y.valid) # 999

data.test <- charity.t[charity$part=="test",]
n.test <- dim(data.test)[1] # 2007
x.test <- data.test[,4:60]

x.train.mean <- apply(x.train, 2, mean)
x.train.sd <- apply(x.train, 2, sd)
x.train.std <- t((t(x.train)-x.train.mean)/x.train.sd) # standardize to have zero mean and unit sd
apply(x.train.std, 2, mean) # check zero mean
apply(x.train.std, 2, sd) # check unit sd
data.train.std.c <- data.frame(x.train.std, donr=c.train) # to classify donr
head(data.train.std.c)
data.train.std.y <- data.frame(x.train.std[c.train==1,], damt=y.train) # to predict damt when donr=1

x.valid.std <- t((t(x.valid)-x.train.mean)/x.train.sd) # standardize using training mean and sd
data.valid.std.c <- data.frame(x.valid.std, donr=c.valid) # to classify donr
data.valid.std.y <- data.frame(x.valid.std[c.valid==1,], damt=y.valid) # to predict damt when donr=1

x.test.std <- t((t(x.test)-x.train.mean)/x.train.sd) # standardize using training mean and sd
data.test.std <- data.frame(x.test.std)

#---------------------------------------------------------------------------------------------------

##### CLASSIFICATION MODELING ######

#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# linear discriminant analysis #1
#---------------------------------------------------------------------------------------------------

library(MASS)

model.lda1 <- lda(donr ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + I(hinc^2) + genf + wrat + 
                    avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                  data.train.std.c) # include additional terms on the fly using I()

# Note: strictly speaking, LDA should not be used with qualitative predictors,
# but in practice it often is if the goal is simply to find a good predictive model

post.valid.lda1 <- predict(model.lda1, data.valid.std.c)$posterior[,2] # n.valid.c post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.lda1 <- cumsum(14.5*c.valid[order(post.valid.lda1, decreasing=T)]-2)
plot(profit.lda1) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.lda1) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.lda1)) # report number of mailings and maximum profit
# 1329.0 11624.5

cutoff.lda1 <- sort(post.valid.lda1, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.lda1 <- ifelse(post.valid.lda1>cutoff.lda1, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.lda1, c.valid)) # classification table
#               c.valid
#chat.valid.lda1   0   1
#              0 675  14
#              1 344 985
# check n.mail.valid = 344+985 = 1329
# check profit = 14.5*985-2*1329 = 11624.5
mean(chat.valid.lda1==c.valid)
#---------------------------------------------------------------------------------------------------
# linear discriminant analysis #2
#---------------------------------------------------------------------------------------------------

model.lda2 <- lda(donr ~ reg1 + reg2 + reg3 + reg4 + home+
                    chld + I(chld^2) + I(chld^3) +
                    hinc + I(hinc^2) + I(hinc^3) +
                    wrat + I(wrat^2) + I(wrat^3) +
                    incm + tgif + tdon + tlag, 
                  data.train.std.c) # include additional terms on the fly using I()

# Note: strictly speaking, LDA should not be used with qualitative predictors,
# but in practice it often is if the goal is simply to find a good predictive model

post.valid.lda2 <- predict(model.lda2, data.valid.std.c)$posterior[,2] # n.valid.c post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.lda2 <- cumsum(14.5*c.valid[order(post.valid.lda2, decreasing=T)]-2)
plot(profit.lda2) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.lda2) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.lda2)) # report number of mailings and maximum profit
# 1342.0 11685.5

cutoff.lda2 <- sort(post.valid.lda2, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.lda2 <- ifelse(post.valid.lda2>cutoff.lda2, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.lda2, c.valid)) # classification table
mean(chat.valid.lda2==c.valid)

#---------------------------------------------------------------------------------------------------
# linear discriminant analysis #3
#---------------------------------------------------------------------------------------------------
model.lda3 <- lda(donr ~ 
                    #binary vars: original
                    reg1 + reg2 + reg3 + reg4 + home + 
                    
                    #numerical categorical (original) remove if dummy var used
                    #chld + hinc + wrat +
                    
                    #continuous (original)
                    #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                    #remove if using dummy variables
                    #plow + npro +
                    
                    #dummy variables
                    chld.0 + chld.1 + #chld.2_5 +
                    hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                    wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                    plow.0_5 + plow.5_15 + #plow.15_max +
                    npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                    
                    #ln transformation of original variables
                    ln.avhv + ln.incm + 
                    ln.tgif + I(ln.tgif^2) + I(ln.tgif^3) + 
                    ln.lgif + ln.rgif + 
                    ln.tdon + I(ln.tdon^2) + I(ln.tdon^3) + 
                    ln.tlag + I(ln.tlag^2) + I(ln.tlag^3) +
                    ln.agif + 
                    
                    #ln transformation of calculated variables
                    ln.C_avhv_incm + ln.C_plow_avhv + 
                    ln.C_plow_incm + I(ln.C_plow_incm^2) + 
                    sqr.C_agif_lgif + 
                    ln.C_lgif_rgif + ln.C_rgif_agif,

                  data.train.std.c) # include additional terms on the fly using I()

post.valid.lda3 <- predict(model.lda3, data.valid.std.c)$posterior[,2] # n.valid.c post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.lda3 <- cumsum(14.5*c.valid[order(post.valid.lda3, decreasing=T)]-2)
plot(profit.lda3) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.lda3) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.lda3)) # report number of mailings and maximum profit
# 1328 11699

cutoff.lda3 <- sort(post.valid.lda3, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.lda3 <- ifelse(post.valid.lda3>cutoff.lda3, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.lda3, c.valid)) # classification table
mean(chat.valid.lda3==c.valid)

#---------------------------------------------------------------------------------------------------
# quadratic discriminant analysis #1
#---------------------------------------------------------------------------------------------------

model.qda1 = qda(donr~
                   #binary vars: original
                   reg1 + reg2 + reg3 + reg4 + 
                   home + genf +
                   
                   #numerical categorical (original) remove if dummy var used
                   #chld + hinc + wrat +
                   
                   #continuous (original)
                   #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                   #remove if using dummy variables
                   #plow + npro +
                   
                   #dummy variables
                   chld.0 + chld.1 + #chld.2_5 +
                   hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                   wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                   #plow.0_5 + plow.5_15 + #plow.15_max +
                   #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                   
                   #ln transformation of original variables
                   I(ln.avhv^1) + 
                   I(ln.incm^1) + I(ln.incm^2) +
                   I(ln.tgif^1) + I(ln.tgif^3) +
                   I(ln.lgif^1) + I(ln.rgif^1) + 
                   I(ln.tdon^1) + I(ln.tdon^4) + 
                   I(ln.tlag^1) + 
                   I(ln.agif^1) + 
                   
                   #ln transformation of calculated variables
                   I(ln.C_avhv_incm^1) + 
                   I(ln.C_plow_avhv^1) + 
                   I(ln.C_plow_incm^2) + I(ln.C_plow_incm^2) +
                   I(sqr.C_agif_lgif^4) +
                   I(ln.C_lgif_rgif^2) + I(ln.C_rgif_agif^1),
                 data.train.std.c) # include additional terms on the fly using I()

post.valid.qda1 <- predict(model.qda1, data.valid.std.c)$posterior[,2] # n.valid.c post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.qda1 <- cumsum(14.5*c.valid[order(post.valid.qda1, decreasing=T)]-2)
plot(profit.qda1) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.qda1) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.qda1)) # report number of mailings and maximum profit
# 1328 11699

cutoff.qda1 <- sort(post.valid.qda1, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.qda1 <- ifelse(post.valid.qda1>cutoff.qda1, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.qda1, c.valid)) # classification table
mean(chat.valid.qda1==c.valid)
#---------------------------------------------------------------------------------------------------
# logistic regression #1
#---------------------------------------------------------------------------------------------------


model.log1 <- glm(donr ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + I(hinc^2) + genf + wrat + 
                    avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                  data.train.std.c, family=binomial("logit"))

post.valid.log1 <- predict(model.log1, data.valid.std.c, type="response") # n.valid post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.log1 <- cumsum(14.5*c.valid[order(post.valid.log1, decreasing=T)]-2)
plot(profit.log1) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.log1) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.log1)) # report number of mailings and maximum profit
# 1291.0 11642.5

cutoff.log1 <- sort(post.valid.log1, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.log1 <- ifelse(post.valid.log1>cutoff.log1, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.log1, c.valid)) # classification table
#               c.valid
#chat.valid.log1   0   1
#              0 709  18
#              1 310 981
# check n.mail.valid = 310+981 = 1291
# check profit = 14.5*981-2*1291 = 11642.5
mean(chat.valid.log1==c.valid)

#---------------------------------------------------------------------------------------------------
# logistic regression #2
#---------------------------------------------------------------------------------------------------
model.log2 <- glm(donr ~ reg1 + reg2 + reg3 + reg4 + home+
                    chld + I(chld^2) + I(chld^3) +
                    hinc + I(hinc^2) + I(hinc^3) +
                    wrat + I(wrat^2) + I(wrat^3) +
                    incm + tgif + tdon + tlag, 
                  data.train.std.c, family=binomial("logit"))

post.valid.log2 <- predict(model.log2, data.valid.std.c, type="response") # n.valid post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.log2 <- cumsum(14.5*c.valid[order(post.valid.log2, decreasing=T)]-2)
plot(profit.log2) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.log2) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.log2)) # report number of mailings and maximum profit
# 1291.0 11642.5

cutoff.log2 <- sort(post.valid.log2, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.log2 <- ifelse(post.valid.log2>cutoff.log2, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.log2, c.valid)) # classification table
mean(chat.valid.log2==c.valid)

#---------------------------------------------------------------------------------------------------
# logistic regression #3
#---------------------------------------------------------------------------------------------------
model.log3 <- glm(donr ~ 
                    #binary vars: original
                    reg1 + reg2 + reg3 + reg4 + home + 
                    
                    #numerical categorical (original) remove if dummy var used
                    #chld + hinc + wrat +
                    
                    #continuous (original)
                    #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                    #remove if using dummy variables
                    #plow + npro +
                    
                    #dummy variables
                    chld.0 + chld.1 + #chld.2_5 +
                    hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                    wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                    #plow.0_5 + plow.5_15 + #plow.15_max +
                    npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                    
                    #ln transformation of original variables
                    ln.avhv + 
                    ln.incm + 
                    ln.tgif + I(ln.tgif^2) + I(ln.tgif^3) + 
                    ln.lgif + ln.rgif + 
                    ln.tdon + I(ln.tdon^2) + I(ln.tdon^3) + 
                    ln.tlag + I(ln.tlag^2) + I(ln.tlag^3) +
                    #ln.agif + 
                    
                    #ln transformation of calculated variables
                    ln.C_avhv_incm + 
                    ln.C_plow_avhv + I(ln.C_plow_avhv^2) + 
                    ln.C_plow_incm + I(ln.C_plow_incm^2) + I(ln.C_plow_incm^3) +
                    #sqr.C_agif_lgif + 
                    ln.C_lgif_rgif + ln.C_rgif_agif,
                  data.train.std.c, family=binomial("logit"))

post.valid.log3 <- predict(model.log3, data.valid.std.c, type="response") # n.valid post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.log3 <- cumsum(14.5*c.valid[order(post.valid.log3, decreasing=T)]-2)
plot(profit.log3) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.log3) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.log3)) # report number of mailings and maximum profit

cutoff.log3 <- sort(post.valid.log3, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.log3 <- ifelse(post.valid.log3>cutoff.log3, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.log3, c.valid)) # classification table
mean(chat.valid.log3==c.valid)

#---------------------------------------------------------------------------------------------------
# K-Nearest Neighbor#1
#---------------------------------------------------------------------------------------------------

library(class)
set.seed(123)
k=1:10
accuracy = rep(0,10)
for (i in k){
model.knn1 = knn(x.train.std, x.valid.std, c.train, k=i, prob=TRUE)

accuracy[i]=mean(model.knn1==c.valid)
}
plot(k, accuracy, type='b')

model.knn1 = knn(x.train.std, x.valid.std, c.train, k=5, prob=TRUE)

#don't need a predict function here since knn model produces predicted automatically
profit.knn1 <- cumsum(14.5*c.valid[order(model.knn1, decreasing=T)]-2)
plot(profit.knn1) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.knn1) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.knn1)) # report number of mailings and maximum profit

addmargins(table(model.knn1, c.valid))
mean(model.knn1==c.valid)
attr(model.knn1, "prob")

#---------------------------------------------------------------------------------------------------
# K-Nearest Neighbor#2
#---------------------------------------------------------------------------------------------------

#x.train.std.knn=x.train.std[,c(1:5,8,27:35,44:46,49:50,52:54)]
#x.valid.std.knn=x.valid.std[,c(1:5,8,27:35,44:46,49:50,52:54)]

x.train.std.knn=data.train.std.c[,c(1:5,8,27:35,44:46,49:50,52:54)]
x.valid.std.knn=data.valid.std.c[,c(1:5,8,27:35,44:46,49:50,52:54)]

head(x.train.std.knn)
head(x.valid.std.knn)
set.seed(123)
k=1:10
accuracy = rep(0,10)
for (i in k){
  model.knn2 = knn(x.train.std.knn, x.valid.std.knn, c.train, k=i, prob=TRUE)
  
  accuracy[i]=mean(model.knn2==c.valid)
}
plot(k, accuracy, type='b')

model.knn2 = knn(x.train.std.knn, x.valid.std.knn, c.train, k=7, prob=TRUE)

#don't need a predict function here since knn model produces predicted automatically
profit.knn2 <- cumsum(14.5*c.valid[order(model.knn2, decreasing=T)]-2)
plot(profit.knn2) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.knn2) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.knn2)) # report number of mailings and maximum profit

addmargins(table(model.knn2, c.valid))
mean(model.knn2==c.valid)

#---------------------------------------------------------------------------------------------------
# Generalized Additive Model#1
#---------------------------------------------------------------------------------------------------

library(gam)

model.gam1 = gam(donr ~ 
                   #binary vars: original
                   reg1 + reg2 + reg3 + reg4 + home + #genf +
                   
                   #numerical categorical (original) remove if dummy var used
                   #chld + hinc + wrat +
                   
                   #continuous (original)
                   #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                   #remove if using dummy variables
                   #plow + npro +
                   
                   #dummy variables
                   chld.0 + chld.1 + #chld.2_5 +
                   hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                   wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                   #plow.0_5 + plow.5_15 + #plow.15_max +
                   #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                   
                   #ln transformation of original variables
                   ln.avhv + ln.incm + ln.tgif + #ln.lgif + ln.rgif + 
                   ln.tdon + ln.tlag + #ln.agif + 
                   
                   #ln transformation of calculated variables
                   ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm,
                   #sqr.C_agif_lgif + 
                   #ln.C_lgif_rgif + ln.C_rgif_agif,
                 family=binomial,
                 data=data.train.std.c)
plot(model.gam1, se=TRUE, col="green")
summary(model.gam1)

post.valid.gam1 <- predict(model.gam1, newdata=data.valid.std.c, type="response") # n.valid post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.gam1 <- cumsum(14.5*c.valid[order(post.valid.gam1, decreasing=T)]-2)
plot(profit.gam1) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.gam1) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.gam1)) # report number of mailings and maximum profit

cutoff.gam1 <- sort(post.valid.gam1, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.gam1 <- ifelse(post.valid.gam1>cutoff.gam1, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.gam1, c.valid)) # classification table
mean(chat.valid.gam1==c.valid)
#---------------------------------------------------------------------------------------------------
# Generalized Additive Model#2
#---------------------------------------------------------------------------------------------------

  model.gam2 = gam(donr ~ 
                     #binary vars: original
                     reg1 + reg2 + reg3 + reg4 + home + #genf +
                     
                     #numerical categorical (original) remove if dummy var used
                     #chld + hinc + wrat +
                     
                     #continuous (original)
                     #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                     #remove if using dummy variables
                     #plow + npro +
                     
                     #dummy variables
                     chld.0 + chld.1 + #chld.2_5 +
                     hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                     wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                     #plow.0_5 + plow.5_15 + #plow.15_max +
                     #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                     
                     #ln transformation of original variables
                     s(ln.avhv,3) + s(ln.incm,5) + s(ln.tgif,6) + #ln.lgif + ln.rgif + 
                     s(ln.tdon,6) + s(ln.tlag,9) + #ln.agif + 
                     
                     #ln transformation of calculated variables
                     s(ln.C_avhv_incm,6) + s(ln.C_plow_avhv,5) + s(ln.C_plow_incm,1),
                     #sqr.C_agif_lgif + ln.C_lgif_rgif + #ln.C_rgif_agif,
                   family=binomial,
                   data=data.train.std.c)
  #summary(model.gam2)
  
  post.valid.gam2 <- predict(model.gam2, newdata=data.valid.std.c, type="response") # n.valid post probs
  
  # calculate ordered profit function using average donation = $14.50 and mailing cost = $2
  
  profit.gam2 <- cumsum(14.5*c.valid[order(post.valid.gam2, decreasing=T)]-2)
  plot(profit.gam2) # see how profits change as more mailings are made
  n.mail.valid <- which.max(profit.gam2) # number of mailings that maximizes profits
  c(n.mail.valid, max(profit.gam2)) # report number of mailings and maximum profit
  
  cutoff.gam2 <- sort(post.valid.gam2, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
  chat.valid.gam2 <- ifelse(post.valid.gam2>cutoff.gam2, 1, 0) # mail to everyone above the cutoff
  addmargins(table(chat.valid.gam2, c.valid)) # classification table
  mean(chat.valid.gam2==c.valid)

#---------------------------------------------------------------------------------------------------
# Support Vector Machine#1
#---------------------------------------------------------------------------------------------------

library(e1071)

##sVM tune 1
model.tune1 = tune(svm, as.factor(donr)~
                     #binary vars: original
                     reg1 + reg2 + reg3 + reg4 + home + genf +
                     
                     #numerical categorical (original) remove if dummy var used
                     chld + hinc + wrat +
                     
                     #continuous (original)
                     avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                     #remove if using dummy variables
                     plow + npro +
                     
                     #dummy variables
                     #chld.0 + chld.1 + #chld.2_5 +
                     #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                     #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                     #plow.0_5 + plow.5_15 + #plow.15_max +
                     #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                     
                     #ln transformation of original variables
                     #ln.avhv + 
                     #ln.incm + ln.tgif + ln.lgif + ln.rgif + 
                     #ln.tdon + ln.tlag + ln.agif + 
                     
                     #ln transformation of calculated variables
                     ln.C_avhv_incm + 
                     ln.C_plow_avhv + ln.C_plow_incm,
                     #sqr.C_agif_lgif +
                     #ln.C_lgif_rgif + ln.C_rgif_agif,
                   data=data.train.std.c,
                   kernel="polynomial",
                   ranges=list(degree=c(1, 2, 3, 4, 5),
                               cost=c(0.01, 0.1, 1, 10, 100)))
summary(model.tune1)

## SVM with cross validation results
model.svm1 = svm(as.factor(donr)~
                   #binary vars: original
                   reg1 + reg2 + reg3 + reg4 + home + genf +
                   
                   #numerical categorical (original) remove if dummy var used
                   chld + hinc + wrat +
                   
                   #continuous (original)
                   avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                   #remove if using dummy variables
                   plow + npro +
                   
                   #dummy variables
                   #chld.0 + chld.1 + #chld.2_5 +
                   #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                   #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                   #plow.0_5 + plow.5_15 + #plow.15_max +
                   #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                   
                   #ln transformation of original variables
                   #ln.avhv + 
                   #ln.incm + ln.tgif + ln.lgif + ln.rgif + 
                 #ln.tdon + ln.tlag + ln.agif + 
                 
                 #ln transformation of calculated variables
                 ln.C_avhv_incm + 
                   ln.C_plow_avhv + ln.C_plow_incm,
                 #sqr.C_agif_lgif +
                 #ln.C_lgif_rgif + ln.C_rgif_agif,
                 data=data.train.std.c,
                 kernel="polynomial", cost=1, degree=1)
summary(model.svm1)

post.valid.svm1 <- predict(model.svm1, newdata=data.valid.std.c, type="response") # n.valid post probs

profit.svm1 <- cumsum(14.5*c.valid[order(post.valid.svm1, decreasing=T)]-2)
plot(profit.svm1) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.svm1) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.svm1)) # report number of mailings and maximum profit

addmargins(table(post.valid.svm1, true=c.valid))
table(true=data.valid.std.c$donr)


#---------------------------------------------------------------------------------------------------
# Support Vector Machine#2
#---------------------------------------------------------------------------------------------------
model.tune2 = tune(svm, as.factor(donr)~
                   #binary vars: original
                   reg1 + reg2 + reg3 + reg4 + home + #genf +
                   
                   #numerical categorical (original) remove if dummy var used
                   chld + hinc + wrat +
                   
                   #continuous (original)
                   #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                   #remove if using dummy variables
                   #plow + npro +
                   
                   #dummy variables
                   #chld.0 + chld.1 + #chld.2_5 +
                   #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                   #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                   #plow.0_5 + plow.5_15 + #plow.15_max +
                   #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                   
                   #ln transformation of original variables
                   #ln.avhv + 
                   ln.incm + ln.tgif + #ln.lgif + ln.rgif + 
                   ln.tdon + ln.tlag + #ln.agif + 
                 
                 #ln transformation of calculated variables
                 ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm,
                 #sqr.C_agif_lgif +
                 #ln.C_lgif_rgif + ln.C_rgif_agif,
                 data=data.train.std.c,
                 kernel="polynomial",
                 ranges=list(degree=c(1, 2, 3, 4, 5),
                             cost=c(0.01, 0.1, 1, 10, 100)))
summary(model.tune2)

model.svm2 = svm(as.factor(donr)~
                   #binary vars: original
                   reg1 + reg2 + reg3 + reg4 + home + #genf +
                   
                   #numerical categorical (original) remove if dummy var used
                   chld + hinc + wrat +
                   
                   #continuous (original)
                   #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                   #remove if using dummy variables
                   #plow + npro +
                   
                   #dummy variables
                   #chld.0 + chld.1 + #chld.2_5 +
                   #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                   #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                   #plow.0_5 + plow.5_15 + #plow.15_max +
                 #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                 
                 #ln transformation of original variables
                 #ln.avhv + 
                 ln.incm + ln.tgif + #ln.lgif + ln.rgif + 
                   ln.tdon + ln.tlag + #ln.agif + 
                   
                   #ln transformation of calculated variables
                   ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm,
                 #sqr.C_agif_lgif +
                 #ln.C_lgif_rgif + ln.C_rgif_agif,
                 data=data.train.std.c,
                 kernel="polynomial", cost=100, degree=3)

post.valid.svm2 <- predict(model.svm2, newdata=data.valid.std.c, type="response") # n.valid post probs

profit.svm2 <- cumsum(14.5*c.valid[order(post.valid.svm2, decreasing=T)]-2)
plot(profit.svm2) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.svm2) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.svm2)) # report number of mailings and maximum profit

addmargins(table(post.valid.svm2, true=c.valid))
table(true=data.valid.std.c$donr)


#---------------------------------------------------------------------------------------------------
# Support Vector Machine#3
#---------------------------------------------------------------------------------------------------
model.tune3 = tune(svm, as.factor(donr)~
                     #binary vars: original
                     reg1 + reg2 + reg3 + reg4 + home + #genf +
                     
                     #numerical categorical (original) remove if dummy var used
                     chld + hinc + wrat +
                     
                     #continuous (original)
                     #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                     #remove if using dummy variables
                     #plow + npro +
                     
                     #dummy variables
                     #chld.0 + chld.1 + #chld.2_5 +
                     #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                     #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                     #plow.0_5 + plow.5_15 + #plow.15_max +
                   #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                   
                   #ln transformation of original variables
                   #ln.avhv + 
                   ln.incm + ln.tgif + #ln.lgif + ln.rgif + 
                     ln.tdon + ln.tlag + #ln.agif + 
                     
                     #ln transformation of calculated variables
                     ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm,
                   #sqr.C_agif_lgif +
                   #ln.C_lgif_rgif + ln.C_rgif_agif,
                   data=data.train.std.c,
                   kernel="radial",
                   ranges=list(gamma=c(0.5, 1, 2, 3, 4),
                               cost=c(0.1, 1, 10, 100, 1000)))
summary(model.tune3)


model.svm3 = svm(as.factor(donr)~
                   #binary vars: original
                   reg1 + reg2 + reg3 + reg4 + home + #genf +
                   
                   #numerical categorical (original) remove if dummy var used
                   chld + hinc + wrat +
                   
                   #continuous (original)
                   #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                   #remove if using dummy variables
                   #plow + npro +
                   
                   #dummy variables
                   #chld.0 + chld.1 + #chld.2_5 +
                   #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                   #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                   #plow.0_5 + plow.5_15 + #plow.15_max +
                 #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                 
                 #ln transformation of original variables
                 #ln.avhv + 
                 ln.incm + ln.tgif + #ln.lgif + ln.rgif + 
                   ln.tdon + ln.tlag + #ln.agif + 
                   
                   #ln transformation of calculated variables
                   ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm,
                 #sqr.C_agif_lgif +
                 #ln.C_lgif_rgif + ln.C_rgif_agif,
                 data=data.train.std.c,
                 kernel="radial", gamma=0.5, cost=1)

post.valid.svm3 <- predict(model.svm3, newdata=data.valid.std.c, type="response") # n.valid post probs

profit.svm3 <- cumsum(14.5*c.valid[order(post.valid.svm3, decreasing=T)]-2)
plot(profit.svm3) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.svm3) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.svm3)) # report number of mailings and maximum profit

addmargins(table(post.valid.svm3, true=c.valid))
table(true=data.valid.std.c$donr)


#---------------------------------------------------------------------------------------------------
# Support Vector Machine#4
#---------------------------------------------------------------------------------------------------
model.tune4 = tune(svm, as.factor(donr)~
                     #binary vars: original
                     reg1 + reg2 + #reg3 + reg4 + 
                     home + #genf +
                     
                     #numerical categorical (original) remove if dummy var used
                     chld + hinc + wrat +
                     
                     #continuous (original)
                     #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                     #remove if using dummy variables
                     #plow + npro +
                     
                     #dummy variables
                     #chld.0 + chld.1 + #chld.2_5 +
                     #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                     #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                     #plow.0_5 + plow.5_15 + #plow.15_max +
                     #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                   
                     #ln transformation of original variables
                     #ln.avhv + 
                     ln.incm + ln.tgif + #ln.lgif + ln.rgif + 
                     ln.tdon + ln.tlag + #ln.agif + 
                     
                     #ln transformation of calculated variables
                     #ln.C_avhv_incm + ln.C_plow_avhv + 
                     ln.C_plow_incm,
                     #sqr.C_agif_lgif +
                     #ln.C_lgif_rgif + ln.C_rgif_agif,
                   data=data.train.std.c,
                   kernel="radial",
                   ranges=list(gamma=c(0.5, 1, 2, 3, 4),
                               cost=c(0.1, 1, 10, 100, 1000)))
summary(model.tune4)

model.svm4 = svm(as.factor(donr)~
                   #binary vars: original
                   reg1 + reg2 + #reg3 + reg4 + 
                   home + #genf +
                   
                   #numerical categorical (original) remove if dummy var used
                   chld + hinc + wrat +
                   
                   #continuous (original)
                   #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                   #remove if using dummy variables
                   #plow + npro +
                   
                   #dummy variables
                   #chld.0 + chld.1 + #chld.2_5 +
                   #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                   #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                   #plow.0_5 + plow.5_15 + #plow.15_max +
                 #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                 
                 #ln transformation of original variables
                 #ln.avhv + 
                 ln.incm + ln.tgif + #ln.lgif + ln.rgif + 
                   ln.tdon + ln.tlag + #ln.agif + 
                   
                   #ln transformation of calculated variables
                   #ln.C_avhv_incm + ln.C_plow_avhv + 
                   ln.C_plow_incm,
                 #sqr.C_agif_lgif +
                 #ln.C_lgif_rgif + ln.C_rgif_agif,
                 data=data.train.std.c,
                 kernel="radial", gamma=0.5, cost=1)

post.valid.svm4 <- predict(model.svm4, newdata=data.valid.std.c, type="response") # n.valid post probs


profit.svm4 <- cumsum(14.5*c.valid[order(post.valid.svm4, decreasing=T)]-2)
plot(profit.svm4) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.svm4) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.svm4)) # report number of mailings and maximum profit

addmargins(table(post.valid.svm4, true=c.valid))
table(true=data.valid.std.c$donr)

#---------------------------------------------------------------------------------------------------
# Boost Model#1
#---------------------------------------------------------------------------------------------------

model.boost1 = gbm(donr~
                       #binary vars: original
                       reg1 + reg2 + reg3 + reg4 + home + #genf +
                       
                       #numerical categorical (original) remove if dummy var used
                       #chld + hinc + wrat +
                       
                       #continuous (original)
                       #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                       #remove if using dummy variables
                       #plow + npro +
                       
                       #dummy variables
                       chld.0 + chld.1 + chld.2_5 +
                       hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                       wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                       plow.0_5 + plow.5_15 + plow.15_max +
                       npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                       
                       #ln transformation of original variables
                       ln.avhv + ln.incm + ln.tgif + 
                       ln.lgif + ln.rgif + 
                       ln.tdon + ln.tlag + 
                       ln.agif + 
                       
                       #ln transformation of calculated variables
                       ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm +
                       sqr.C_agif_lgif + 
                       ln.C_lgif_rgif + ln.C_rgif_agif, 
                     data=data.train.std.c,
                     distribution = "bernoulli",
                     n.trees = 5000,
                     interaction.depth=4)

post.valid.boost1 <- predict(model.boost1, newdata=data.valid.std.c, type="response",
                             n.trees=5000) # n.valid post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.boost1 <- cumsum(14.5*c.valid[order(post.valid.boost1, decreasing=T)]-2)
plot(profit.boost1) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.boost1) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.boost1)) # report number of mailings and maximum profit

cutoff.boost1 <- sort(post.valid.boost1, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.boost1 <- ifelse(post.valid.boost1>cutoff.boost1, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.boost1, c.valid)) # classification table
mean(chat.valid.boost1==c.valid)

#---------------------------------------------------------------------------------------------------
# Boost Model#2
#---------------------------------------------------------------------------------------------------
model.boost2 = gbm(donr~
                     #binary vars: original
                     reg1 + reg2 + reg3 + reg4 + home + genf +
                     
                     #numerical categorical (original) remove if dummy var used
                     chld + hinc + wrat +
                     
                     #continuous (original)
                     avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                     #remove if using dummy variables
                     plow + npro,
                     
                     #dummy variables
                     #chld.0 + chld.1 + chld.2_5 +
                     #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                     #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                     #plow.0_5 + plow.5_15 + plow.15_max +
                     #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                     
                     #ln transformation of original variables
                     #ln.avhv + ln.incm + ln.tgif + 
                     #ln.lgif + ln.rgif + 
                     #ln.tdon + ln.tlag + 
                     #ln.agif + 
                     
                     #ln transformation of calculated variables
                     #ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm,
                     #sqr.C_agif_lgif + 
                     #ln.C_lgif_rgif + ln.C_rgif_agif, 
                     data=data.train.std.c,
                   distribution = "bernoulli",
                   n.trees = 5000,
                   interaction.depth=4)

post.valid.boost2 <- predict(model.boost2, newdata=data.valid.std.c, type="response",
                             n.trees=5000) # n.valid post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.boost2 <- cumsum(14.5*c.valid[order(post.valid.boost2, decreasing=T)]-2)
plot(profit.boost2) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.boost2) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.boost2)) # report number of mailings and maximum profit

cutoff.boost2 <- sort(post.valid.boost2, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.boost2 <- ifelse(post.valid.boost2>cutoff.boost2, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.boost2, c.valid)) # classification table
mean(chat.valid.boost2==c.valid)


#---------------------------------------------------------------------------------------------------
# Boost Model#3
#---------------------------------------------------------------------------------------------------
model.boost3 = gbm(donr~
                     #binary vars: original
                     reg1 + reg2 + reg3 + reg4 + home + genf +
                     
                     #numerical categorical (original) remove if dummy var used
                     chld + hinc + wrat +
                     
                     #continuous (original)
                     avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                     #remove if using dummy variables
                     plow + npro +
                   
                   #dummy variables
                   #chld.0 + chld.1 + chld.2_5 +
                   #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                   #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                   #plow.0_5 + plow.5_15 + plow.15_max +
                   #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                   
                   #ln transformation of original variables
                   #ln.avhv + ln.incm + ln.tgif + 
                   #ln.lgif + ln.rgif + 
                   #ln.tdon + ln.tlag + 
                   #ln.agif + 
                   
                   #ln transformation of calculated variables
                   ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm +
                   sqr.C_agif_lgif + 
                   ln.C_lgif_rgif + ln.C_rgif_agif,
                   data=data.train.std.c,
                   distribution = "bernoulli",
                   n.trees = 5000,
                   interaction.depth=4)

post.valid.boost3 <- predict(model.boost3, newdata=data.valid.std.c, type="response",
                             n.trees=5000) # n.valid post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.boost3 <- cumsum(14.5*c.valid[order(post.valid.boost3, decreasing=T)]-2)
plot(profit.boost3) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.boost3) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.boost3)) # report number of mailings and maximum profit

cutoff.boost3 <- sort(post.valid.boost3, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.boost3 <- ifelse(post.valid.boost3>cutoff.boost3, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.boost3, c.valid)) # classification table
mean(chat.valid.boost3==c.valid)

#---------------------------------------------------------------------------------------------------
# Boost Model#4
#---------------------------------------------------------------------------------------------------
model.boost4 = gbm(donr~
                     #binary vars: original
                     reg1 + reg2 + reg3 + reg4 + home + genf +
                     
                     #numerical categorical (original) remove if dummy var used
                     chld + hinc + wrat +
                     
                     #continuous (original)
                     avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                     #remove if using dummy variables
                     plow + npro +
                     
                     #dummy variables
                     #chld.0 + chld.1 + chld.2_5 +
                     #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                     #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                     #plow.0_5 + plow.5_15 + plow.15_max +
                     #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                     
                     #ln transformation of original variables
                     #ln.avhv + ln.incm + ln.tgif + 
                     #ln.lgif + ln.rgif + 
                   #ln.tdon + ln.tlag + 
                   #ln.agif + 
                   
                   #ln transformation of calculated variables
                   ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm +
                     sqr.C_agif_lgif + 
                     ln.C_lgif_rgif + ln.C_rgif_agif,
                   data=data.train.std.c,
                   distribution = "bernoulli",
                   n.trees = 5000,
                   interaction.depth=5)

post.valid.boost4 <- predict(model.boost4, newdata=data.valid.std.c, type="response",
                             n.trees=5000) # n.valid post probs

# calculate ordered profit function using average donation = $14.50 and mailing cost = $2

profit.boost4 <- cumsum(14.5*c.valid[order(post.valid.boost4, decreasing=T)]-2)
plot(profit.boost4) # see how profits change as more mailings are made
n.mail.valid <- which.max(profit.boost4) # number of mailings that maximizes profits
c(n.mail.valid, max(profit.boost4)) # report number of mailings and maximum profit

cutoff.boost4 <- sort(post.valid.boost4, decreasing=T)[n.mail.valid+1] # set cutoff based on n.mail.valid
chat.valid.boost4 <- ifelse(post.valid.boost4>cutoff.boost4, 1, 0) # mail to everyone above the cutoff
addmargins(table(chat.valid.boost4, c.valid)) # classification table
mean(chat.valid.boost2==c.valid)

#---------------------------------------------------------------------------------------------------
# Results
#---------------------------------------------------------------------------------------------------

# select model.boost4 since it has maximum profit in the validation sample

post.test <- predict(model.boost4, data.test.std, type="response", 
                     n.trees = 5000) # post probs for test data

# Oversampling adjustment for calculating number of mailings for test set

n.mail.valid <- which.max(profit.boost4)
tr.rate <- .1 # typical response rate is .1
vr.rate <- .5 # whereas validation response rate is .5
adj.test.1 <- (n.mail.valid/n.valid.c)/(vr.rate/tr.rate) # adjustment for mail yes
adj.test.0 <- ((n.valid.c-n.mail.valid)/n.valid.c)/((1-vr.rate)/(1-tr.rate)) # adjustment for mail no
adj.test <- adj.test.1/(adj.test.1+adj.test.0) # scale into a proportion
n.mail.test <- round(n.test*adj.test, 0) # calculate number of mailings for test set

cutoff.test <- sort(post.test, decreasing=T)[n.mail.test+1] # set cutoff based on n.mail.test
chat.test <- ifelse(post.test>cutoff.test, 1, 0) # mail to everyone above the cutoff
table(chat.test)
#    0    1 
# 1709  298
# based on this model we'll mail to the 331 highest posterior probabilities

# See below for saving chat.test into a file for submission


#---------------------------------------------------------------------------------------------------

##### PREDICTION MODELING ######

#---------------------------------------------------------------------------------------------------

#boost model 1 to assess original variables created with calculated variables
boost.predmod1 = gbm(damt~
                       #binary vars: original
                       reg1 + reg2 + reg3 + reg4 + home + genf +
                       
                       #numerical categorical (original) remove if dummy var used
                       chld + hinc + wrat +
                       
                       #continuous (original)
                       avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                       #remove if using dummy variables
                       plow + npro +
                       
                       #dummy variables
                       #chld.0 + chld.1 + chld.2_5 +
                       #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                       #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                       #plow.0_5 + plow.5_15 + plow.15_max +
                       #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                       
                       #ln transformation of original variables
                       #ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                       
                       #ln transformation of calculated variables
                       ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                       ln.C_lgif_rgif + ln.C_rgif_agif, 
                     data=data.train.std.y,
                     distribution = "gaussian",
                     n.trees = 5000,
                     interaction.depth=4)

summary(boost.predmod1)
par(mfrow=c(1,2))
par(mfrow=c(1,1))

#boost model 2 to assess dummary variables created 
boost.predmod2 = gbm(damt~
                       #binary vars: original
                       reg1 + reg2 + reg3 + reg4 + home + genf +
                       
                       #numerical categorical (original) remove if dummy var used
                       #chld + hinc + wrat +
                       
                       #continuous (original)
                       #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                       #remove if using dummy variables
                       #plow + npro +
                       
                       #dummy variables
                      chld.0 + chld.1 + chld.2_5 +
                      hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                      wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                      plow.0_5 + plow.5_15 + plow.15_max +
                      npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                       
                       #ln transformation of original variables
                       ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                       
                       #ln transformation of calculated variables
                       ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                       ln.C_lgif_rgif + ln.C_rgif_agif, 
                     data=data.train.std.y,
                     distribution = "gaussian",
                     n.trees = 5000,
                     interaction.depth=4)

summary(boost.predmod2)
par(mfrow=c(1,2))
par(mfrow=c(1,1))


#tree for original variables and calculated variables
tree.predmod1 =  tree(damt~ reg1 + reg2 + reg3 + reg4 + home + genf 
                     + chld + hinc + wrat + avhv + incm + plow 
                     + npro + tgif + lgif + rgif + tdon + tlag + agif +
                       ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                       ln.C_lgif_rgif + ln.C_rgif_agif, data.train.std.y)

tree.predmod1
summary(tree.predmod1)
plot(tree.predmod1)
text(tree.predmod1, pretty=0, cex=0.6, pos=1, offset=0)

#tree 2 for transformed variables and calculated variables
tree.predmod2 =  tree(damt~ reg1 + reg2 + reg3 + reg4 + home + genf 
                      + chld + hinc + wrat + plow + npro +
                        ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                        ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                        ln.C_lgif_rgif + ln.C_rgif_agif, data.train.std.y)

tree.predmod2
summary(tree.predmod2)
plot(tree.predmod2)
text(tree.predmod2, pretty=0, cex=0.6, pos=1, offset=0)
#---------------------------------------------------------------------------------------------------
# Least squares regression#1
#---------------------------------------------------------------------------------------------------


model.ls1 <- lm(damt ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + genf + wrat + 
                  avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                data.train.std.y)

summary(model.ls1)
pred.valid.ls1 <- predict(model.ls1, newdata = data.valid.std.y) # validation predictions
mean((y.valid - pred.valid.ls1)^2) # mean prediction error
# 1.867523
sd((y.valid - pred.valid.ls1)^2)/sqrt(n.valid.y) # std error
# 0.1696615


#---------------------------------------------------------------------------------------------------
# Least squares regression#2
#---------------------------------------------------------------------------------------------------

# drop wrat for illustrative purposes
model.ls2 <- lm(damt ~ 
                  rgif + 
                  lgif + 
                  agif + 
                  reg1 + reg2 + reg3 + reg4 + 
                  chld + 
                  hinc + 
                  wrat + 
                  tgif + 
                  plow + 
                  ln.C_plow_incm + 
                  sqr.C_agif_lgif + 
                  ln.C_avhv_incm,
                data.train.std.y)

summary(model.ls2)
pred.valid.ls2 <- predict(model.ls2, newdata = data.valid.std.y) # validation predictions
mean((y.valid - pred.valid.ls2)^2) # mean prediction error
# 1.867433
sd((y.valid - pred.valid.ls2)^2)/sqrt(n.valid.y) # std error
# 0.1696498


#---------------------------------------------------------------------------------------------------
# Least squares regression#3
#---------------------------------------------------------------------------------------------------
model.ls3 <- lm(damt ~ 
                  reg1 + reg2 + reg3 + reg4 + home + # genf +
                  
                  #numerical categorical (original) remove if dummy var used
                  #chld + hinc + wrat +
                  
                  #continuous (original)
                  #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                  #remove if using dummy variables
                  #plow + npro +
                  
                  #dummy variables
                  chld.0 + chld.1 + #chld.2_5 +
                  hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                  wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                  #plow.0_5 + plow.5_15 + #plow.15_max +
                  #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                  
                  #ln transformation of original variables
                  #ln.avhv + 
                  ln.incm + 
                  ln.tgif + #ln.lgif + 
                  ln.rgif + #ln.tdon + ln.tlag + 
                  ln.agif + 
                  
                  #ln transformation of calculated variables
                  #ln.C_avhv_incm + 
                  #ln.C_plow_avhv + 
                  ln.C_plow_incm + 
                  sqr.C_agif_lgif, 
                  #ln.C_lgif_rgif + ln.C_rgif_agif,
                data.train.std.y)

summary(model.ls3)
pred.valid.ls3 <- predict(model.ls3, newdata = data.valid.std.y) # validation predictions
mean((y.valid - pred.valid.ls3)^2) # mean prediction error
# 1.867433
sd((y.valid - pred.valid.ls3)^2)/sqrt(n.valid.y) # std error


#---------------------------------------------------------------------------------------------------
# Lasso#1
#---------------------------------------------------------------------------------------------------

library(glmnet)

#lass.train.x=data.train.std.y[,c(1:5,8,27:58)]
#lass.valid.x=data.valid.std.y[,c(1:5,8,27:58)]
#head(x.train.std.lass)
#str(lass.train.x)


x=model.matrix(damt~., data.train.std.y)
head(x)
y=data.train.std.y$damt
head(y)

grid=10^seq(10,-2,length=100)

model.lass=glmnet(x,y, alpha=1, lambda=grid)
summary(model.lass)
par(mfrow=c(2,1))
plot(model.lass)


model.lass.cv=cv.glmnet(x,y, alpha=1)
plot(model.lass.cv)
par(mfrow=c(1,1))
bestlam=model.lass.cv$lambda.min
bestlam

xvalid=model.matrix(damt~., data.valid.std.y)
head(xvalid)

model.lass.cv=predict(model.lass, s=bestlam, newx=xvalid)
model.lass.cv=predict(model.lass, s=bestlam, newx=data.valid.std.y)

summary(model.lass.cv)
lasso.coef=predict(model.lass,type="coefficients", s=bestlam)[1:59]
lasso.df = (length(lasso.coef)-sum(lasso.coef==0))


mean((data.valid.std.y$damt-model.lass.cv)^2)
sd((data.valid.std.y$damt - model.lass.cv)^2)/sqrt(n.valid.y) # std error


mean(data.valid.std.y$damt)-model.lass.cv
lass1.ssreg = sum((mean(data.valid.std.y$damt)-model.lass.cv)^2)
lass1.ssres = sum((data.valid.std.y$damt-model.lass.cv)^2)
lass1.sstot = lass1.ssreg+lass1.ssres
rsq = lass1.ssreg/lass1.sstot
adjrsq = 1 - ((1-rsq)*(n.valid.y-1) / (n.valid.y - lasso.df - 1))
adjrsq


#---------------------------------------------------------------------------------------------------
# Polynomial Regression#1
#---------------------------------------------------------------------------------------------------
head(data.train.std.y)
model.poly=lm(damt~
                    #binary vars: original
                    reg1 + reg2 + reg3 + reg4 + home + #genf +
                    
                    #numerical categorical (original) remove if dummy var used
                    #chld + hinc + wrat +
                    
                    #continuous (original)
                    #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                    #remove if using dummy variables
                    #plow + npro +
                    
                    #dummy variables
                    chld.0 + chld.1 + chld.2_5 +
                    hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                    wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                    #plow.0_5 + plow.5_15 + plow.15_max +
                    #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                    
                    #ln transformation of original variables
                    #ln.avhv + ln.incm + ln.tdon + ln.tlag + 
                    poly(ln.tgif,4) + 
                    poly(ln.lgif,4) + 
                    poly(ln.rgif,4) + 
                    poly(ln.agif,4) + 
                    
                    #ln transformation of calculated variables
                    poly(ln.C_avhv_incm,4) + 
                    poly(ln.C_plow_avhv,4) + 
                    poly(ln.C_plow_incm,4) + 
                    poly(sqr.C_agif_lgif,4), 
                    #ln.C_lgif_rgif + ln.C_rgif_agif,
                    data=data.train.std.y)
coef(summary(model.poly))


#---------------------------------------------------------------------------------------------------
# Polynomial Regression#2
#---------------------------------------------------------------------------------------------------
model.poly1=lm(damt~
                #binary vars: original
                reg1 + reg2 + reg3 + reg4 + home + #genf +
                
                #numerical categorical (original) remove if dummy var used
                #chld + hinc + wrat +
                
                #continuous (original)
                #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                #remove if using dummy variables
                #plow + npro +
                
                #dummy variables
                chld.0 + chld.1 + #chld.2_5 +
                hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                #plow.0_5 + plow.5_15 + plow.15_max +
                #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                
                #ln transformation of original variables
                #ln.avhv + ln.incm + ln.tdon + ln.tlag + 
                poly(ln.tgif,2) + 
                ln.lgif + 
                ln.rgif + 
                I(ln.agif^4) + 
                
                #ln transformation of calculated variables
                #poly(ln.C_avhv_incm,1) + 
                poly(ln.C_plow_avhv,1) + 
                poly(ln.C_plow_incm,1) + 
                poly(sqr.C_agif_lgif,1), 
                #ln.C_lgif_rgif + ln.C_rgif_agif,
              data=data.train.std.y)
coef(summary(model.poly1))

poly.pred1 = predict(model.poly1, newdata = data.valid.std.y)
poly.pred1

poly.df = length(coef(summary(model.poly1)))/4

mean((data.valid.std.y$damt-poly.pred1)^2)
sd((data.valid.std.y$damt - poly.pred1)^2)/sqrt(n.valid.y) # std error


mean(data.valid.std.y$damt)-poly.pred1
poly1.ssreg = sum((mean(data.valid.std.y$damt)-poly.pred1)^2)
poly1.ssres = sum((data.valid.std.y$damt-poly.pred1)^2)
poly1.sstot = poly1.ssreg+poly1.ssres
rsq = poly1.ssreg/poly1.sstot
adjrsq = 1 - ((1-rsq)*(n.valid.y-1) / (n.valid.y - poly.df - 1))
adjrsq


#---------------------------------------------------------------------------------------------------
# Spline#1
#---------------------------------------------------------------------------------------------------

library(splines)


model.spline1 = lm(damt~
                      #binary vars: original
                      reg1 + reg2 + reg3 + reg4 + home + #genf +
                      
                      #numerical categorical (original) remove if dummy var used
                      #chld + hinc + wrat +
                      
                      #continuous (original)
                      #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                      #remove if using dummy variables
                      #plow + npro +
                      
                      #dummy variables
                      chld.0 + chld.1 + #chld.2_5 +
                      hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                      wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                      #plow.0_5 + plow.5_15 + plow.15_max +
                      #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                      
                      #ln transformation of original variables
                      #ln.avhv + ln.incm + ln.tdon + ln.tlag + 
                      ln.tgif + I(ln.tgif^2) +
                      bs(ln.lgif, df=6) + 
                      bs(ln.rgif, df=6) + 
                      bs(I(ln.agif^4), df=6) + 
                      
                      #ln transformation of calculated variables
                      #poly(ln.C_avhv_incm,1) + 
                      ln.C_plow_avhv + 
                      ln.C_plow_incm +
                      sqr.C_agif_lgif,
                      #ln.C_lgif_rgif + ln.C_rgif_agif,
                      data=data.train.std.y)
spline.pred1 = predict(model.spline1, newdata = data.valid.std.y)

mean((data.valid.std.y$damt-spline.pred1)^2)
sd((data.valid.std.y$damt - spline.pred1)^2)/sqrt(n.valid.y) # std error

coef(summary(model.spline1))


spline.pred1

poly.df = length(coef(summary(model.poly1)))/4

mean(data.valid.std.y$damt)-spline.pred1
poly1.ssreg = sum((mean(data.valid.std.y$damt)-spline.pred1)^2)
poly1.ssres = sum((data.valid.std.y$damt-spline.pred1)^2)
poly1.sstot = poly1.ssreg+poly1.ssres
rsq = poly1.ssreg/poly1.sstot
adjrsq = 1 - ((1-rsq)*(n.valid.y-1) / (n.valid.y - poly.df - 1))
adjrsq


#---------------------------------------------------------------------------------------------------
# Bagging#1
#---------------------------------------------------------------------------------------------------
head(data.train.std.y)
set.seed(3232)
model.bag1 = randomForest(damt~ 
                           #binary vars: original
                           reg1 + reg2 + reg3 + reg4 + home + genf +
                           
                           #numerical categorical (original) remove if dummy var used
                           chld + hinc + wrat +
                           
                           #continuous (original)
                           avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                           #remove if using dummy variables
                           plow + npro,
                         
                         #dummy variables
                         #chld.0 + chld.1 + chld.2_5 +
                         #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                         #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                         #plow.0_5 + plow.5_15 + plow.15_max +
                         #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                         
                         #ln transformation of original variables
                         #ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                         
                         #ln transformation of calculated variables
                         #ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                         #ln.C_lgif_rgif + ln.C_rgif_agif,
                         data = data.train.std.y, mtry=19, ntree=1000, importance=TRUE)


importance(model.bag1)
varImpPlot(model.bag1)

pred.bag1=predict(model.bag1, newdata=data.valid.std.y)

mean((data.valid.std.y$damt-pred.bag1)^2)
sd((data.valid.std.y$damt - pred.bag1)^2)/sqrt(n.valid.y) # std error

summary(model.bag1)
summary(model.bag1$rsq)
model.bag1

#---------------------------------------------------------------------------------------------------
# Bagging#2
#---------------------------------------------------------------------------------------------------
head(data.train.std.y)
set.seed(3232)
model.bag2 = randomForest(damt~ 
                            #binary vars: original
                            reg1 + reg2 + reg3 + reg4 + home + genf +
                            
                            #numerical categorical (original) remove if dummy var used
                            chld + hinc + wrat +
                            
                            #continuous (original)
                            #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                            #remove if using dummy variables
                            plow + npro + 
                          
                          #dummy variables
                          #chld.0 + chld.1 + chld.2_5 +
                          #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                          #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                          #plow.0_5 + plow.5_15 + plow.15_max +
                          #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                          
                          #ln transformation of original variables
                          ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                          
                          #ln transformation of calculated variables
                          ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                          ln.C_lgif_rgif + ln.C_rgif_agif,
                          data = data.train.std.y, mtry=25, ntree=1000, importance=TRUE)


importance(model.bag2)
varImpPlot(model.bag2)

pred.bag2=predict(model.bag2, newdata=data.valid.std.y)

mean((data.valid.std.y$damt-pred.bag2)^2)
sd((data.valid.std.y$damt - pred.bag2)^2)/sqrt(n.valid.y) # std error

summary(model.bag2)
summary(model.bag2$rsq)
model.bag2

#---------------------------------------------------------------------------------------------------
# Bagging#3
#---------------------------------------------------------------------------------------------------
head(data.train.std.y)
set.seed(3232)
model.bag3 = randomForest(damt~ 
                            #binary vars: original
                            reg1 + reg2 + reg3 + reg4 + #home + genf +
                            
                            #numerical categorical (original) remove if dummy var used
                            chld + hinc + wrat +
                            
                            #continuous (original)
                            avhv + incm +  tgif + 
                            lgif + rgif + agif + 
                            tdon + tlag + 
                            #remove if using dummy variables
                            plow + npro + 
                            
                            #dummy variables
                            #chld.0 + chld.1 + chld.2_5 +
                            #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                            #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                            #plow.0_5 + plow.5_15 + plow.15_max +
                            #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                            
                            #ln transformation of original variables
                            #ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                            
                            #ln transformation of calculated variables
                            C_avhv_incm + C_agif_lgif + #C_plow_avhv + C_plow_incm + 
                            #C_lgif_rgif + 
                            C_rgif_agif,
                          data = data.train.std.y, mtry=20, ntree=1000, importance=TRUE)


importance(model.bag3)
varImpPlot(model.bag3)

pred.bag3=predict(model.bag3, newdata=data.valid.std.y)

mean((data.valid.std.y$damt-pred.bag3)^2)
sd((data.valid.std.y$damt - pred.bag3)^2)/sqrt(n.valid.y) # std error

summary(model.bag3)
summary(model.bag3$rsq)
model.bag3

#---------------------------------------------------------------------------------------------------
# Random Forest#1
#---------------------------------------------------------------------------------------------------

library(randomForest)
set.seed(3232)
model.rf1 = randomForest(damt~ 
                        #binary vars: original
                        reg1 + reg2 + reg3 + reg4 + home + genf +
                          
                          #numerical categorical (original) remove if dummy var used
                          chld + hinc + wrat +
                          
                          #continuous (original)
                          avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                          #remove if using dummy variables
                          plow + npro,
                          
                          #dummy variables
                          #chld.0 + chld.1 + chld.2_5 +
                          #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                          #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                          #plow.0_5 + plow.5_15 + plow.15_max +
                          #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                          
                          #ln transformation of original variables
                          #ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                          
                          #ln transformation of calculated variables
                          #ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                          #ln.C_lgif_rgif + ln.C_rgif_agif,
                        data = data.train.std.y, mtry=6, ntree=1000, importance=TRUE)


importance(model.rf1)
varImpPlot(model.rf1)

pred.rf1=predict(model.rf1, newdata=data.valid.std.y)

mean((data.valid.std.y$damt-pred.rf1)^2)
sd((data.valid.std.y$damt - pred.rf1)^2)/sqrt(n.valid.y) # std error

summary(model.rf1)
summary(model.rf1$rsq)
model.rf1

#---------------------------------------------------------------------------------------------------
# Random Forest#2
#---------------------------------------------------------------------------------------------------

set.seed(3232)
model.rf2 = randomForest(damt~ 
                           #binary vars: original
                           reg1 + reg2 + reg3 + reg4 + #home + #genf +
                           
                           #numerical categorical (original) remove if dummy var used
                           chld + hinc + wrat +
                           
                           #continuous (original)
                           #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                           #remove if using dummy variables
                           plow + npro +
                         
                         #dummy variables
                         #chld.0 + chld.1 + chld.2_5 +
                         #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                         #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                         #plow.0_5 + plow.5_15 + plow.15_max +
                         #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                         
                         #ln transformation of original variables
                         ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                         
                         #ln transformation of calculated variables
                         ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                         ln.C_lgif_rgif + ln.C_rgif_agif,
                         data = data.train.std.y, mtry=6, ntree=500, importance=TRUE)


importance(model.rf2)
varImpPlot(model.rf2)

pred.rf2=predict(model.rf2, newdata=data.valid.std.y)

mean((data.valid.std.y$damt-pred.rf2)^2)
sd((data.valid.std.y$damt - pred.rf2)^2)/sqrt(n.valid.y) # std error

summary(model.rf2)
summary(model.rf2$rsq)
model.rf2


#---------------------------------------------------------------------------------------------------
# Random Forest#3
#---------------------------------------------------------------------------------------------------
head(data.train.std.y)
set.seed(3232)
model.rf3 = randomForest(damt~ 
                           #binary vars: original
                           reg1 + reg2 + reg3 + reg4 + home + genf +
                           
                           #numerical categorical (original) remove if dummy var used
                           chld + hinc + wrat +
                           
                           #continuous (original)
                           avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                           #remove if using dummy variables
                           plow + npro + 
                           
                           #dummy variables
                           #chld.0 + chld.1 + chld.2_5 +
                           #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                           #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                           #plow.0_5 + plow.5_15 + plow.15_max +
                           #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                           
                           #ln transformation of original variables
                           #ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                           
                           #calculated variables Non-transformed
                           C_avhv_incm + C_plow_avhv + C_plow_incm + 
                           C_agif_lgif +
                           C_lgif_rgif + C_rgif_agif,
                         data = data.train.std.y, mtry=6, ntree=1000, importance=TRUE)


importance(model.rf3)
varImpPlot(model.rf3)

pred.rf3=predict(model.rf3, newdata=data.valid.std.y)

mean((data.valid.std.y$damt-pred.rf3)^2)
sd((data.valid.std.y$damt - pred.rf3)^2)/sqrt(n.valid.y) # std error

summary(model.rf3)
summary(model.rf3$rsq)
model.rf3


#---------------------------------------------------------------------------------------------------
# Pred Boost#1
#---------------------------------------------------------------------------------------------------

set.seed(3232)

model.predboost1 = gbm(damt~
                        #binary vars: original
                        reg1 + reg2 + reg3 + reg4 + home + genf +
                        
                        #numerical categorical (original) remove if dummy var used
                        chld + hinc + wrat +
                        
                        #continuous (original)
                        avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                        #remove if using dummy variables
                        plow + npro,
                        
                        #dummy variables
                        #chld.0 + chld.1 + chld.2_5 +
                        #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                        #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                        #plow.0_5 + plow.5_15 + plow.15_max +
                        #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                        
                        #ln transformation of original variables
                        #ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                        
                        #ln transformation of calculated variables
                        #ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                        #ln.C_lgif_rgif + ln.C_rgif_agif,
                      n.trees=5000,
                      distribution="gaussian",
                      data=data.train.std.y, 
                      interaction.depth = 4)

summary(model.predboost1)
pred.boost1 = predict(model.predboost1, newdata=data.valid.std.y, n.trees=5000)

mean((data.valid.std.y$damt-pred.boost1)^2)
sd((data.valid.std.y$damt - pred.boost1)^2)/sqrt(n.valid.y) # std error

#---------------------------------------------------------------------------------------------------
# Pred Boost#2
#---------------------------------------------------------------------------------------------------

set.seed(3232)

model.predboost2 = gbm(damt~
                         #binary vars: original
                         reg1 + reg2 + reg3 + reg4 + home + genf +
                         
                         #numerical categorical (original) remove if dummy var used
                         chld + hinc + wrat +
                         
                         #continuous (original)
                         #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                         #remove if using dummy variables
                         plow + npro +
                       
                         #dummy variables
                         #chld.0 + chld.1 + chld.2_5 +
                         #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                         #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                         #plow.0_5 + plow.5_15 + plow.15_max +
                         #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                         
                         #ln transformation of original variables
                         ln.avhv + ln.incm + 
                         ln.tgif + ln.lgif + ln.rgif + ln.agif + 
                         ln.tdon + ln.tlag + 
                         
                         #ln transformation of calculated variables
                         ln.C_avhv_incm + ln.C_plow_avhv + 
                         ln.C_plow_incm + sqr.C_agif_lgif +
                         ln.C_lgif_rgif + ln.C_rgif_agif,
                       n.trees=5000,
                       distribution="gaussian",
                       data=data.train.std.y, 
                       interaction.depth = 4)

summary(model.predboost2)
pred.boost2 = predict(model.predboost2, newdata=data.valid.std.y, n.trees=5000)

mean((data.valid.std.y$damt-pred.boost2)^2)
sd((data.valid.std.y$damt - pred.boost2)^2)/sqrt(n.valid.y) # std error

#---------------------------------------------------------------------------------------------------
# Pred Boost#3
#---------------------------------------------------------------------------------------------------

set.seed(3232)

model.predboost3 = gbm(damt~
                         #binary vars: original
                         reg1 + reg2 + reg3 + reg4 + #home + #genf +
                         
                         #numerical categorical (original) remove if dummy var used
                         chld + hinc + wrat +
                         
                         #continuous (original)
                         #avhv + incm +  
                         #tgif + lgif + rgif +  
                         #tlag + tdon +
                         #agif +
                         #remove if using dummy variables
                         plow + #npro +
                         
                         #dummy variables
                         #chld.0 + chld.1 + chld.2_5 +
                         #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                         #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                         #plow.0_5 + plow.5_15 + plow.15_max +
                         #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                         
                         #ln transformation of original variables
                         ln.lgif + ln.rgif + ln.agif + ln.tgif + 
                         #ln.avhv + ln.incm + 
                         #ln.tdon + ln.tlag + 
                         
                         #ln transformation of calculated variables
                         ln.C_plow_incm + sqr.C_agif_lgif 
                         #ln.C_avhv_incm + ln.C_plow_avhv + 
                         #ln.C_lgif_rgif + ln.C_rgif_agif
                       , n.trees=5000,
                       distribution="gaussian",
                       data=data.train.std.y, 
                       interaction.depth = 4)

summary(model.predboost3)
pred.boost3 = predict(model.predboost3, newdata=data.valid.std.y, n.trees=5000)

mean((data.valid.std.y$damt-pred.boost3)^2)
sd((data.valid.std.y$damt - pred.boost3)^2)/sqrt(n.valid.y) # std error

#---------------------------------------------------------------------------------------------------
# Pred Boost#4
#---------------------------------------------------------------------------------------------------

set.seed(3232)

model.predboost4 = gbm(damt~
                         #binary vars: original
                         reg1 + reg2 + reg3 + reg4 + home + genf +
                         
                         #numerical categorical (original) remove if dummy var used
                         chld + hinc + wrat +
                         
                         #continuous (original)
                         avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                         #remove if using dummy variables
                         plow + npro,
                       
                       #dummy variables
                       #chld.0 + chld.1 + chld.2_5 +
                       #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                       #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                       #plow.0_5 + plow.5_15 + plow.15_max +
                       #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                       
                       #ln transformation of original variables
                       #ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                       
                       #ln transformation of calculated variables
                       #ln.C_avhv_incm + ln.C_plow_avhv + ln.C_plow_incm + sqr.C_agif_lgif + 
                       #ln.C_lgif_rgif + ln.C_rgif_agif,
                       n.trees=5000,
                       distribution="gaussian",
                       data=data.train.std.y, 
                       interaction.depth = 8)

summary(model.predboost4)
pred.boost4 = predict(model.predboost4, newdata=data.valid.std.y, n.trees=5000)

mean((data.valid.std.y$damt-pred.boost4)^2)
sd((data.valid.std.y$damt - pred.boost4)^2)/sqrt(n.valid.y) # std error


#---------------------------------------------------------------------------------------------------
# Neural Network#1
#---------------------------------------------------------------------------------------------------

library(mlbench)

library(nnet)
range(data.valid.std.y$damt)
set.seed(3232)
model.nn1 <- nnet(damt/19 ~ ., data = data.train.std.y, size = 2) # scale inputs: divide by 50 to get 0-1 range
pred.nn1 <- predict(model.nn1, newdata = data.valid.std.y)*19 # multiply 50 to restore original scale

mean((pred.nn1 - data.valid.std.y$damt)^2) # MSE = 16.56974
sd((pred.nn1 - data.valid.std.y$damt)^2)/sqrt(n.valid.y)


#---------------------------------------------------------------------------------------------------
# Neural Network#2
#---------------------------------------------------------------------------------------------------

set.seed(3232)
model.nn2 <- nnet(damt/19 ~
                   #binary vars: original
                   reg1 + reg2 + reg3 + reg4 + home + genf +
                   
                   #numerical categorical (original) remove if dummy var used
                   chld + hinc + wrat +
                   
                   #continuous (original)
                   avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                   #remove if using dummy variables
                   plow + npro +
                   
                   #dummy variables
                    #chld.0 + chld.1 + chld.2_5 +
                    #hinc.0_2.5 + hinc.2.5_5 + hinc.5_max +
                    #wrat.0_3.5 + wrat.3.5_5 + wrat.6_max +
                    #plow.0_5 + plow.5_15 + plow.15_max +
                   #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + npro.90_max +
                   
                   #ln transformation of original variables
                   #ln.avhv + ln.incm + ln.tgif + ln.lgif + ln.rgif + ln.tdon + ln.tlag + ln.agif + 
                   
                   #ln transformation of calculated variables
                   C_avhv_incm + C_plow_avhv + C_plow_incm + C_agif_lgif + 
                   C_lgif_rgif + C_rgif_agif,
                 
                 data = data.train.std.y, size = 3) # scale inputs: divide by 50 to get 0-1 range

pred.nn2 <- predict(model.nn2, newdata = data.valid.std.y)*19 # multiply 50 to restore original scale

mean((pred.nn2 - data.valid.std.y$damt)^2) 
sd((pred.nn2 - data.valid.std.y$damt)^2)/sqrt(n.valid.y)

#---------------------------------------------------------------------------------------------------
# Neural Network#3
#---------------------------------------------------------------------------------------------------

set.seed(3232)
model.nn3 <- nnet(damt/19 ~
                    #binary vars: original
                    reg1 + reg2 + reg3 + reg4 + home + #genf +
                    
                    #numerical categorical (original) remove if dummy var used
                    chld + hinc + wrat +
                    
                    #continuous (original)
                    #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                    #remove if using dummy variables
                    plow + npro +
                    
                    #dummy variables
                    #chld.0 + chld.1 + #chld.2_5 +
                    #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                    #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                    #plow.0_5 + plow.5_15 + #plow.15_max +
                    #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                    
                    #ln transformation of original variables
                    ln.lgif + ln.rgif + ln.agif + ln.tgif +
                    ln.avhv + ln.incm + ln.lgif + ln.rgif + ln.tdon + ln.tlag +  
                    
                    #ln transformation of calculated variables
                    ln.C_plow_incm + sqr.C_agif_lgif + ln.C_plow_avhv + ln.C_avhv_incm +
                    ln.C_lgif_rgif + ln.C_rgif_agif,
                  
                  data = data.train.std.y, size = 2) # scale inputs: divide by 50 to get 0-1 range

pred.nn3 <- predict(model.nn3, newdata = data.valid.std.y)*19 # multiply 50 to restore original scale

mean((pred.nn3 - data.valid.std.y$damt)^2) 
sd((pred.nn3 - data.valid.std.y$damt)^2)/sqrt(n.valid.y)


library(caret)
mygrid=expand.grid(.decay = c(0.5, 0.1), .size=c(4,5,6))
model.nn3.a = train(damt/19 ~
                      #binary vars: original
                      reg1 + reg2 + reg3 + reg4 + home + #genf +
                      
                      #numerical categorical (original) remove if dummy var used
                      chld + hinc + wrat +
                      
                      #continuous (original)
                      #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                      #remove if using dummy variables
                      plow + npro +
                      
                      #dummy variables
                      #chld.0 + chld.1 + #chld.2_5 +
                      #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                      #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                      #plow.0_5 + plow.5_15 + #plow.15_max +
                      #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                      
                      #ln transformation of original variables
                      ln.lgif + ln.rgif + ln.agif + ln.tgif +
                      ln.avhv + ln.incm + ln.lgif + ln.rgif + ln.tdon + ln.tlag +  
                      
                      #ln transformation of calculated variables
                      ln.C_plow_incm + sqr.C_agif_lgif + ln.C_plow_avhv + ln.C_avhv_incm +
                      ln.C_lgif_rgif + ln.C_rgif_agif,
                    data=data.train.std.y,
                    method="nnet", maxit=1000, tuneGrid=mygrid, trace=FALSE)

print(model.nn3.a)


#---------------------------------------------------------------------------------------------------
# Neural Network#4
#---------------------------------------------------------------------------------------------------

set.seed(3232)
model.nn4 <- nnet(damt/19 ~
                    #binary vars: original
                    reg1 + reg2 + reg3 + reg4 + home + #genf +
                    
                    #numerical categorical (original) remove if dummy var used
                    chld + hinc + wrat +
                    
                    #continuous (original)
                    #avhv + incm +  tgif + lgif + rgif + tdon + tlag + agif +
                    #remove if using dummy variables
                    plow + npro +
                    
                    #dummy variables
                    #chld.0 + chld.1 + #chld.2_5 +
                    #hinc.0_2.5 + hinc.2.5_5 + #hinc.5_max +
                    #wrat.0_3.5 + wrat.3.5_5 + #wrat.6_max +
                    #plow.0_5 + plow.5_15 + #plow.15_max +
                    #npro.0_30 + npro.40_50 + npro.50_70 + npro.70_90 + #npro.90_max +
                    
                    #ln transformation of original variables
                    ln.lgif + ln.rgif + ln.agif + ln.tgif +
                    ln.avhv + ln.incm + ln.lgif + ln.rgif + ln.tdon + ln.tlag +  
                    
                    #ln transformation of calculated variables
                    ln.C_plow_incm + sqr.C_agif_lgif + ln.C_plow_avhv + ln.C_avhv_incm +
                    ln.C_lgif_rgif + ln.C_rgif_agif,
                  
                  data = data.train.std.y,
                  decay=0.1, size=6) # scale inputs: divide by 50 to get 0-1 range

pred.nn4 <- predict(model.nn4, newdata = data.valid.std.y)*19 # multiply 50 to restore original scale

mean((pred.nn4 - data.valid.std.y$damt)^2) 
sd((pred.nn4 - data.valid.std.y$damt)^2)/sqrt(n.valid.y)
#---------------------------------------------------------------------------------------------------
# Results
#---------------------------------------------------------------------------------------------------

#this is the line to change the valiation data to a matrix
xvalid=model.matrix(damt~., data.valid.std.y)

#changes the test data to a matrix to be able to make prediction
head(data.test.std)
head(data.valid.std.y)
xtest=model.matrix(~.,data.test.std)
head(xtest)
yhat.test <- predict(model.lass, s=bestlam, newx=xtest) # test predictions


#---------------------------------------------------------------------------------------------------
#
# FINAL RESULTS
#
#---------------------------------------------------------------------------------------------------

uppmargin=yhat.test+1.39
sum(uppmargin)
lowmargin=yhat.test-1.39
sum(lowmargin)
sum(yhat.test)

# Save final results for both classification and regression

length(chat.test) # check length = 2007
length(yhat.test) # check length = 2007
chat.test[1:10] # check this consists of 0s and 1s
yhat.test[1:10] # check this consists of plausible predictions of damt

ip <- data.frame(chat=chat.test, yhat=yhat.test) # data frame with two variables: chat and yhat
write.csv(ip, file="JMD_Predict422_Sec58.csv", row.names=FALSE) # use your initials for the file name

# submit the csv file in Angel for evaluation based on actual test donr and damt values
