

#----------------------------------------------------------
# EXAMPLE 1
# oly1d is a function of numpy that can differentiate, 
# integrate and find roots of polynomials.
# All the examples below will use these imports
import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 
from numpy import poly1d, linspace



#----------------------------------------------------------
# EXAMPLE 2
# Generate and print a second degree polynomial given the specified coefficients (1, -3, 2)
# Result:
# Second Degree Polynomial
#      2
# 1 x - 3 x + 2
p=poly1d([1,-3,2])
print ('Second Degree Polynomial') 
print p



#----------------------------------------------------------
# EXAMPLE 3
# Generate and print a second degree polynomial given the specified coefficients (2,1,4,-2,3)
# Results:
# Fourth Degree Polynomial
#      4       3       2
# 2 x + 1 x + 4 x - 2 x + 3
q=poly1d([2,1,4,-2,3])
print ('\nFourth Degree Polynomial') 
print q



#----------------------------------------------------------
# EXAMPLE 4
# Result:
# Combination
#     6     5        4        3          2
# 2 x - 5 x + 5 x - 12 x + 18 x - 16 x + 8
print ('\nCombination')
g=p + p*q
print g


#----------------------------------------------------------
# EXAMPLE 5
# prints first derivative (m=1) (using p created in example above: p = x^2-3x+2)
# Result:
# First Derivative
# 2 x - 3
print ('\nFirst Derivative')
h= p.deriv(m=1) 
print h


#----------------------------------------------------------
# EXAMPLE 6
# prints second derivative (m=2) 
# (using p created in example above: p = x^2-3x+2)
# Result:
# Second Derivative
# 2
print ('\nSecond Derivative')
t= p.deriv(m=2) 
print t


#----------------------------------------------------------
# EXAMPLE 7
# the original function p can be restored after taking second 
# derivative (t from above) if the original coefficients are provided
# Result:
# Integrated Derivative
#     2
# 1 x - 3 x + 2
# [ 1. -3.  2.]
print ('\nIntegrated Derivative')
w=t.integ(m=2,k=[-3,2])
print w
print w.coeffs


#----------------------------------------------------------
# EXAMPLE 8
# This function finds the roots. (that is the equation was set 
# equal to zero and solved)  Useful when locating max, min, and 
# inflection ponts of first and second derivatives
# Result:
# Roots of polynomial
# [ 2.  1.]
print('\nRoots of polynomial')
print w.roots


#----------------------------------------------------------
# EXAMPLE 9
# Plotting requires defining a domain for the polynomial. 
# The linspace function is used to set boundaries and define the 
# number of points used for calculation. 

p=poly1d([.3333,0,-1,5])  # new polynomial p will be defined.
g=p.deriv(m=1)    # finds first derivative of p

print ('\nRoots of First Derivative')
print g.roots   # results: [ 1.00005 -1.00005]


print ('\nRoots of Second Derivative')
q=p.deriv(m=2)
print q.roots   # results: [ 0.]

# linspace function is used to set boundaries and define the number of 
# points used for calculation
x=linspace(-4,4,101)
y=p(x)      # define points for plotting original function
yg=g(x)     # define points for plotting g(x) which is first derivative
yq=q(x)     # define points for plotting q(x) which is second derivative
y0=0*x      # defines the y axis for plotting.

plot (x,y,label ='y=p(x)')
plot (x,yg,label ='First Derivative')
plot (x,yq,label ='Second Derivative')
legend(loc='best')

# python picks the colors to assign to each line
plot (x,y0)  # plots the xaxis
xlabel('x-axis')
ylabel('y-axis')
title ('Plot Showing Function, First and Second Derivatives')
show()




