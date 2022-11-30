
# The “for” loop tells R that we want to conduct a task a specified number of times. 
# The format is simple: 
# 		for (i in values){ 
#			…program statements… 
#}

# values is a vector
# i is a identifier (and can be substituted with another symbol


#----------------------------------------------------------
# BASIC EXAMPLE 1
# for each value of k in sequence 1 to 10
#  	sets the current sum value to the previous sum value plus 
#	the next k value and loops through for each k value 1 to 10
sum<- 0

for(k in 1:10){
	sum<-sum+k
}
sum

		   
		   

x <- 5
for(i in 1:x) {
	print(factorial(i))
}

# [1] 1
# [1] 2
# [1] 6
# [1] 24
# [1] 120



# COMPLEX EXAMPLE
# creates an empty object with 5 values of zero. 
# This will be used to store results from for loop below.
# using a for loop, this repeats the process in the line 
#	above for varying polynomial levels, 1-5
cv.error=rep(0,5)
for (i in 1:5) {
  glm.fit=glm(mpg~poly(horsepower, i), data=Auto)
  cv.error[i]=cv.glm(Auto, glm.fit)$delta[1]
}
cv.error    # produces MSE for each of the polynomials tested


#----------------------------------------------------------
# GGPLOT EXAMPLE
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
