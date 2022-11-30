
# Demonstrate how to handle negative areas with numerical integration, 
# plot results using Python fill_between, and 
# demonstrate the use of an inequality for plotting different colors.


import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 
from numpy import *

# define the function you are working with
def f(x):
	f = x*x-4.0
	return f

# "integrate" is a general numercial integration function that will use 
# the function defined above
# integrate requires an interval [a,b] and number of subintervals 'n'
# delta will divide interval [a,b] by n subintervals
def integrate(a,b,n):
	sum = 0.0
	delta = (b-a)/n
	i = 0
	while i < n:
		sum = sum + delta*(f(a+delta*(i+1))+f(a+delta*i))/2
		i = i+1
	return sum

c = 4.0  # sets c right bound point at 4.0
b = 2.0  # sets b as intermediate point at 2.0
a = 0.0  # sets a as left bound point at 0
n=100    # sets n as 100

area1 = integrate(a,b,n)  # sets area1 as the area under the curve from a to b
area2 = integrate(b,c,n)  # sets area2 as the area under the curve from b to c 
# sets total area as absolute value of area1 plus absolute value of area2
area = abs(area1)+np.abs(area2)  

# value of the area as calculated in the intergrate function above
print "Final Estimate of Area= %r" %area

# defines the interval for the color red. 
# (note that 2.1 is not included; only 2.0)
x = arange(0.0,2.1,0.1) 
y = f(x)
# fill_between() requires an array for x and two functions for y between which 
# the color is filled. In this case we use 0.0 for the x-axis and y.  alpha 
# controls the intensity of the color.
fill_between(x,0,y,color='r',alpha=0.8)

# This defines the interval for the color blue. (note that 4.1 is not included; only 4.0)
# notice y1 is defined instead of just y as above
x = arange(2.0,4.1,0.1) 
y1 = f(x)
fill_between(x,0.0,y1,color='b',alpha=0.8)

# This section sets up the dimensions of the plot and creates it. 
# We have to consider both plots and find the min and max of y for plot limits.
ymin = min(min(y),min(y1))
ymax = max(max(y),max(y1))
xlim(-0.5,4.5)  # sets x limits
ylim(ymin-1.0,ymax+1.0)  # sets y limits as ymin minus 1 and ymax plus 1

xlabel('x-axis')
ylabel('y-axis')
title('Plot Showing Color Coded Integration Areas')
show()



# This code shows how to plot different colors using a logical operator 
# in the plotting statement. The operator will control when each color is used.


figure() # separates the two plots from each other.
x = arange(0.0,4.1,0.1)  # defines the interval for color filling.
y = f(x)
plot(x,y,c='k')

# shows how to fill between lines using an inequality 
# (for y values that are negative in this case)
fill_between(x,0.0,y,where= y < 0.0, facecolor = 'y',interpolate=True)
fill_between(x,0.0,y,where= y > 0.0, facecolor = 'g', interpolate=True)

xlim(-0.5,4.5)
ylim(ymin-1.0,ymax+1.0)
xlabel('x-axis')
ylabel('y-axis')
title('Plot Showing Color Coded Integration Areas')
show()
