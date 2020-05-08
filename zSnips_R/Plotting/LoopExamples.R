
# IN THIS SCRIPT:
# Histogram
# Density plot
# Boxplot

#----------------------------------------------------------
# GGPLOT HISTOGRAM
#Create histograms for every column in a dataframe and 
#	save them as pictures in the working directory
library(ggplot2)
plotHistFunc <- function(x, na.rm = TRUE, ...) {
	nm <- names(x)
	for (i in seq_along(nm)) {
		plots <-ggplot(x,
			       aes_string(x = nm[i])) + 
		geom_histogram(alpha = .5,
			       fill = "purple")
		ggsave(plots, 
		       filename = paste("myplot",
					nm[i],
					".png",
					sep=""))
	}
}
plotHistFunc(d) # name of a data frame



#----------------------------------------------------------
# GGPLOT DENSITY PLOT
library(ggplot2)
plotDensityFunc <- function(x, na.rm = TRUE, ...) {
	nm <- names(x) 
	for (i in seq_along(nm)) {
		plots <- ggplot(x,
				aes_string(x = nm[i])) + 
		geom_density(alpha = .5,
			     fill = "purple")
		ggsave(plots,
		       filename = paste("density",
					nm[i],
					".png",sep=""))
	}
}
plotDensityFunc(d) 


#----------------------------------------------------------
# GGPLOT BOX PLOT
library(ggplot2)
d$upsell <- as.factor(d$upsell)
for(i in names(d)) {
	png(paste("boxplot_upsell",
		  i, 
		  "png", 
		  sep = "."), 
	    width = 800, height = 600)
	d2 <- d[, c(i, "upsell")]
	print(ggplot(d2) + 
	      geom_boxplot(aes_string(x = "upsell", 
				      y = i, 
				      fill = "upsell")) + 
	      guides(fill = FALSE))
	dev.off()
}
