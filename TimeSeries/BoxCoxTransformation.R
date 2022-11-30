


x<-StudentLoans$total_increase_in_debt
y<- StudentLoans$observation_number
bc<-boxcox(x~1)
lam<-bc$x[which.max(bc$y)]
lam
BClam<-lam

truehist(BoxCox(x,lam), main="True Histograph of Increase in Debt (Box-Cox Transform)", xlab="Dollar Value of Increase in Debt (in MM, Box-Cox)", ylab="Frequency of Occurrences")

BoxCoxPlot<-ts.plot(BoxCox(x,lam), main="Total Debt Increase by Quarter (in Millions, Box-Cox Transform)", 
        xlab="Quarter in terms of Time Series", ylab="Change in Debt (Box-Cox)", col="blue")
