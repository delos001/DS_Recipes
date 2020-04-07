#Delosh, Jason Predict 401 SEC60 Data Analysis 1 R Code

require(ggplot2)
require(moments)
require(fBasics)
library(gridExtra)

#a) read abalones file into R
ab <- read.csv(file.path("abalones.csv"),sep=" ")

#b)
mydata<-data.frame(ab)  #set ab as dataframe
str(mydata)  #review mydata structure
head(mydata) #review header data
tail(mydata) #review tail data

sum(is.na(mydata)) #look for null values in df

###consider table to who min max ranges age range for Class

#c)
#create calculated columns (end col header with 'c' to indicate calculated)
mydata$VOLUMEc<-mydata$LENGTH*mydata$DIAM*mydata$HEIGHT
mydata$RATIOc<-mydata$SHUCK/mydata$VOLUME

#1a)
cols<-c(2:7,9:10) #set the columns that contain metric data

#using fbasics package, specify descriptive statistics based on cols vector above
round(basicStats(mydata[,cols])[c('Minimum','1. Qu','Median',
                                  'Mean','3. Qu','Maximum',
                                  'Stdev'),],3)

#1b)
summary(mydata$SEX)  #get summmary data for sex var
summary(mydata$CLASS)  #get summary data for class var

#create table grouped by sex and class and add min, max, sum, to margin
tbl1<-table(mydata$SEX,mydata$CLASS)
addmargins(tbl1,c(2,1), FUN = list(list(Min = min, Max = max,Sum=sum), Sum = sum))

#create barplot of sex frequency by class
barplot((tbl1) [c(2,1,3),], #re-orders the table columns to align legend
             legend.text=c('Infant','Female','Male'),
             main='Abalone Sex Frequencies by Class',
             ylab='Frequency',
             xlab='Age Class',
             beside=TRUE,
             col=c('light green','red','light blue'),
             names.arg=c('A1','A2','A3','A4','A5','A6'))

#1c)
set.seed(123)
#get random sample of 200 observations from mydata dataframe
set.seed(123)
work<-mydata[sample(nrow(mydata),200,replace=FALSE),]
head(work)  #check first few rows
plot(work[,2:6]) #plot the continuous variable rows 2-6

#2a)
#plot whole vs. volume
plot(mydata[,c(9,5)],
           main='Abalone Whole weight vs. Volume',
           xlab='Volume (cm^3)',
           ylab='Whole (g)')

#2b)
#plot shuck versus whole and add abline using ration max value of
#shuck to whole ration
m<-max(mydata$SHUCK/mydata$WHOLE) # used as slope of line
plot(mydata$WHOLE, mydata$SHUCK,
     main='Abalone Shuck weight vs. Whole weight',
     xlab='Whole (g)',ylab='Shuck (g)')
legend('topleft',legend=('Line = y=0.56x+0'))
abline(a=0, b=m) #a= yint, b=slope

#3a)
#use max of all samples to obtain consistent x and y lims

par(mfrow=c(3,3))
hist(mydata$RATIOc[mydata$SEX=='I'],
     include.lowest=TRUE, right=TRUE,
     main='Infant Abalone Ratio',
     xlab='Shuck to Volume Ratio (g/cm^3)',
     ylab='Frequency',
     col='light green',
     xlim=c(0.00,max(mydata$RATIOc)))

hist(mydata$RATIOc[mydata$SEX=='F'],
     main='Female Abalone Ratio',
     xlab='Shuck to Volume Ratio (g/cm^3)',
     ylab='Frequency',
     col='red',
     xlim=c(0.0,max(mydata$RATIOc)))

hist(mydata$RATIOc[mydata$SEX=='M'],
     include.lowest=TRUE, right=TRUE,
     main='Male Abalone Ratio',
     xlab='Shuck to Volume Ratio (g/cm^3)',
     ylab='Frequency',
     col='light blue',
     xlim=c(0.00,max(mydata$RATIOc)))

boxplot(mydata$RATIOc[mydata$SEX=='I'],
        main='Infant Abalone Ratio',
        col='light green',
        range=1.5,
        ylab='Shuck to Volume Ratio (g/cm^3)',
        ylim=c(0.0,max(mydata$RATIOc)),
        notch=TRUE)

boxplot(mydata$RATIOc[mydata$SEX=='F'],
        main='Female Abalone Ratio',
        col='red',
        range=1.5,
        ylab='Shuck to Volume Ratio (g/cm^3)',
        ylim=c(0.0,max(mydata$RATIOc)),
        notch=TRUE)

boxplot(mydata$RATIOc[mydata$SEX=='M'],
        main='Male Abalone Ratio',
        col='light blue',
        range=1.5,
        ylab='Shuck to Volume Ratio (g/cm^3)',
        ylim=c(0.0,max(mydata$RATIOc)),
        notch=TRUE)

qqnorm(mydata$RATIOc[mydata$SEX=='I'],
       main='Infant Abalone Ratio',
       ylab='Shuck to Volume Ratio (g/cm^3)',
       ylim=c(0.0,max(mydata$RATIOc)),
       col='light green')
qqline(mydata$RATIOc[mydata$SEX=='I'])

qqnorm(mydata$RATIOc[mydata$SEX=='F'],
       main='Female Abalone Ratio',
       ylab='Shuck to Volume Ratio (g/cm^3)',
       ylim=c(0.0,max(mydata$RATIOc)),
       col='red')
qqline(mydata$RATIOc[mydata$SEX=='F'])

qqnorm(mydata$RATIOc[mydata$SEX=='M'],
       main='Male Abalone Ratio',
       ylab='Shuck to Volume Ratio (g/cm^3)',
       ylim=c(0.0,max(mydata$RATIOc)),
       col='light blue')
qqline(mydata$RATIOc[mydata$SEX=='M'])
par(mfrow=c(1,1))

#Determine if there are any extreme outliers
#first calculate the max for each sex group

IARmax<-max(mydata$RATIOc[mydata$SEX=='I'])
FARmax<-max(mydata$RATIOc[mydata$SEX=='F'])
MARmax<-max(mydata$RATIOc[mydata$SEX=='M'])

#using max value, determine if max value is extreme outlier
IAReol<-max(mydata$RATIOc[mydata$SEX=='I']) >= 
          quantile(mydata$RATIOc[mydata$SEX=='I'],
          0.75) + 3.0*IQR(mydata$RATIOc[mydata$SEX=='I'])
FAReol<-max(mydata$RATIOc[mydata$SEX=='F']) >= 
          quantile(mydata$RATIOc[mydata$SEX=='F'],
          0.75) + 3.0*IQR(mydata$RATIOc[mydata$SEX=='F'])
MAReol<-max(mydata$RATIOc[mydata$SEX=='I']) >= 
          quantile(mydata$RATIOc[mydata$SEX=='M'],
          0.75) + 3.0*IQR(mydata$RATIOc[mydata$SEX=='M'])



#determine 1.5 and 3.0 Abalone Ration outlier and extrem outlier
#values for each sex (I,F,M)
IARolV<-quantile(mydata$RATIOc[mydata$SEX=='I'],0.75)+
      1.5*IQR(mydata$RATIOc[mydata$SEX=='I'])
IAReolV<-quantile(mydata$RATIOc[mydata$SEX=='I'],0.75)+
      3.0*IQR(mydata$RATIOc[mydata$SEX=='I'])
SumIAReolV<-sum(mydata$RATIOc[mydata$SEX=='I']>IAReolV)
SumIARolV<-sum(mydata$RATIOc[mydata$SEX=='I']>IARolV)-SumIAReolV

FARolV<-quantile(mydata$RATIOc[mydata$SEX=='F'],0.75)+
      1.5*IQR(mydata$RATIOc[mydata$SEX=='F'])
FAReolV<-quantile(mydata$RATIOc[mydata$SEX=='F'],0.75)+
      3.0*IQR(mydata$RATIOc[mydata$SEX=='F'])
SumFAReolV<-sum(mydata$RATIOc[mydata$SEX=='F']>FAReolV)
SumFARolV<-sum(mydata$RATIOc[mydata$SEX=='F']>FARolV)-SumFAReolV

MARolV<-quantile(mydata$RATIOc[mydata$SEX=='M'],0.75)+
      1.5*IQR(mydata$RATIOc[mydata$SEX=='M'])
MAReolV<-quantile(mydata$RATIOc[mydata$SEX=='M'],0.75)+
      3.0*IQR(mydata$RATIOc[mydata$SEX=='M'])
SumMAReolV<-sum(mydata$RATIOc[mydata$SEX=='M']>MAReolV)
SumMARolV<-sum(mydata$RATIOc[mydata$SEX=='M']>MARolV)-SumMAReolV

# create data frame to show output of extreme outlier check
# false values indicate outlier is not extreme
a<-c('Infant','Female','Male')
b<-c(IARmax,FARmax,MARmax)
c<-c(IAReol,FAReol,MAReol)
d<-c(IARolV,FARolV,MARolV)
e<-c(SumIARolV,SumFARolV,SumMARolV)
f<-c(IAReolV,FAReolV,MAReolV)
g<-c(SumIAReolV,SumFAReolV,SumMAReolV)
h<-data.frame(a,round(b,3),c,round(d,3),e,round(f,3),g)
colnames(h)<-c('Sex','Max Ratio','Extreme OL','OL Val','OL Count',
               'Extreme OL Val', 'Extreme OL Count')
h

#4)
#plot volume and whole as a function of class and rings
#grid arrange to plot each of the 4 graphs in one image
grid.arrange(
ggplot(mydata,aes(x=mydata$CLASS,y=mydata$VOLUMEc))+
    geom_boxplot(outlier.color='red',
                 outlier.shape =1, outlier.size=3,
                 notch=TRUE)+
  ylab('Volume (cm^3)')+xlab('Class'),

ggplot(mydata,aes(x=mydata$CLASS,y=mydata$WHOLE))+
  geom_boxplot(outlier.color='red',
               outlier.shape =1, outlier.size=3,
               notch=TRUE)+
    ylab('Whole (g)') + xlab('Class'),

ggplot(mydata,aes(x=mydata$RINGS,y=mydata$VOLUMEc))+
  geom_point(size=2, show.legend=FALSE, aes(colour=mydata$RINGS))+ 
  scale_colour_gradient(low='red',high='blue')+
  xlab('Rings')+ylab('Volume (cm^3)'),

ggplot(mydata,aes(x=mydata$RINGS,y=mydata$WHOLE))+
  geom_point(size=2, show.legend=FALSE, aes(colour=mydata$RINGS))+ 
  scale_colour_gradient(low='red',high='blue')+
  xlab('Rings')+ylab('Whole (g)'),

nrow=2,top='Abalone Volume and Whole: by Class and Ring Count')

#5a)
VolMean<-aggregate(VOLUMEc~SEX+CLASS,data=mydata,mean)
VolMat<-matrix(round(VolMean$VOLUMEc,2),3)
colnames(VolMat)<-c('A1','A2','A3','A4','A5','A6')
rownames(VolMat)<-c('Female','Infant','Male')
VolMat

RatMean<-aggregate(RATIOc~SEX+CLASS,data=mydata,mean)
RatMat<-matrix(round(RatMean$RATIOc,4),3)
colnames(RatMat)<-c('A1','A2','A3','A4','A5','A6')
rownames(RatMat)<-c('Female','Infant','Male')
RatMat

#5b)
#
grid.arrange(
ggplot(data=VolMean,aes(x=CLASS, y=VOLUMEc, group=SEX, colour=SEX))+
  geom_line(size=1,show.legend=FALSE)+geom_point(size=2.5,show.legend=FALSE)+
  ggtitle('Mean Volume vs. Class \n Grouped by Sex'),

ggplot(data=RatMean,aes(x=CLASS, y=RATIOc, group=SEX, colour=SEX))+
  geom_line(size=1)+geom_point(size=2.5)+
  ggtitle('Mean Ratio vs. Class \n Grouped by Sex'),
ncol=2)

write.csv(mydata, file='mydataused.csv',sep=' ')
write.table(tbl1,'sex_class_freq_tbl.csv',sep=" ")

