
#----------------------------------------------------------
# EXAMPLE 1
x<-c(7.5, 8.2, 3.1, 5.6, 8.2, 9.3, 6.5, 7.0, 9.3, 1.2, 14.5, 6.2)
mean(x)

#----------------------------------------------------------
# EXAMPLE 2
tapply(tumor$thickness, list(tumor$sex, tumor$ulcer), FUN = mean)

#----------------------------------------------------------
# EXAMPLE 3
price<-hp($PRICE)
set.seed(9999)
SRS<-sample(price,12)
mean(SRS)

#----------------------------------------------------------
# EXAMPLE 4
apply(USArrests, 2, mean)

#----------------------------------------------------------
# EXAMPLE 5
# ROW MEANS
cc_data_fact$Avg_Bill_Amt = rowMeans(cc_data_fact[,13:18])


#----------------------------------------------------------
# EXAMPLE 6
# MEAN BY CLASSES
mpg_class <- aggregate(MPG ~ CLASS, mileage, mean)
