# Demonstration R Code for PREDICT 401 
# These are magnitude data derived from earthquake data.


mag <- c(0.70, 0.74, 0.64, 0.39, 0.70, 2.20, 1.98, 0.64, 1.22, 0.20, 1.64, 1.02, 
         2.95, 0.90, 1.76, 1.00, 1.05, 0.10, 3.45, 1.56, 1.62, 1.83, 0.99, 1.56,
         0.40, 1.28, 0.83, 1.24, 0.54, 1.44, 0.92, 1.00, 0.79, 0.79, 1.54, 1.00,
         2.24, 2.50, 1.79, 1.25, 1.49, 0.84, 1.42, 1.00, 1.25, 1.42, 1.15, 0.93,
         0.40, 1.39)

help(sort)

mag <- sort(mag, decreasing = FALSE)
mag

summary(mag)

#-------------------------------------------------------------------------------
# Measures of central tendency
#-------------------------------------------------------------------------------
# Find the mean value.

mean(mag)

#-------------------------------------------------------------------------------
#Find the 20% trimmed mean and check

# Calculate 0.2*length(mag) and round down to the nearest integer.
# Cut this number of observations from the bottom and the top of ranked data.
# See Wilcox page 26.
mag
round(0.2*length(mag))

mag[11:40]
mean(mag[11:40])

mean(mag, trim = 0.2)

# Find median with even number of observations.
length(mag)
(mag[25]+mag[26])/2

# Find mode
y <- factor(mag)
summary(y)

#-------------------------------------------------------------------------------
# Supplemental function for finding the mode
# 1) transform numeric values into factor
# 2) use summary() to gain the frequency table
# 3) return mode the index whose frequency is the largest
# 3) transform factor back to numeric even there are more than 1 mode

mode <- function(x){
  y <- as.factor(x)
  freq <- summary(y)
  mode <- names(freq)[freq[names(freq)] == max(freq)]
  as.numeric(mode)
}
mode(mag)


#-------------------------------------------------------------------------------
# Measures of dispersion or variation

# Find range
max(mag)-min(mag)

range(mag)

# Find standard deviation and check the calculation
sd(mag)

sqrt((sum((mag - mean(mag))^2))/(length(mag)-1))

# Find the Percent Coefficient of Variation
100*sd(mag)/mean(mag)

# Find the Winsorized sample standard deviation and check.

require(asbio)
win(mag, lambda = 0.2)
sd(win(mag, lambda = 0.2))

mag.win <- mag[11:40]
bottom <- rep(min(mag.win), times = 10)
top <- rep(max(mag.win), times = 10)
mag.win <- c(bottom, mag.win, top)
mag.win
sd(mag.win)

# Example from Wilcox pages 27-28.
x <- c(1,2,8,9,10,16,18,22,27,29,35,42)
var(win(x, lambda = 0.2))

#-------------------------------------------------------------------------------
# Quartiles serve different purposes.  They indicate location, but also spread.
# Comparison of quartiles from different methods Black type=2, summary() type=7

quantile(mag, probs = c(0.25, 0.5, 0.75), type = 2)

quantile(mag)
summary(mag)
quantile(mag, probs = c(0.25, 0.5, 0.75), type = 7)

#-------------------------------------------------------------------------------
# Displays of shape or distribution

# Stem-and-leaf plot
mag
stem(mag)
stem(mag, scale = 0.5)

# Illustration of boxplot

boxplot(mag)
boxplot(mag, col = "blue", range = 1.5, main = "Boxplot of Magnitude", 
        ylab = "Magnitude", notch = TRUE)
boxplot.stats(mag)

# Histogram
hist(mag)

# Demonstration of how to form a histogram with defined cells such as 0.0 - to 
# under 0.5. In other words, 0.5 is included in the next cell, 0.5 -under 1.0.
# The vertical dotted green line marks where the mean value of mag is.
# The vertical dotted blue line marks where the median value of mag is.

cells <- c(0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5)
cells <- seq(from = 0.0, to = 3.5, by = 0.5)
hist(mag, breaks = cells, col = "red", right = FALSE,
     main = "Histogram of Magnitude", xlab = "Magnitude")
abline(v = mean(mag), col = "green", lwd = 2, lty = 2)
abline(v = median(mag), col = "blue", lwd = 2, lty = 2)

#---------------------------------------------------------------------------------
# This demonstrates how to form a frequency table and calculate the mean and standard 
# deviation.  Note Section 3.3 of Black.  This corresponds to the example and 
# formulas shown on page 79 of Black.

cells <- seq(from = 0.0, to = 3.5, by = 0.5)
center <- seq(from = 0.25, to = 3.25, by =  0.5)
class <- cut(mag, cells, include.lowest=TRUE, right = FALSE)

Table <- data.frame(table(class), center)
Table 

# Sample mean and standard deviation method page 79 Black.
fx <- Table$Freq*center
fx2 <- Table$Freq*(Table$center^2)
Table <- data.frame(Table, fx, fx2)

Table

average <- sum(fx)/sum(Table$Freq)
average
s2 <- sum(Table$Freq)*sum(fx2) - (sum(fx))^2
s <- sqrt(s2/(length(mag)*(length(mag)-1)))
s

#-------------------------------------------------------------------------------
# Comparison to ungrouped data.
mean(mag)
sd(mag)

#-------------------------------------------------------------------------------



