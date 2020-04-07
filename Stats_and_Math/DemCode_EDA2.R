# Predict 401 Data Analysis Assignment Demonstration

# Note-In Course Reserves you will find Chapter 2 of Chihara and Hesterbery's book.
# This chapter is devoted to EDA and presents several EDA methods.

require(moments)
require(ggplot2)

# The Consumer Food Database is described in the "Analyzing the Databases" section 
# of Chapter 1 Black page 15.  

food <- read.csv(file.path("c:/RBlack/","Food.csv"),sep=",")
str(food)

# The variables Region and Location are read in as integers.  They are nominal
# variables and can not be used as such.  They will need to be factored.

summary(food[,1:3])
plot(food[,1:3])

# Define factors which will be used for displays and contingency tables.
# Label as indicated S for South, NE for Northeast, MW for Midwest, W for West.
# Label metro location as M, and not metro location as NM. Also define
# the variable ratio as spending divided by income.

location <- factor(food$Location, labels = c("M", "NM"))
region <- factor(food$Region, labels = c("NE","MW","S","W")) 
ratio <- food$Spending/food$Income
food <- data.frame(food, region, location, ratio)
str(food)

summary(food$ratio)

# Investigate the relationship between Income and Spending differentiated by
# region and by location.  Using ggplot2 for line plots and scatter plots is 
# discussed in the "R Graphics Cookbook" by Chang in Chapters 4 and 5. 
# Statistical graphics is discussed by Lander in Chapter 7.

ggplot(data = food, aes(x = Income, y = Spending)) + 
  geom_point(aes(color = region),size = 3) + ggtitle("Spending versus Income by Region")
ggplot(data = food, aes(x = Income, y = Spending)) + 
  geom_point(aes(color = location),size = 3) + ggtitle("Spending versus Income by Location")

# Investigate the distribution of the data. The boxplots reveal outliers.

par(mfrow = c(2,3))
hist(food$Income, col = "red")
hist(food$Spending, col = "blue")
hist(food$ratio, col = "green")
boxplot(food$Income, col = "red")
boxplot(food$Spending, col = "blue")
boxplot(food$ratio,col = "green")
par(mfrow = c(1,1))

# Checking skewness and kurtosis helps to reveal more about distribution shape.  
# A normal distribution has a skewness of zero and kurtosis of 3.0.

skewness(food$Income)
kurtosis(food$Income)
skewness(food$Spending)
kurtosis(food$Spending)
skewness(food$ratio)
kurtosis(food$ratio)

# A Q-Q plot compares sample quantiles versus standard normal quantiles.  Departure
# from a straight line indicates non-normality in the sample.  Ratio showed the
# most right skew so this will be investigated by location.

par(mfrow = c(1,2))
qqnorm(food[food[,7]== "M",8], ylab = "Sample Quantiles of Ratio for Metro Areas",
       main = "Q-Q Plot of Ratio for Metro Areas", col = "red")
qqline(food[food[,7]== "M",8], col = "green")
qqnorm(food[food[,7]== "NM",8], ylab = "Sample Quantiles of Ratio for Not-Metro Areas",
       main = "Q-Q Plot of Ratio for Non-Metro Areas", col = "red")
qqline(food[food[,7]== "NM",8], col = "green")
par(mfrow = c(1,1))

#  Various functions will be used to generate a table which can be used for plotting.

out <- addmargins(table(location,region))
out
count <- c(out[1,1],out[2,1],out[1,2],out[2,2],out[1,3],out[2,3],out[1,4],out[2,4])

xs <- aggregate(Spending~location+region,data = food, mean)
xi <- aggregate(Income~location+region,data = food, mean)
xl <- aggregate(Debt~location+region,data = food, mean)
xr <- aggregate(ratio~location+region, data = food, mean)
overview <- cbind(xs, xi[,3], xl[,3], xr[,3], count)
colnames(overview) <- c("location","region","Spending","Income","Debt","Ratio","Count")
overview

# Using the table "overview" different plots can be made.  Using ggplot2 for 
# line plots and scatter plots is discussed in the "R Graphics Cookbook" by Chang.
# See Chapters 4 and 5. Statistical graphics is discussed by Lander in Chapter 7.

ggplot(data = overview, aes(x = region, y = Spending, group = location, 
  colour = location))+ geom_line()+ geom_point(size = 3)+ 
  ggtitle("Plot showing Spending of Locations versus Region")
ggplot(data = overview, aes(x = region, y = Ratio, group = location, 
  colour = location))+ geom_line()+ geom_point(size = 3)+ 
  ggtitle("Plot showing Ratio of Locations versus Region")

ggplot(data = overview, aes(x = location, y = Spending, group = region, 
  colour = region))+ geom_line()+ geom_point(size = 3)+ 
  ggtitle("Plot showing Spending of Regions versus Location")
ggplot(data = overview, aes(x = location, y = Ratio, group = region, 
  colour = region))+ geom_line()+ geom_point(size = 3)+ 
  ggtitle("Plot showing Ratio of Regions versus Location")

# Further analysis of the role played by location and region is indicated.  This
# would be best pursued using multiple linear regression.  However, the plot of
# spending versus income indicates the data need to be transformed first so that
# regression assumptions are satisfied.
#-------------------------------------------------------------------------------
