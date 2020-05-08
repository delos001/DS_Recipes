# IN THIS SCRIPT:
# basic math
# solver examples
# matrix solver custom function example

# See matrices file for basic matrix creation/manipulation


#----------------------------------------------------------
#----------------------------------------------------------
# BASIC MATH
#----------------------------------------------------------
#----------------------------------------------------------
# EXAMPLE DATASET
z <- matrix(c(5,7,9,6,3,4), nr=3, byrow=T)
y<-matrix(c(1,3,0,9,5,-1),nrow=3,byrow=T)
x<-matrix(c(3,4,-2,6),nrow=2,byrow=T)

#----------------------------------------------------------
# ADDITION
z+y


#----------------------------------------------------------
# MULTIPLICATION
z*y


# %*% is the way to generate a correct matrix multiplication 
#     using matrix multiplication rules. 
# ***Note row number of x matches column number of y, 
#     which is needed to perform matrix multiplication

y%*%x

#----------------------------------------------------------
# OTHER OPERATION EXAMPLES
sqrt(x)
x^2




#----------------------------------------------------------
#----------------------------------------------------------
# SOLVER EXAMPLES
#----------------------------------------------------------
#----------------------------------------------------------

# Transpose the matrix mix
x<-matrix(c(3,4,-2,6),nrow=2,byrow=T)
solve(x)


# Performs matrix multiplication with x matrix times the 
#     solved x matrix rounded to 2 digits

round(x%*%solve(x),digits=2)

# Another example:
Q4A<-matrix(c(1,-1,1,1,1,-1,1,1,1),nrow=3,byrow=T) # eqn left hand side
Q4b<-rbind(1,1,3)   # eqn right hand side
solve(Q4A,Q4B)

# An example with an unsquare matrix.
r1 <- c(1, 1)
r2 <- c(1, 1)
r3 <- c(2, 3)
coef <- (rbind(r1,r2,r3))
v <- c(0, 4)
result(coef,v)

# An example with the wrong variable count.
r1 <- c(1, 1)
r2 <- c(1, 1)
coef <- (rbind(r1,r2))
v <- c(0)
result(coef,v)

# An example with no solution.
r1 <- c(1, 1)
r2 <- c(1, 1)
coef <- (rbind(r1,r2))
v <- c(0, 4)
result(coef,v)

# Now an example with a solution.
r1 <- c(1,-1)
r2 <- c(1, 1)
coef <- (rbind(r1,r2))
v <- c(0, 4)
result(coef,v)

# Now check to see if y can be reproduced.
coef%*%result(coef,v)




#----------------------------------------------------------
#----------------------------------------------------------
# SOLVER CUSTOM FUNCTION
#----------------------------------------------------------
#----------------------------------------------------------
result <- function(M, y){
  
  # Make sure matrix is square.
  if (nrow(M) != ncol(M)) {
    x <- c("Not Square")
  }
  # Check the number of unknowns.
  else if (length(y) != ncol(M)) {
    x <- c("Wrong Variable Count")
  }
  # Use determinant to check that a solution exists.
  else if (abs(det(M)) < 0.000001) {
    x <- c("No Solution")
  }
  else {
    x <- solve(M)%*%y
  }
  return(x)
}
