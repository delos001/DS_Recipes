# MSPA 400 Session 8 Python Module #1

# Reading assignment:
# "Think Python" 2nd Edition Chapter 11 (11.1-11.8)
# "Think Python" 3rd Edition Chapter 11 (pages 121-132)

# Module #1 objectives:  1) present numerical integration, 2) demonstrate 
# convergence to limiting areas, and 3) plot results.  

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 


# An example function:

def f(x):
    f = x*x*x     #Students can supply their functions at this point.
    return f
    
# integrate() is a general numerical integration function.  It requires
# an interval [a,b] and n = the number of subintervals used for integration.
# Integrate uses a function defined as f above.  For details refer
# to Lial Section 15.3.

def integrate(a,b,n):
    sum = 0.0
    delta = (b-a)/n
    i = 0
    while i < n:
        sum = sum + delta*(f(a+delta*(i+1))+f(a+delta*i))/2.0
        i = i+1
    return sum
        
#This shows list manipulations resulting in a plot
y = []
x = []
b = 4.0
a = 0.0
range = [10,20,30,40,50,100,250]

# We are going to integrate the function at specified points in range[].  The
# values in range[] will subdivide the interval [a,b] into finer subdivisions
# thus improving upon the numerical approximation of the limiting area.  The 
# variables x and y are lists and the following for loop concantenates new
# elements to both x and y for plotting purposes.

for n in range:
    area = integrate(a,b,n)
    x = x + [n]
    y = y + [area]

xlim(0,max(x)+60)
ylim(min(y)-0.5,max(y)+0.5)

plot(x,y)
scatter(x,y,s=30,c='r')
scatter(300,64.0,c='y')   # This plots the limiting value for the area.

xlabel('Number of Subintervals')
ylabel('Estimated Area')
title('Plot Showing Numerical Integration Convergence')
show()

area=float(format(y[-1],'0.3f'))
print "Final Estimate of Area with %r subdivisions = %r" %(x[-1],area)


# Exercise: Instead of using the trapazoidal rule for integration, substitute 
# the midpoint rule in the function integrate() and run the rest of the code 
# without modification.  Note the difference in how convergence occurs.  
# Compare to the answer sheet.

