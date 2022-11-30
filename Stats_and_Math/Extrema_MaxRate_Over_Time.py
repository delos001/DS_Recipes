# MSPA 400 Session 7 Python Module #2.

# Reading assignment:
# "Think Python" 2nd Edition Chapter 8 (8.3-8.11)
# "Think Python" 3td Editon (pages 85-93)

# Module #2 objective:  demonstrate some of the unique capabilities of numpy 
# and scipy.  (Using the poly1d software from numpy, it is possible to 
# differentiate, # integrate, and find the roots of polynomials.  Plotting the
# results illustrates the connection between the different functions.)

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 
from numpy import poly1d, linspace

q=poly1d([1.603,-23.258,62.12,6.992,1010])
print ('\nFourth Degree Polynomial') 
print q

print ('\nFirst Derivative')
h= q.deriv(m=1)  # First derivative with m=1.
print h

print ('\nRoots of First Derivative')
print h.roots

print ('\nSecond Derivative')
t= q.deriv(m=2)  # Second derivative with m=2.
print t

print ('\nRoots of Second Derivative')
print t.roots

x=linspace(-0,7.1,101)
yq=q(x)
yg=h(x) 

y0=0*x 

plot (x,yq,label ='y=p(x)')
plot (x,yg,label ='First Derivative')
legend(loc='best')

plot (x,y0)
xlabel('x-axis')
ylabel('y-axis')
title ('Plot Showing Function and First Derivatives')
show()