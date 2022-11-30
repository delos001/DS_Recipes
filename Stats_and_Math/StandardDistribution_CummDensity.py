# MSPA 400 Session #9 Python Module #2

# Reading Assignment 
# "Think Python" Chapter 13 (13.1-13.8)
# "Think Python" 3rd Edition Chapter 12 (pages 135-144)

# Module #2 objectives:  1) use numerical integration to demonstrate the
# connection between the normal density function and the cumulative distribution
# function or cdf, and 2) use the program to verify calculations shown in Lial.

# This particular module takes a few seconds to load.  Be patient. Using the
# NumPy math library does speed things up somewhat.  When the prompt asks for a
# value, enter it and a plot will appear.

# The program will ask for a user supplied value to be entered at the prompt.
# The integration will use the standard normal density function to find the
# probability that a standard normal random variable will be <= the value
# specified by the user  A plot will show the area integrated, the user
# supplied value and the area under the curve.

import numpy 
from numpy import linspace, math
import matplotlib.pyplot 
from matplotlib.pyplot import *

# This is the density function for a standard normal distribution.

def f(x):
    f = (math.exp(-x*x/2))/math.sqrt(2.0*math.pi)    
    return f

# The following values determine the total interval considered and also
# the increment used for numerical integration.  We are dividing 12 standard
# deviations into 1200 subintervals thus defining delta. 

xa = -6.0
xb = 6.0
n = 1200
delta = float((xb - xa)/n)

def integrate(a,b,delta):    #Simpson's rule is used to integrate over [a,b].
    sum = 0.0
    i = 0
    n = int(float((b-a)/delta))
    if b == a:
        return
    else:
        while i < n:
            x0 = a+delta*i
            x1 = x0+delta/2
            x2 = x0+delta
            sum = sum + delta*(f(x0)+4.0*f(x1)+f(x2))/6
            i = i+1
        return sum
   
x = linspace (xa,xb,n)
y = []
cdf = []

for z in x:
    y = y + [f(z)]
    cdf = cdf + [integrate(xa,z,delta)]
      
print "Value of the variable x for integration=?" ,
value = float(raw_input())   

fvalue =integrate(-6,value,delta)
fvalue=round(fvalue,4)
print ('Area with x= %r equals %r ') %(value,fvalue)

xlim(xa-1,xb+1)
ylim(0,1)

string = ' with x = '+str(value) + ' and area = '+str(fvalue)
title ('Normal Density and CDF'+string)
xlabel('x-axis')

plot(x,y,'b')  
plot(x,cdf,'r')
legend(('Density','CDF'),loc='upper left')

fill_between(x,y,where=(x <= value),color='grey', alpha='0.3')
scatter(value,fvalue,s=30,c='r',marker='o')
show()

# Exercise #1:  Refer to Lial Chapter 18 Section 18.3.  Using this code, 
# reproduce the results shown in Example 3(c).

# Exercise #2: Refer to Lial Chapter 18 Section 18.3.  Using this code,
# reproduce the results in Example 4 part(a).


