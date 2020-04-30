

mydata=read.csv(file.path("NCHSData52.csv"),sep=",", header=TRUE)
head(mydata)

meanf(mydata$All_Deaths,1)

plot(mydata[,"All_Deaths"], main="Pneumonia and Influnza Deaths: 2009 - 2017", 
     xlab="Week", ylab="Total Deaths", type="l")

plot(mydata[,"Pneumonia.Deaths"], main="Pneumonia Deaths: 2009 - 2017", 
     xlab="Week", ylab="Total Deaths", type="l")

plot(mydata[,"Influenza.Deaths"], main="Influnza Deaths: 2009 - 2017", 
     xlab="Week", ylab="Total Deaths", type="l")

plot(mydata[,"Percent.of.Deaths.Due.to.Pneumonia.and.Influenza"], 
     main="Percent of Influnza and Pneumonia Deaths: 2009 - 2017", 
     xlab="Week", ylab="% of Total Deaths", type="l")

mydata_ts=mydata_ts[,3]



mydata_ts=ts(mydata, frequency=52, start=c(2009,40))



head(mydata_ts)
plot.ts(mydata_ts)












log.mydata_ts = log(mydata_ts)
plot.ts(log.mydata_ts)
