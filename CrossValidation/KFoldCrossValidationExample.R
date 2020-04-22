


set.seed(17)  # create random sample
degree=1:5    # create vector 1:5

# create vector with containing observations 0 to 5 for each polynomial order
cv.error.10=rep(0,5)
for (d in degree){
  glm.fit = glm(mpg~poly(horsepower, d), data=Auto) # perform polynomial glm for each power, d
  # fills cv.error.10 with each value for each power, d, tested.  
  # cv.glm computes the errors here.
  cv.error.10[d]= cv.glm(Auto, glm.fit, K=10)$delta[1]  # NOTE: K can be changed, ie: 1,5,10, etc
}

plot(degree, cv.error, type="b")
line(degree, cv.error.10, type="b", col=red
cv.error.10
