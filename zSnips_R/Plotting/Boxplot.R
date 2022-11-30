

#----------------------------------------------------------
#----------------------------------------------------------
BASE R
#----------------------------------------------------------
#----------------------------------------------------------

attach(auto)
cylinders=as.factor(cylinders)
boxplot(cylinders, 
     mpg, 
     col="red", 
     varwidth=T, 
     xlab="cylinders", ylab="MPG", 
     notch = TRUE,
     main = 'Plot title name')
# boxplot stats:
# boxplot min, max, median, hinge points, wisker term points
boxplot.stats(cylinders,
              coef = 1.5, 
              do.conf = TRUE,
              do.out = TRUE)


#----------------------------------------------------------
#EXAMPLE
# creates two boxplots using the with function and 
# names them using concatenate (be sure order of names matches)
pontus<-read.csv('[pontus.csv')
with(pontus, boxplot(Ht, HtOpp, names=c('Presidents Height', 'Oponents Height')))


#----------------------------------------------------------
#EXAMPLE
# 2row x 3col matrix of plots
par(mfrow = c(2,3))
hist(food$Income, col = "red")
hist(food$Spending, col = "blue")
hist(food$ratio, col = "green")
boxplot(food$Income, col = "red")
boxplot(food$Spending, col = "blue")
boxplot(food$ratio,col = "green")
par(mfrow = c(1,1))



#----------------------------------------------------------
#----------------------------------------------------------
GGPLOT
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# EXAMPLE with hline
```{r echo=FALSE}
ggplot(stAEp,aes(y = AEperMOS,
                 x = SiteGroup,
                 fill = SiteGroup)) +
	geom_boxplot(outlier.colour = 'red',
	             outlier.shape = 6,
	             notch = FALSE,
                  notchwidth = 0.1,
	             varwidth = TRUE) +
	geom_hline(aes(yintercept = AEperMOS_g, 
                    color = 'Global'), 
	           linetype = 'dashed',
	           data = stAEg) +
  scale_color_manual(name = 'Average', 
                   values = c('red')) + 
  ggtitle(label = "AE per Month on Study") +
  theme_gray() +
  theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 0.5))
```


# EXAMPLE with grid.arrange
grid.arrange(
ggplot(mydata,
       aes(x=mydata$CLASS,
           y=mydata$VOLUMEc)) +
  geom_boxplot(outlier.color='red',
               outlier.shape =1, 
               outlier.size=3,
               notch=TRUE)+
  ylab('Volume (cm^3)') + 
  xlab('Class'),

ggplot(mydata,
       aes(x=mydata$CLASS,
           y=mydata$WHOLE)) +
  geom_boxplot(outlier.color='red',
               outlier.shape =1, 
               outlier.size=3,
               notch = TRUE)+
  ylab('Whole (g)') + 
  xlab('Class'),
  nrow=1,   # tells how may rows to make
  top='Volume and Whole Distribution Grouped by Class')



# EXAMPLE 
# Create boxplots for every column in a dataframe and 
#    save them as pictures in the working directory

#force R to recognize variable upsell within dataframe d as a factor; 
#   you will need to update this for your factor variable and dataframe
#notice the 4 instances of the outcome variable and 
#   1 instance of the dataframe in the below code; 
#   you will need to update this for your factor variable and dataframe
library(ggplot2)
d$upsell <- as.factor(d$upsell)
for(i in names(d)) {
  png(paste("boxplot_upsell",i, 
            "png", 
            sep = "."), 
      width = 800, 
      height = 600)
  
  d2 <- d[, c(i, "upsell")]
  print(ggplot(d2) + 
        geom_boxplot(aes_string(x = "upsell", 
                                y = i, 
                                fill = "upsell")) + 
        guides(fill = FALSE))
  dev.off()
}



# EXAMPLE 
# Create boxplots for every column in a dataframe and 
#    save them as pictures in the working directory
bpf = function(b) {
  B = list()
  colNames3 = names(feat_eda[5:23])
  for (k in colNames3){
    b = ggplot(feat_eda, 
               aes_string(y=k))+ 
    geom_boxplot(outlier.color='red',
                 outlier.shape =1, 
                 outlier.size=3,
                 notch=TRUE)+ 
    ylab(k)
    B = c(B, list(b))
  }
  return(list(plots=B, num=length(vars)))
}
BPlots = bpf(b)

#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(BPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots$plots[15:19], ncol=3, nrow=3))


# EXAMPLE (same as above but by factor)
#BoxPlots by country 
bpf = function(b) {
  B = list()
  colNames3 = names(feat_eda[5:23])
  for (k in colNames3){
    b = ggplot(feat_eda, 
               aes_string(x=feat_eda$city, y=k))+ 
    geom_boxplot(outlier.color='red',
                 outlier.shape =1, 
                 outlier.size=3,
                 notch=TRUE) + 
    ylab(k)
    B = c(B, list(b))
  }
  return(list(plots=B, num=length(vars)))
}
BPlots = bpf(b)

#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(BPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots$plots[15:19], ncol=3, nrow=3))
              
         
