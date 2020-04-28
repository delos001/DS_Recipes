
#----------------------------------------------------------
# BASIC EXAMPLE
xapp<-c(8,18,7)
xnapp<-c(17,13,37)
mat<-rbind(xapp,xnapp)
chisq.test(mat)   # perform chisqrd test on binded columns



#----------------------------------------------------------
# BASIC EXAMPLE 2
X_factor <- factor(schools$X > median(schools$X), labels = c("below", "above"))
Y_factor <- factor(schools$Y > median(schools$Y), labels = c("below", "above"))
combined <- (table(X_factor,Y_factor))
addmargins(combined)

matrix <- function(x){
  # To be used to add margins with 2x2 contingency table.  
  x13 <- x[1,1]+x[1,2]
  x23 <- x[2,1]+x[2,2]
  vc <- c(x13,x23)
  x <- cbind(x,vc)
  x31 <- x[1,1]+x[2,1]
  x32 <- x[1,2]+x[2,2]
  x33 <- x31+x32
  vr <- c(x31,x32,x33)
  x <- rbind(x,vr)
  x
}
matrix(combined)






chisq.test(combined, correct = FALSE)
