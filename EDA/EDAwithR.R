
#NOTE: stargazer has summary statistic capabilities

#-----------------------------------------------------
# BASIC EDA WITH AUTO DATASET
str(auto)
attributes(auto)
dim(auto)
auto[1:4,]
head(auto)
tail(auto)
names(auto)
dimnames(auto)

summary(auto)
summary(auto$mpg)

aggregate(Sepal.Length ~ Species, summary, data=iris)


# SUMMARY STATISTICS CUSTOM FUNCTION
range <- function(x) {max(x, na.rm = TRUE) - min(x, na.rm = TRUE)}  #need this line!!
summary_stats = function(x) {
  stats = data.frame(rbind(range(x),
                           min(x, na.rm=TRUE),
                           quantile(x, probs = c(0.10), na.rm = TRUE),                           
                           quantile(x, probs = c(0.25), na.rm = TRUE),
                           mean(x, na.rm = TRUE),
                           median(x, na.rm = TRUE),
                           quantile(x, probs = c(0.75), na.rm = TRUE),
                           quantile(x, probs = c(0.90), na.rm = TRUE),
                           max(x, na.rm=TRUE),
                           sd(x, na.rm = TRUE),
                           var(x, na.rm = TRUE)),
  row.names = c("Range", "Min", "Q10", "Q25", "Mean", "Med", "Q75", 
                "Q90", "Max", "SD", "Var"))
  colnames(stats)=colnames(x)
  return(stats)
}

#only select variables of interst in line below
round(t(data.frame(apply(feat_comb[, 5:24], 2, summary_stats))),2)
round(summary_stats(feat_comb$reanalysis_air_temp_k),2)

#-----------------------------------------------------
# BASIC EDA WITH fBASICS

library(fBasics)
round(basicStats(charity[,11:21])[c("Minimum", 
                                    "1. Quartile", 
                                    "Mean","Median", 
                                    "3. Quartile", 
                                    "Maximum"),],
      2)


# EXAMPLE 2
require(fBasics)
cols<-c(2:7,9:10)

round(basicStats(mydata[,cols])[c('Minimum',
                                  '1. Qu',
                                  'Median',
                                  'Mean',
                                  '3. Qu',
                                  'Maximum'),],
      3)
#-------------------------------------------------------------------
# VARIABLE RELATIONSHIPS

# SCATTER PLOT MATRIX------------------------
par(mfrow = c(1,1))  #create scatter plot matrix for all variables
pairs(iris)
pairs(Smarket, col=Smarket$Direction)  # colors dots based on the response:Direction variable

# if you have a lot of variables and can't use pairs, you can create correlation matrix by hand
par(mfrow = c(4,4))
colNames1 = names(feat_eda[5:5])
colNames2 = names(feat_eda[6:10])

for (k in colNames1){
  for (i in colNames2){
    plot(feat_eda[,c(k,i)])
  }
}
par(mfrow = c(1,1))

# 3D scatter plot------------------------
library(scatterplot3d)
scatterplot3d(iris$Petal.Width, iris$Sepal.Length, iris$Sepal.Width)

#COVARIANCE------------------------
cov(iris$Sepal.Length, iris$Petal.Length)
cov(iris[,1:4])
cor(Smarket[,-9])  # excludes the qualitative variable

#QUANTILES------------------------
quantile(iris$Sepal.Length)  # gets default quartiles (0, 25, 50, 75, 100 %)
quantile(iris$Sepal.Length, c(0.1, 0.3, 0.65))

#DISTRIBUTION (plots)------------------------
# boxplot
par(mfrow = c(1,3))
boxplot(Sepal.Length ~ Species, data=iris)
with(iris, plot(Sepal.Length, Sepal.Width, 
                col=Species, 
                pch=as.numeric(Species)))
plot(jitter(iris$Sepal.Length), 
     jitter(iris$Sepal.Width))

# histogram------------------------
par(mfrow = c(1,2))
hist(iris$Sepal.Length)
plot(density(iris$Sepal.Length))

# pie and barplot------------------------
table(iris$Species)
par(mfrow = c(1,2))
pie(table(iris$Species))
barplot(table(iris$Species))

# heatmap------------------------
distMatrix=as.matrix(dist(iris[,1:4]))
heatmap(distMatrix)

# level plot------------------------
# create level plot : 
#   creates varied color for Petal width for the scatter 
#     plot of sepalwidth vs. sepallength.  
#   the varied colors are grey with 10 different color levels.
distMatrix=as.matrix(dist(iris[,1:4]))
heatmap(distMatrix)
library(lattice)
levelplot(Petal.Width~Sepal.Length*Sepal.Width, 
          iris, 
          cuts=9, 
          col.regions=grey.colors(10)[10:1])


# contour plot------------------------
# create contour map of the volcano data: 
#       colored by terrain (pre-defined color scheme in R), 
add an axis that shows the range by color
par(mfrow = c(1,1))
filled.contour(volcano, 
               color=terrain.colors, 
               asp=1,
               plot.axes = contour(volcano, 
                                   add=T))



