

#----------------------------------------------------------
# EXAMPLE 1
# This example shows right and left convergence to a value.  
# Convergence at x=0.0 will be shown graphically using g(x).
import numpy 
from numpy import sin, arange
import matplotlib.pyplot 
from matplotlib.pyplot import *

# This is the function being evaluated (can be substituted)
def g(x):
	g = (sin(x)) 
	return g
n=5   # of values calculated on each site of target (x=0 in this case)
powers=arange(0,n+1)  # creates an array from zero to n+1
# raises 2 to increasing power as specified above with arange function
denominator=2.0**powers 

# interval used on either side of the origin
delta=2.0 

# produces increasing smaller x values as limit x=0.0 is 
# approached from right
x_r=0.0 + delta/denominator
# produces increasing smaller x values as limit x=0.0 is 
# approached from left
y_r=g(x_r) 
x_l=-x_r  # negative sign generates a symmetric point on the left
y_l=g(x_l)

# determines vertical boundaries of the resulting plot.
ymax=max(abs(y_r))+0.5  # vertical boundaries by max value of y_r and y_l
ymin=-ymax  # negative of ymax making equal interval on both sides of xaxis


figure()
xlim(0.0-delta-0.5,0.0+delta+0.5)  # sets graph x lim to equal interval around x=0.0
ylim(ymin,ymax)  # sets graph y lim to ymin and ymax values

# plots x_r and x_l in layers
plot(x_r,y_r, color='b')
plot(x_l,y_l,color='r')

# computes the black dots
scatter(x_r,y_r,color='k',s=30)
scatter(x_l,y_l,color='k',s=30)
scatter(0.0,g(0.0),c='y',s=40)

title ('Example of Convergence to a Functional Value')
xlabel('x-axis')
ylabel('y-axis')
show()



#----------------------------------------------------------
# EXAMPLE 2
# Another example to find limit of convergence on a value with 
# slightly different code than above.  This example converges on x=2.0

import numpy 
from numpy import sin, arange
import matplotlib.pyplot 
from matplotlib.pyplot import *

# This is the function in Lial Section 11.1 Example 1
def g(x):
	g = (x*x) 
	return g
  
n=5   # determines the number of values calculated on each side of x=0. 

powers=arange(0,n+1)
denominator=2.0**powers   # denominator contains exponentiated values of 2.0.   
delta=2.0                                         


# This is the interval used on either side of x=2.0.
# The following are values of x and f(x) trending to the limit at 
# x=2.0.# Delta is being divided by powers of 2 to reduce the distance 
# from the limit
x_r=2.0+delta/denominator   #Approaching from the right.
y_r=g(x_r)
x_l=2.0-delta/denominator   #Approaching from the left.
y_l=g(x_l)

# The following determine the vertical boundaries of the resulting plot.
ymax1=max(abs(y_r))+0.5
ymax2=max(abs(y_l))+0.5
ymax=max(ymax1,ymax2)
ymin1=min(abs(y_r))-0.5
ymin2=min(abs(y_l))-0.5
ymin=min(ymin1,ymin2)

figure()
xlim(2.0-delta-0.5,2.0+delta+0.5)
ylim(ymin,ymax)

plot(x_r,y_r, color='b')
plot(x_l,y_l,color='r')

scatter(x_r,y_r,color='k',s=30)
scatter(x_l,y_l,color='k',s=30)
scatter(2.0,g(2.0),c='y',s=40)

title ('Example of Convergence to a Functional Value')xlabel('x-axis')ylabel('y-axis')
 
show()


#----------------------------------------------------------
# EXAMPLE 3
# Shows convergence to a limit at infinity.
# The coding shows list manipulations resulting in a plot.

import numpy 
from numpy import sin, arange
import matplotlib.pyplot 
from matplotlib.pyplot import *

# function to be evaluated
def f(x):
	f = ((12.0*x*x - 15.0*x +12.0)/(x*x+1.0)) 
	return f

number=200  # number of points to be calculated as limit is approached
x=arange(0,12,0.25)  # defines the domain for x
y=f(x)
z=12.0+0.0*x  # defines a straight line at the limit

figure()
# define x and y plot ranges
xlim(-1,14)
ylim(0,15.0)

# plots x vs. z to get the straight line
plot(x,z, color='b', label='limit is 12.0') 

plot(x,y, color='r') 
scatter(x,y,color='k',s=20)  # scatter plot, black dots at size 20
scatter(number,y[-1],c='y',s=40)  # scatter plot for number of points to be calculated
title ('Example of Convergence to a Limit at Infinity')
legend(['limit is 12.0'],loc='best') 
xlabel('xaxis')
ylabel('yaxis')
show()
