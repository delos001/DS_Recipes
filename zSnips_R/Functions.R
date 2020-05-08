
#----------------------------------------------------------
# Simple example 1
data(trees)

cv<-function(x){
	100*sd(x)/mean(x)
}
girth<-trees[,1]
cv(girth)
apply(trees,2,cv)

#----------------------------------------------------------
# Simple example 2
sampVar <- function(x) {
	return(sum((x - mean(x))^2)/(length(x)-1))
}

apply(trees, 2, sampVar)
#      Girth     Height     Volume 
#   9.847914  40.600000 270.202796 

# Compare your results to those computed with var().
apply(trees, 2, var)
#      Girth     Height     Volume 
#   9.847914  40.600000 270.202796 


#----------------------------------------------------------
# EXAMPLES THAT BUILD OFF EACH OTHER
#----------------------------------------------------------
# Example 1
Power=function(){
  2^3
}
print(Power())  # call the function

#----------------------------------------------------------
# Example 2
Power2=function(x,a){
  x^a
}
# call the function
Power2(10,3)
Power2(131,3)



#----------------------------------------------------------
# Example 3
# Now create a new function, Power3(), that actually returns 
#	the result x^a as an R object, rather than simply 
#	printing it to the screen. 
#	That is, if you store the value x^a in an object called 
#		result within your function, then you can simply 
#		return() this return() result, using following line:
return(result)
Power3=function(x,a){
  result=x^a
  return(result)
}

x=1:10
plot(x, 
     Power3(x,2), 
     log="xy", 
     ylab="Log y=x^2", 
     xlab="Log x",
     main="Log of x^2 vs. Log x")



#----------------------------------------------------------
# Example 5
# Using Power3 function from above:
#  	Create a function, PlotPower(), that allows you to 
#	create a plot of x against x^a for a fixed a and for a 
#	range of values of x. For instance, if you call 
#	PlotPower(1:10,3) then a plot should be created with an 
#	x-axis taking on values 1, 2, . . . , 10, and a y-axis 
#	taking on values 1^3, 2^3, . . . , 10^3.
PlotPower=function(x,a) {
  plot(x, Power3(x,a))
}
PlotPower(1:10, 3)

