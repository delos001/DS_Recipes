# IN THIS SCRIPT
# Base R
# Kable example
# DT package

#----------------------------------------------------------
#----------------------------------------------------------
# BASE R
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# BASIC SYNTAX
mytable <- (table(tumor$sex,tumor$status))
prop.table(mytable)
addmargins(mytable)
prop.table(mytable, 1) 
prop.table(mytable, 2) 

#----------------------------------------------------------
# EXAMPLE 1A, 1B
tbl1<-addmargins(table(mydata$SEX,mydata$CLASS))
#A
addmargins(tbl1,c(2,1), 
           FUN = list(list(Min = min, 
                           Max = max), 
                      Sum = sum))
#B
addmargins(tbl1,c(2,1), 
           FUN = list(list(Min = min, 
                           Max = max, S
                           Sum=sum), 
                      Sum = sum))

#----------------------------------------------------------
# EXAMPLE 2
xs <- aggregate(Spending~location+region,data = food, mean)
xi <- aggregate(Income~location+region,data = food, mean)
xl <- aggregate(Debt~location+region,data = food, mean)
xr <- aggregate(ratio~location+region, data = food, mean)

overview <- cbind(xs, xi[,3], xl[,3], xr[,3], count)
colnames(overview) <- c("location","region","Spending","Income","Debt","Ratio","Count")
overview



#----------------------------------------------------------
# EXAMPLE USING KABLE
kable(as.data.frame.matrix(  #convert table to data.frame.matrix to add kable
  t(  #transpose table switching columsn with rows
    round(
      addmargins(
        prop.table(
          table(stSUBJp$Status, edcSUBJ$SiteGroup)),
        #prop.table: grand total = blank, 1 = row%, 2 = col#
      c(1,2)), #addmargins: 1 for row totals, 2 for col totals
    2)))) #round: number of spaces to round to



#----------------------------------------------------------
#----------------------------------------------------------
# DT Package
#----------------------------------------------------------
#----------------------------------------------------------
library(DT)

datatables(prices)
datatables(prices, filter='top')
datatabels(prices, filter = 'top', rownames = FALSE)
datatables(prices, filter = 'top', options = list(paging = FALSE)
datatables(prices, filter = 'top', options = list(paging = FALSE) %>%
           formatPercentage('Change', digits = 1)
