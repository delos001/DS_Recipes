# Like Contour Maps but with color instead of lines

#----------------------------------------------------------
# EXAMPLE 1

x=seq(-pi,pi,length=50)       # create x sequence
y=x                           # create y
f=outer(x,                    #
        y,
        function (x,y) cos(y)/(1+x^2))

fa=(f-t(f))/2                 # create fa value (z dimension value)
image(x,y,fa)                 # create heatmap



#----------------------------------------------------------
# EXAMPLE 2
distMatrix=as.matrix(dist(iris[,1:4]))
heatmap(distMatrix)

        
#----------------------------------------------------------
# LEVEL PLOT 
# creates varied color for Petal width for the scatter plot of 
#        sepalwidth vs. sepallength.  
# the varied colors are grey with 10 different color levels.
library(lattice)
distMatrix = as.matrix(dist(iris[,1:4]))
levelplot(Petal.Width~Sepal.Length*Sepal.Width, 
          iris, 
          cuts=9, 
          col.regions=grey.colors(10)[10:1])        
