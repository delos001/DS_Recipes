# IN THIS SCRIPT:
# Reference matrix indices
# Manually create matrices
# Matrix operations


# Matrices can be transformed into a different type of R object called a data.frame.  
# Matrices and data.frames have some similar properties, but also differences
# Importantly, most data that is read in from an outside file 
#     (as opposed to typing in ourselves) will be in the form of a data.frame. 
# If you want to know whether something is a matrix or a data.frame, you can also test 
#     it using the folloiwng commands
# is.matrix()
# or
# is.data.frame()

#----------------------------------------------------------
#----------------------------------------------------------
# MATRIX INDICES
#----------------------------------------------------------
#----------------------------------------------------------
# rows, columns
z[1,1]  # gets the number in row 1, col 1
z[2,1]  # gets the number in row 2, col 1
z[c(2,3),2]   # produces value in row 2 and 3, column 2
z[,2]   # produces all values in column 2
z[1:2,] # produces values in rows 1 and 2 for both columns
z[3:4,2:3]    # gives 3rd and 4th row and 2nd and 3rd column
z[,2:3] # gives second and third column
z[,1]   # gives just the first column
z[,1,drop=FALSE] # gives 1st column but does not drop matrix status so it is vertical rather than horizontal

#----------------------------------------------------------
#----------------------------------------------------------
# MANUALLY CREATE MATRICES
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# CREATE RANDOM SAMPLE MATRIX (2 columns, 2 obs)
x=matrix(rnorm(20*2), ncol=2)


#----------------------------------------------------------
# CREATE MATRIX examples
z<-matrix(c(5,7,9,6,3,4),nrow=3)
z<-matrix(data=c(5,7,9,6,3,4), nrow=3, ncol=2)           
z<-matrix(data=c(5,7,9,6,3,4), 3,2)  
z<-matrix(c(5,7,9,6,3,4),nrow=3,byrow=F)  # byrow = F is default
z<-matrix(c(5,7,9,6,3,4),nrow=3,byrow=T)  # fills the matrix by row instead of column
z=matrix(seq(1,12),4,3)

# CREATE MATRIX USING VECTOR
y=c(1,2,3,4)
x=matrix(data=y,nrow=2, ncol=2)   # uses y as an object rather than typing each number
x


#----------------------------------------------------------
# CREATE MATRIX WITH TWO LISTS
x<-c(5,7,9)
y<-c(6,3,4)
z<-cbind(x,y)  # or use rbind to create 3x2 matrix
z
dim(z)



#----------------------------------------------------------
#----------------------------------------------------------
# MATRIX OPERATION EXAMPLES
#----------------------------------------------------------
#----------------------------------------------------------
x <- matrix(data = c(3, 2, -1, 1), 
            nrow = 2, 
            ncol = 2, 
            byrow = TRUE)
x
#      [,1] [,2]
# [1,]    3    2
# [2,]   -1    1

y <- matrix(c(1, 0, 4, 1), nrow = 2)
y
#      [,1] [,2]
# [1,]    1    4
# [2,]    0    1


2 * x    # (a)
#      [,1] [,2]
# [1,]    6    4
# [2,]   -2    2

x * x    # (b)
#      [,1] [,2]
# [1,]    9    4
# [2,]    1    1

x %*% x  # (c)
#      [,1] [,2]
# [1,]    7    8
# [2,]   -4   -1

x %*% y  # (d)
#      [,1] [,2]
# [1,]    3   14
# [2,]   -1   -3

solve(x) # (e)
#      [,1] [,2]
# [1,]  0.2 -0.4
# [2,]  0.2  0.6

x[1, ]   # (f)  [1] 3 2
x[, 2]   # (g)  [1] 2 1
