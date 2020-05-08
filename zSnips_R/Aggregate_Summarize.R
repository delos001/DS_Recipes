# In this script:
  # aggregate
  # with function
  # apply function

#-----------------------------------------------------------------------------
# AGGREGATE FUNCTION
# shows summary statistics of the Sepal Length, by Species
aggregate(Sepal.Length ~ Species, summary, data=iris)

# aggregate by multipole variables
VolMean<-aggregate(VOLUMEc~SEX+CLASS,data=mydata,mean)

# mean
xs <- aggregate(Spending~location+region,data = food, mean)

# standard deviation
mpg_class$SD <- aggregate(MPG ~ CLASS, mileage, sd)[, 2]



#-----------------------------------------------------------------------------
# WITH FUNCTION

# these next three are equivalent
mean(ds$cesd[ds$female==1])  
with(ds, mean(cesd[female==1]))
with(subset(ds, female==1), mean(cesd))

#------------------------
data(ToothGrowth)
with(ToothGrowth, aggregate(len, by = list(supp, dose), median))
#   Group.1 Group.2     x
# 1      OJ     0.5 12.25
# 2      VC     0.5  7.15
# 3      OJ     1.0 23.45
# 4      VC     1.0 16.50
# 5      OJ     2.0 25.95
# 6      VC     2.0 25.95

# 2. Use with() and addmargins() to produce the table of counts for the
# ToothGrowth data.

#------------------------
with(ToothGrowth, addmargins(table(supp, dose)))
#      dose
# supp  0.5  1  2 Sum
#   OJ   10 10 10  30
#   VC   10 10 10  30
#   Sum  20 20 20  60


#-----------------------------------------------------------------------------
# APPLY FUNCTION
data(quakes)
apply(quakes, 2, mean)
#       lat      long     depth       mag  stations 
# -20.64275 179.46202 311.37100   4.62040  33.41800 

# apply standar deviation function to columns (using 2) and rounding to 2 digits
set.seed(123)
x<-rnorm(1000,0,2)
y<-rnorm(1000,0,1)
Q5Compare<-cbind(x,y)
Q5Compare[1:5,]
round(apply(Q5Compare,2,sd),digit=2)
