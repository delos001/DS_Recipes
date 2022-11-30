
#----------------------------------------------------------
# EXAMPLE 1
# calculate instantaneous velocity at specified points
import numpy 
from numpy import arange, cos
import matplotlib.pyplot 
from matplotlib.pyplot import *

# defines the derivative
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
	f= 2.0*x**2-5*x+40.0
	return f

# produces the instantaneous velocity at x=4 based on the 
# derivative function above
print round(der(4,delta),4)
def f(x):
	f=100.0+15.0*x-x**2
	return f
  
# produces instantaneous velocity at x=1 and x=5
# based on derivative calculation above
print round(der(1,delta),4)
print round(der(5,delta),4)



#----------------------------------------------------------
# EXAMPLE 2
# produce numerical differentiation

import numpy 
from numpy import arange, cos
import matplotlib.pyplot 
from matplotlib.pyplot import *

# general formula to calculate the slope between 2 points
# instantaneous rate of change
def der(x,delta):
	delta = float(delta)
	if delta < (0.0000001):
		print ('Value chosen for delta is too small.')
		return 1/delta
	else:
		slope = (f(x + delta) - f(x))/delta
		return slope
		
def f(x):
	f = cos(x)  # change this function to whatever function you need
	return f

# this is the point where the derivative will be calculated
point = 1.0

# These initialize variables for computation: increases by units 
# of 10 to 500 (number excludes last number so its 510-10)
number = 510
increment =10

# creates blank list for calculated x and y values
y = []
x = []

# range includes first number and excludes last.  here we are 
# increasing by units of 10 from 1 to 500
for k in range(increment, number, increment):
	# delta is being reduced to get smaller distances between 
	# x=1.0 and x=1.0+delta
	delta = 1.0/(k+1)
	# the slopes are being calculated and stored in y[]
	d = der(point,delta)  # der is defined from above
	x = x + [k]
	y = y + [d]
	max_x = k + increment

limit=der(point,0.000001) 
print "Final value equals %2.3f " %limit

figure()  # starts new figure
xlim(0, max_x+50 )
ylim(min(y)-0.05, max(y)+0.05)  # y lim based on min and max y value

scatter(540,limit,color='g',s=40,label='limiting slope')
legend(['limiting slope'],'best')
scatter(x,y,c='k',s=20)

title ('Example of Convergence to Instanteous Rate of Change')
xlabel('x-axis')
ylabel('y-axis')
ylabel('y-axis')
plot(x,y)
show()

# How to show the tangent line at point x=1.0 (uses equation of 
# straight line y=mx+b and slope is y[-1] from above
w=arange(point-1.0,point+1.1,0.1)  # defines distance to which the tangent line will be plotted 
t=f(point)+limit*(w-point)  # calculates the values for tangent

domain=3.14  # this will plot the function over a wider range
u=arange(point-domain,point+domain+0.1,0.1)
z=f(u)

# allows plot in layers showing the tangent and function
# set xlim by adding and subtracting the domain minus the point 
# (x=1.0) and giving 0.1 for extra room
# set ylim by adding and subtracking 0.5 from the min and max values 
# calculated in z
figure()
xlim(point-domain-.1,point+domain+0.1)
ylim(min(z)-.5,max(z)+.5)
scatter(point,f(point),c='g',s=40) 
xlabel('x-axis')
ylabel('y-axis')
title('Plot showing function and tangent at a point')
show()

