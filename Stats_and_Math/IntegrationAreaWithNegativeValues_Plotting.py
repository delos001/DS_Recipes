# MSPA 400 Session 8 Python Module #2

# Reading assignment:
# "Think Python" 2nd Edition Chapter 11 (11.1-11.8)
# "Think Python" 3rd Edition Chapter 11 (pages 121-132)

# Module #2 objectives:  1)  demonstrate how to handle negative areas with
# numerical integration, 2) plot results using Python fill_between, and 3)
# demonstrate the use of an inequality for plotting different colors.

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 
from numpy import *

# Function from Lial Section 15.4 Example 6

def f(x):
    f = x*x-2.0*x     #Students can supply a function at this point.
    return f
    
# Integrate is a general numerical integration function.  It requires
# an interval [a,b] and n = the number of subintervals used for integration.
# Integrate uses the function defined as f above.  For details refer
# to Lial Section 15.3.

def integrate(a,b,n):
    sum = 0.0
    delta = (b-a)/n
    i = 0
    while i < n:
        sum = sum + delta*(f(a+delta*(i+1))+f(a+delta*i))/2
        i = i+1
    return sum
        
#This defines the parameters for integration.

c = 2.0
b = 0.0
a = -1.0
n=100

# One area is negative and the other is positive.  We integrate them separately
# and combine their absolute values.

area1 = integrate(a,b,n)
area2 = integrate(b,c,n)
area =  abs(area1)+np.abs(area2)

print "Final Estimate of Area= %r" %area

# The next section of code shows how to plot different colors by
# dividing the interval based on which area is negative.

x = arange(-1.0,0.1,0.1)    # This defines the interval for the color red.
y = f(x)

# fill_between() requires an array for x and two functions for y between 
# which the color is filled.  In this case we use 0.0 for the x-axis and y.  
# alpha controls the intensity of the color.

fill_between(x,0,y,color='r',alpha=0.8)

x = arange(0.0,2.1,0.1)    # This defines the interval for the color blue.
y1 = f(x)

fill_between(x,0.0,y1,color='b',alpha=0.8)

# This section sets up the dimensions of the plot and creates it.  We have to 
# consider both plots and find the min and max of y for plot limits.

ymin = min(min(y),min(y1))
ymax = max(max(y),max(y1))
xlim(-1.0,4.5)
ylim(ymin-1.0,ymax+1.0)

xlabel('x-axis')
ylabel('y-axis')
title('Plot Showing Color Coded Integration Areas')
show()

# This section of code shows how to plot different colors using a
# logical operator in the plotting statement.  The operator will 
# control when each color is used.

figure()                # This separates the two plots from each other.
x = arange(-1.0,2.1,0.1)     # This defines the interval for color filling.
y = f(x)
plot(x,y,c='k')

# This shows how to fill between the lines using an inequality.

fill_between(x,0.0,y,where= y < 0.0, facecolor = 'y',interpolate=True)
fill_between(x,0.0,y,where= y > 0.0, facecolor = 'g', interpolate=True)

xlim(-1.0,2.5)
ylim(ymin-1.0,ymax+1.0)
xlabel('x-axis')
ylabel('y-axis')
title('Plot Showing Color Coded Integration Areas')
show()

# Assignment #1: Refer to Lial Section 15.4 Exercise 42.  Modify the code
# to reproduce the plot shown in the exercise.  Compare to the answer sheet.


