
# present numerical integration (using trapezoid), demonstrate 
# convergence (shows how area gets more accurate as n intervals 
# increases), plot results (of the areas across different range of n)

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy

# define the function you need to work with
def f(x): 
	f = x*x*x
	return f


# "integrate" is a general numercial integration function that 
# will use the function defined above integrate requires an interval 
# [a,b] and number of subintervals 'n'
# delta will divide interval [a,b] by n subintervals

    # using trapezoid, this gives you the area of each rectangle 
    # in the function above for n subintervals. (divides left 
    # point + right point by 2)makes the next loop use previous i 
    # value plus 1
def integrate(a,b,n):
	sum = 0.0
	delta = (b-a)/n
	i = 0
	while i < n:   # for each i, starting at 0 and going to n
		sum = sum + delta*(f(a+delta*(i+1))+f(a+delta*i))/2.0
		i = i+1
	return sum  # returns total sum of all the trapezoids

# creates a blank list for the x and y values that will be calculated
# sets the upper interval, b as 4.0  (b is the upper limit for the 
# area you are trying to calcuate)
# sets the lower interval, a as 0.0 (a is the lower limit for the area 
# you are trying to calcuate) so this example calcuates area from 0 to 4
# defines the range that will be looped where the points will be found 
# (the higher the number, the more points, the more accurate the answer)
y = []
x = []
b = 4.0
a = 0.0
range = [10,20,30,40,50,100,250]


# for each value n, in the range specified above
# sets the area as the results of the integrate function defined above
# sets x to x plus the value in the range such that x becomes the same as the range
# sets y to the area for each value in the range.  
# area is calculated by running the integrate function above
for n in range:
	area = integrate(a,b,n)
	x = x + [n]
	y = y + [area]

# sets the limits for the x axis in which the min is 0 and the max is the 
# max value of x (created above) plus 60
# sets the limits for the y axis in which the min is the min value of y minus 
# 0.5 and the max is the max value of y plus 0.5 (and y is the area calculated above)
xlim(0,max(x)+60)
ylim(min(y)-0.5,max(y)+0.5)

plot(x,y)
scatter(x,y,s=30,c='r')
# plots scatter plot at x=300, y=64.0 as yellow. limiting value for the area
scatter(300,64.0,c='y')

xlabel('Number of Subintervals')
ylabel('Estimated Area')
title('Plot Showing Numerical Integration Convergence')
show()

# takes the y value farthest to the right and formats with 3 decimals
# prints the results indicating how many subdivisions and what the area outcome 
# is (getting last x value in the list)
area=float(format(y[-1],'0.3f'))
print "Final Estimate of Area with %r subdivisions = %r" %(x[-1],area)
