


#----------------------------------------------------------
# Outlier detection from boxplot
# this gets max value and sets as an object for each variable.  
#   in this example, female abalone ration, infant abalone ratio, 
#   male abalone ratio

FARmax<-max(mydata$RATIOc[mydata$SEX=='F'])
IARmax<-max(mydata$RATIOc[mydata$SEX=='I'])
MARmax<-max(mydata$RATIOc[mydata$SEX=='M'])

FAReol <- max(mydata$RATIOc[mydata$SEX=='F']) >= 
                    quantile(mydata$RATIOc[mydata$SEX=='F'],
                             0.75) + 3.0*IQR(mydata$RATIOc[mydata$SEX=='F'])
IAReol <- max(mydata$RATIOc[mydata$SEX=='I']) >= 
                    quantile(mydata$RATIOc[mydata$SEX=='I'],
                             0.75) + 3.0*IQR(mydata$RATIOc[mydata$SEX=='I'])
MAReol <- max(mydata$RATIOc[mydata$SEX=='I']) >= 
                    quantile(mydata$RATIOc[mydata$SEX=='M'],
                             0.75) + 3.0*IQR(mydata$RATIOc[mydata$SEX=='M'])
