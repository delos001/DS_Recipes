
#----------------------------------------------------------
# BASIC EXAMPLE
xapp<-c(8,18,7)
xnapp<-c(17,13,37)
mat<-rbind(xapp, xnapp)
chisq.test(mat)   # perform chisqrd test on binded columns



#----------------------------------------------------------
# BASIC EXAMPLE 2
# this data is from anova testing, in which a bivariate plot was produced.  
#   a 2x2 table table will be created for chi squared testing
# factor x data (monthly income) AND y data (expenditures) in school 
#   file based on the median in which the factors are: below and above
# create table with x and y data (counts instances in which data points fall 
#   in each quadrant)
X_factor <- factor(schools$X > median(schools$X), 
                   labels = c("below", "above"))
Y_factor <- factor(schools$Y > median(schools$Y), 
                   labels = c("below", "above"))
combined <- (table(X_factor, Y_factor))
addmargins(combined)

# create function to operate with the 'combined' table just created
matrix <- function(x){
  # To be used to add margins with 2x2 contingency table.  
  x13 <- x[1,1] + x[1,2]
  x23 <- x[2,1] + x[2,2]
  vc <- c(x13, x23)
  x <- cbind(x, vc)
  x31 <- x[1,1] + x[2,1]
  x32 <- x[1,2] + x[2,2]
  x33 <- x31 + x32
  vr <- c(x31, x32, x33)
  x <- rbind(x, vr)
  x
}
# when you run the function using 'combined' it will put
#   the value of combine[n,n] from the 'combine' table
matrix(combined)
chisq.test(combined, correct = FALSE)

# This produces the expected values
#       below above  vc
# below    53    22   75
# above    22    53   75
# vr       75    75  150

# Output:
# 	Pearson's Chi-squared test
# data:  combined
# X-squared = 25.627, df = 1, p-value = 4.143e-07
# very small p value so can reject the hypothesis
