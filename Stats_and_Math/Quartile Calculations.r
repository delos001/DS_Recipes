# Illustration of the differences in how quartiles are computed.

# Options available in the quantile() function of R.
?quantile()

#Checking the previous calculations.

x <- c( 1.3, 2.2, 2.7, 3.1, 3.3, 3.7)
p <- c(0.25, 0.5, 0.75)

quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 1)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 2)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 3)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 4)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 5)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 6)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 7)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 8)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 9)

#-------------------------------------------------------------------------------

# Data from page 18 of Wilcox using an even number of observations.

x <- c(-29.6,-20.9,-19.7,-15.4,-12.3,-8.0,-4.3,0.8,2.0,6.2,11.2,25.0)
length(x)
sort(x, decreasing = FALSE)

# The three quartiles are supposed to divide the data into four equal parts.
# The question is how this should best be done. There are various methods.

# Black's method gives -17.55 which matches type = 2 in R.
-0.5*(19.7+15.4)

# Wilcox describes a different interpolation method.  His method is shown on 
# page 19 and results in -17.9.  

# The summary() function uses the type = 7 option.  This results in -16.480.
summary(x)

# Here are some results using each of the different options in R.

p <- c(0.25, 0.5, 0.75)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 1)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 2)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 3)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 4)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 5)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 6)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 7)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 8)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 9)

# boxplot.stats() provides numerical information about the construction of the boxplot.

boxplot(x, col = "blue")
boxplot.stats(x)

#-----------------------------------------------------------------------------------------------
# Example using Black page 62 with an odd number of observations.

x <- c( 292.4, 216.3, 110.6, 70, 54.8, 48.8, 43.7,
        42.3, 40.7, 31.2, 30.8, 30.6, 29.4, 26.2, 22.6)

length(x)
sort(x, decreasing = FALSE)
# Black's Q1 is 30.6 and Wilcox's is 30.64.  For Wilcox we have the following:
# h = 3.75 + 5/12 - 4 = 0.167.   (1 - 0.167)(30.6) + 0.167(30.8) = 30.64.

p <- c(0.25, 0.5, 0.75)

quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 1)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 2)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 3)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 4)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 5)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 6)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 7)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 8)
quantile(x, probs = p, na.rm = FALSE, names = TRUE, type = 9)

boxplot(x, col = "red")
boxplot.stats(x, coef = 1.5, do.conf = TRUE, do.out = TRUE)

#-------------------------------------------------------------------------------
# Boxplot uses type 2 if n is even and type 7 if n is odd as verified using
# boxplot.stats
#-------------------------------------------------------------------------------
