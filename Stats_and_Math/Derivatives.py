# -*- coding: utf-8 -*-
# Math for Modelers Session #6 Python Module #2

# Reading assignment:
# "Think Python" 2nd Edition Chapter 7 (7.1-7.7)
# “Think Python” 3rd Edition Chapter 7 (pages 75-81)

# Module #2 objectives: 1) demonstrate numerical differentialtion,
# and 2) illustrate results graphically.

import numpy 
from numpy import arange, cos
import matplotlib.pyplot 
from matplotlib.pyplot import *

def g(x):
	g = (100.0*(1.0025)**(12*t)) 
	return g
n=5
powers=arange(0,n+1)
denominator=2.0**powers
delta=2.0



x_r=2.0+delta/denominator 
y_r=g(x_r)
x_l=2.0-delta/denominator 
y_l=g(x_l)

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

title ('Example of Convergence to a Functional Value')
xlabel('x-axis')
ylabel('y-axis')

def der(x,delta):
	delta = float(delta)
	if delta < (0.0000001):
		print ('Value chosen for delta is too small.')
		return 1/delta
	else:
		slope = (f(x + delta) - f(x))/delta
		return slope

delta=0.00001
def f(x):
	f= x**2
	return f
point = 2.0
limit=der(point,0.000001)
w=arange(point-1.0,point+1.0,0.1)
t=f(point)+limit*(w-point)
plot(w,t,color='g')
print round(der(2,delta),4)
 
show()



