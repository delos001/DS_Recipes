#Delosh, Jason Predict 401 SEC60 Data Analysis 2 R Code

require(ggplot2)
require(moments)
require(fBasics)
library(gridExtra)
library(rockchalk)
library(flux)

ab <- read.csv(file.path("abalones.csv"),sep=" ")
da2<-read.csv('mydataused.csv')

df2<-data.frame(da2)  #set ab as dataframe
str(da2)  #review mydata structure
head(da2) #review header data
tail(da2) #review tail data

sum(is.na(df2))

#Q1
#Q1a)

#note: ratio=shuck/volume

par(mfrow=c(1,2))
hist(df2$RATIOc,
     include.lowest=TRUE, right=TRUE,
     main='Histogram of Ratio:\nShuck to Volume',
     xlab='Ratio (g/cm^3)',
     ylab='Frequency',
     col='light green',
     xlim=c(min(df2$RATIOc)-0.05,max(df2$RATIOc)+0.05))
abline(v=mean(df2$RATIOc),col='red',lwd=3,lty=3)
abline(v=median(df2$RATIOc),col='yellow',lwd=3,lty=3)
legend(0.175,300,legend=c(sprintf('red=mean:%s',round(mean(df2$RATIOc),3)),
                    sprintf('yellow=median:%s',round(median(df2$RATIOc),3))))

qqnorm(df2$RATIOc,ylab='Sample Quanitles for Abalone Ratio',
       main='Q-Q Plot of Abalone Ratio\nvs. Norm Plot', col='red')
qqline(df2$RATIOc,col='green')
par(mfrow=c(1,1))

moments::skewness(df2$RATIOc)
moments::kurtosis(df2$RATIOc)

#Q1b
df2$L_Ratio<-log10(df2$RATIOc)
str(df2)

par(mfrow=c(1,2))
hist(df2$L_Ratio,
     include.lowest=TRUE, right=TRUE,
     main='Histogram of Log10 Transformed\nAbalone Ratio:Shuck to Volume',
     xlab='Log10 Ratio (g/cm^3)',
     ylab='Frequency',
     col='light green',
     xlim=c(min(df2$L_Ratio)-0.05,max(df2$L_Ratio)+0.05))
abline(v=mean(df2$L_Ratio),col='red',lwd=3,lty=2)
abline(v=median(df2$L_Ratio),col='yellow',lwd=3,lty=3)
legend('topright',legend=c(sprintf('red=mean:%s',round(mean(df2$L_Ratio),3)),
                          sprintf('yellow=median:%s',round(median(df2$L_Ratio),3))))

qqnorm(df2$L_Ratio,ylab='Sample Quanitles for Log10 Transformed Abalone Ratio',
       main='Q-Q Plot of Abalone Log10\nRatio vs. Norm Plot', col='red')
qqline(df2$L_Ratio,col='green')
par(mfrow=c(1,1))

moments::skewness(df2$L_Ratio)
moments::kurtosis(df2$L_Ratio)

ggplot(df2,aes(x=CLASS,y=L_Ratio))+
  geom_boxplot(outlier.color='red',
               outlier.shape =1, outlier.size=3,
               notch=TRUE)+
  ylab('Log 10 Ratio: Shuck to Volume')+xlab('Class')

#Q1c
bartlett.test(df2$L_Ratio~df2$CLASS)
bartlett.test(df2$L_Ratio~df2$SEX)

#Q2
#Q2a
aovL_Ratio_i<-aov(L_Ratio~factor(CLASS)*factor(SEX), data=df2)
summary(aovL_Ratio_i)

aovL_Ratio_ni<-aov(L_Ratio~factor(CLASS)+factor(SEX), data=df2)
summary(aovL_Ratio_ni)

#Q2b
TukeyHSD(aovL_Ratio_ni)

#Q3a
df2$Type<-combineLevels(df2$SEX,levs=c("M","F"),"ADULT")
str(df2)

#hist(df2$VOLUMEc=="ADULT")

ggplot(df2,aes(x=df2$VOLUMEc,group=Type))+
  geom_histogram(color='blue',binwidth = 25)+facet_grid(~Type)+
  xlab('Volume')+ylab('Frequency')+
  ggtitle("Abalone Volume Frequency Grouped by Maturity")

#Q3b
df2$L_Shuck<-log10(df2$SHUCK)
df2$L_Volume<-log10(df2$VOLUMEc)

grid.arrange(
  ggplot(df2,aes(x=VOLUMEc,y=SHUCK,color=CLASS,name="Class"))+
    geom_point(size=2)+xlab("Volume")+ylab("Shuck")+
    ggtitle("Volume vs. Shuck"),
  
  ggplot(df2,aes(x=L_Volume,y=L_Shuck,color=CLASS))+
    geom_point(size=2)+xlab("Log 10 Volume")+ylab("Log 10 Shuck")+
    ggtitle("Log10 Transformation: Volume vs. Shuck"),

  ggplot(df2,aes(x=VOLUMEc,y=SHUCK,color=Type))+
    geom_point(size=2)+xlab("Volume")+ylab("Shuck")+
    ggtitle("Volume vs. Shuck"),
  
  ggplot(df2,aes(x=L_Volume,y=L_Shuck,color=Type))+
    geom_point(size=2)+xlab("Log 10 Volume")+ylab("Log 10 Shuck")+
    ggtitle("Log10 Transformation: Volume vs. Shuck"),
  ncol=2)

#Q4a
shuckregress<-lm(L_Shuck~L_Volume+CLASS+Type,data=df2)
summary(shuckregress)

#Q5a
par(mfrow=c(1,2))
hist(shuckregress$residuals, col='light blue',
     main="Histogram: ANOVA Residuals",
     xlab='Residuals',ylab='Frequency',
     breaks=30)

qqnorm(shuckregress$residuals,ylab='Sample Quanitles',
       main='Q-Q Plot of ANOVA Residuals', col='red')
qqline(shuckregress$residuals,col='green')
par(mfrow=c(1,1))

moments::skewness(shuckregress$residuals)
moments::kurtosis(shuckregress$residuals)

#Q5b
grid.arrange(
ggplot(shuckregress,aes(x=df2$L_Volume,y=shuckregress$residuals))+
  geom_point(aes(color=CLASS))+xlab('Log10 Volume')+ylab('Residuals')+
  theme(legend.position='top'),

ggplot(shuckregress,aes(x=df2$L_Volume,y=shuckregress$residuals))+
  geom_point(aes(color=Type))+xlab('Log10 Volume')+ylab('Residuals')+
  theme(legend.position='top'),

ggplot(shuckregress,aes(x=CLASS,y=shuckregress$residuals))+
  geom_boxplot(outlier.color='red',
               outlier.shape =1, outlier.size=3,
               notch=TRUE)+
  ylab('Residuals')+xlab('Class'),
ggplot(shuckregress,aes(x=Type,y=shuckregress$residuals))+
  geom_boxplot(outlier.color='red',
               outlier.shape =1, outlier.size=3,
               notch=TRUE)+
  ylab('Residuals')+xlab('Type'),
ncol=2)

#test homogeneity of residuals
bartlett.test(shuckregress$residuals~CLASS,data=df2)

#Q6
#Q6a
infant<-df2$Type=="I"
adult<-df2$Type=="ADULT"
maxvol<-max(df2$VOLUMEc)
minvol<-min(df2$VOLUMEc)
difvol<-(maxvol-minvol)/1000

propI<-numeric(0)
propA<-numeric(0)
volVal<-numeric(0)
totI<-length(df2$Type[infant]) #gets count in the column
totA<-length(df2$Type[adult]) #gets count in the column

for (k in 1:1000) {
  value<-minvol+k*difvol
  volVal[k]<-value
  propI[k]<-sum(df2$VOLUMEc[infant]<=value)/totI
  propA[k]<-sum(df2$VOLUMEc[adult]<=value)/totA
}

propdf<-data.frame(volVal,propI,propA)
head(propdf)
head(propI, 20)
head(propA, 20)
head(volVal, 20)
#Q6b
nI<-sum(propI<=0.5)
splitI<-minvol+(nI+0.5)*difvol
nA<-sum(propA<=0.5)
splitA<-minvol+(nA+0.5)*difvol
rsplitI=round(splitI,2)
rsplitA=round(splitA,2)

ggplot(propdf)+
  geom_line(aes(x=volVal,y=propI, colour='Infant_Prop'),size=1)+
  geom_line(aes(x=volVal,y=propA, colour='Adult_Prop'),size=1)+
  geom_vline(xintercept=splitA)+
  geom_text(aes(splitA+25,0.48,label=round(splitA,2)))+
  geom_vline(xintercept=splitI,show.legend=TRUE)+
  geom_text(aes(splitI+25,0.48,label=round(splitI,2)))+
  geom_hline(yintercept=0.5)+
  xlab('Volume')+ylab('Proportion')+
  ggtitle("Propotion of Non-Harvetes Infants and Adults")+
  scale_colour_manual(name="Line Color",
                      values=c('Infant_Prop'="red", 'Adult_Prop'="blue"))

#Q7a,b,c
A_I_diff<-(1-propA)-(1-propI)
yloessA<-loess(1-propA~volVal,span=0.25, family=c('symmetric'))
yloessI<-loess(1-propI~volVal,span=0.25, family=c('symmetric'))
smDiff<-predict(yloessA)-predict(yloessI)

ggplot(propdf)+
  geom_line(aes(x=volVal,y=A_I_diff, colour='Actual'),size=1)+
  geom_line(aes(x=volVal,y=smDiff, colour='Smooth Curve'),size=1)+
  geom_vline(xintercept=which.max(smDiff))+
  geom_text(aes(which.max(smDiff)+20,0,
                label=sprintf('Volume:%s',which.max(smDiff)),angle=90))+
  xlab('Volume')+ylab('Proportion Difference')+
  ggtitle('Harvest Proportion Difference: Adult vs. Infant')+
  scale_colour_manual(name="Line Color",
                      values=c('Actual'="blue", 'Smooth Curve'="red"))

#Q7d
maxdiffI<-(1-propI)[which.max(smDiff)]
maxdiffI
maxdiffA<-(1-propA)[which.max(smDiff)]
maxdiffA

#Q8
#Q8a
#get volume cuttoff corresponding to the smallest volume value greater
#than the largest volume among class A1 infants **Zero Harvest
threshI<-volVal[volVal>max(df2[df2$CLASS=='A1'&
                        df2$Type=='I','VOLUMEc'])][1]

#calculate proportions for infants and adults with the threshI cutoff
harPropI<-sum(df2[df2$Type=='I',"VOLUMEc"]>threshI)/sum(df2$Type=='I')
harPropA<-sum(df2[df2$Type=='ADULT',"VOLUMEc"]>threshI)/sum(df2$Type=='ADULT')

#Q8b
#calculate the proportion of adults to be harvested based on the 
#smallest difference between adult proportion and (1-propI)
harVolA2<-volVal[which.min(abs(propA-(1-propI)))]
harPropI2<-sum(df2[df2$Type=='I',"VOLUMEc"]>harVolA2)/sum(df2$Type=='I')
harPropA2<-sum(df2[df2$Type=='ADULT',"VOLUMEc"]>harVolA2)/sum(df2$Type=='ADULT')

#Q9
ggplot(propdf)+
  geom_line(aes(x=(1-propI),y=(1-propA)),color='red',size=1)+
  geom_abline(intercept=0, slope=1, linetype=2)+
  geom_point(aes(harPropI,harPropA))+
  geom_text(aes(harPropI+0.18,harPropA,
                label=sprintf('No Infant ClassA Vol=:%s',round(threshI,1))))+
  geom_point(aes(harPropI2,harPropA2))+
  geom_text(aes(harPropI2+0.18,harPropA2,
                label=sprintf('Equal Harvest Vol=:%s',round(harVolA2,2))))+
  geom_point(aes(maxdiffI,maxdiffA))+ #q7d
  geom_text(aes(maxdiffI+0.18,maxdiffA,
                label=sprintf('Max Prop Diff Vol=:%s',which.max(smDiff))))+
  ggtitle('ROC Curve: Adult vs. Infant Harvest Populations')+
  xlab('Infant Harvest Proportion')+ylab('Adult Harvest Proportion')
#area under the curve
auc((1-propI),(1-propA))

#total proportional yield
zhdiffy<-round(sum(df2$VOLUMEc>=volVal[threshI])/(totI+totA),2)
ehdiffy<-round(sum(df2$VOLUMEc>=volVal[harVolA2])/(totI+totA),2)
maxdiffy<-round(sum(df2$VOLUMEc>=volVal[which.max(smDiff)])/(totI+totA),2)

cutoff<-c('No Infant ClassA','Equal Harvest','Max Prop Diff')
volumes<-c(threshI,harVolA2,which.max(smDiff))
tpr<-c(harPropA,harPropA2,maxdiffA)
fpr<-c(harPropI,harPropI2,maxdiffI)
ppy<-c(zhdiffy,ehdiffy,maxdiffy)
summdf<-data.frame(cutoff,volumes,tpr,fpr,ppy)
colnames(summdf)<-c('Cutoff Type','Volume','True Pos Rate',
                    'False Pos Rate','Prop Yield')
data.frame(lapply(summdf,function(y) if (is.numeric(y)) round(y,2) else y))
