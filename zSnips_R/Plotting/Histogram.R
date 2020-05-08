#----------------------------------------------------------
#----------------------------------------------------------
BASE R
#----------------------------------------------------------
#----------------------------------------------------------


#----------------------------------------------------------
# EXAMPLE 1
set.seed(1234)
x<-rnorm(250)
# uses \n as carriage return and 
# continues title for X~(0,1) meaning normal value x where mean is 0 and sd=1
hist(x, main='Histogram of 250 random normal values \n X~N(0,1)',
     ylab='Frequency',xlab='X')


#----------------------------------------------------------
# EXAMPLE 2
cells <- c(0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5)  #chose this or next line but not both
cells <- seq(from = 0.0, to = 3.5, by = 0.5)
mm = mean(cells)
hist(mag, 
     breaks = cells, 
     col = "red", 
     right = FALSE,   # right=FALSE: class intervals open on right, close on left
     main = "Histogram of Magnitude", xlab = "Magnitude")
abline(v = mean(mag), col = "green", lwd = 2, lty = 2)
abline(v = median(mag), col = "blue", lwd = 2, lty = 2)
curve(dnorm(cells,		# add normal density plot
	    mean = mm,
	    sd=std),
      col = "orange", 
      add = TRUE, 
      lwd = 2)


#----------------------------------------------------------
#----------------------------------------------------------
GGPLOT
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# EXAMPLE: fill by group, with geom_vlines
```{r echo=FALSE}
ggplot(edcSUBJ,aes(x = AGE,fill = SEX)) +	
  geom_histogram(alpha = 0.3, binwidth = 5) +	
  geom_vline(aes(xintercept = Age_av, color = 'Global'),
             linetype = 'dashed',
             data = stSUBJg) +
  geom_vline(aes(xintercept = Age_mean, color = SEX),
             data = stAGE) +
  scale_color_manual(name = 'Av Age', 
                     values = c('red', 'blue', 'green')) + 
  ggtitle("Age Distribution by Sex") +
  labs(y = 'Frequency',
       x = 'Age (binwidth = 5)') +
  theme_gray()
```


#----------------------------------------------------------
# EXAMPLE: Histogram with geometric density function and
# continuous fill 
```{r echo=FALSE}
ggplot(stAEp, aes(x = AE_cnt)) +
  geom_histogram(binwidth = 1,
                 aes(y = ..density.., fill = ..count..)) +
  stat_function(fun = dnorm,
                      color = "red",
                      args = list(mean = mean(stAEp$AE_cnt), 
                              sd = sd(stAEp$AE_cnt))) +
  ggtitle(label = "Adverse Event Geometric Density with Normal Curve Plot") +
  labs(y = 'Density',
       x = 'AE Count (n)')
```



#----------------------------------------------------------
# EXAMPLE: 
# Create histograms for every column in a dataframe
# save them as pictures in the working directory
library(ggplot2)
plotHistFunc <- function(x, na.rm = TRUE, ...) {
	nm <- names(x)
	for (i in seq_along(nm)) {
		plots = ggplot(x,
			       aes_string(x = nm[i])) + 
		geom_histogram(alpha = .5,
			       fill = "purple")
		ggsave(plots,
		       filename=paste("myplot",nm[i],
				      ".png",
				      sep=""))
	}
}
plotHistFunc(d) # name of a data frame



#----------------------------------------------------------
# EXAMPLE 1 many variables to breaks plots into groups
histf = function(h) {
  H = list()
  colNames3 = names(feat_eda[5:23])
  for (k in colNames3){
	  h = ggplot(feat_eda, 
		     aes_string(x = k)) + 
	  geom_histogram(alpha = .5,
			 fill = "blue", 
			 bins=20)
	  H = c(H, list(h))
  }
	return(list(plots=H, num=length(vars)))
}
HPlots = histf(h)

#call each graph in 3x3 groups 
do.call(grid.arrange, c(HPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(HPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(HPlots$plots[15:19], ncol=3, nrow=3))


#----------------------------------------------------------
# EXAMPLE 2 same as above but with factors

histf = function(h) {
	H = list()
	colNames3 = names(feat_eda[5:23])
	for (k in colNames3){
		h = ggplot(feat_eda, 
			   aes_string(x = k, color="city")) + 
		geom_histogram(alpha = .5, 
			       position="identity", 
			       fill = "white", 
			       bins=20)
		H = c(H, list(h))
	}
	return(list(plots=H, num=length(vars)))
}
HPlots = histf(h)

#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(HPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(HPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(HPlots$plots[15:19], ncol=3, nrow=3))
