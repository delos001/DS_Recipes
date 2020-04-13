
# determines if a value in a list is a missing value
x1<- c(1,4,3,NA,7)
is.na(x1)
# FALSE FALSE FALSE  TRUE FALSE


#----------------------------------------------------------
# CONVERT TO NA UPON READ FILE
# when you read file, use na.strings and tell R which character to 
#   replace with null values
auto=read.table("Auto.txt", header=T, na.strings="?")


#----------------------------------------------------------
# SUMMARIZE MISSING VALUES
sum(is.na(Hitters$Salary))



#----------------------------------------------------------
# DELETE MISSING VALUES
Hitters = na.omit(Hitters)
dim(Hitters)


#----------------------------------------------------------
# FILTER FOR MISSING VALUES ONLY
Hitters = Hitters[-which(is.na(Hitters$Salary)), ]


