


# NOTE: this is basic formula but is not efficient and slow.  
#   Better to use the line below:

# gets ISLR data
# gets boot function

require(ISLR)
require(boot)
glm.fit=glm(mpg~horsepower, data=Auto)
cv.glm(Auto, glm.fit)$delta
