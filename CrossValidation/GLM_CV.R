

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
