# Math for Modelers Session #3 Module #1

# Reading assignment:  Investigate the Canopy Doc Manager.  Review the portion 
# dealing with Matplolib.  Review the gallery and the code used.

# Module #1 objectives: 1) plot inequalities with Matplotlib, and 
# 2) demonstrate how to show feasible regions.

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 
from numpy import*

x= arange(0,15.1,0.1)
y= arange(-3,15.1,0.1)
y1= -1.0*x+10.0
y2= -1.0*x+3.0
y3= 1.0*x-3.0
y4= (47/6.0)-(2.0/3.0)*x

xlim(0,15)
ylim(0,15)

xlabel('x-axis')
ylabel('y-axis')
title ('Shaded Area Shows the Feasible Region')

plot(x,y1,color='r')
plot(x,y2,color='b')
plot(x,y3,color='g')
plot(x,y4,'k--')
legend(['x+y=10','x+y=3','-x+y=-3','y=(47/6)-(2/3)x'], loc=2)

x= [3.0, 6.5, 10.0]
y= [0.0, 3.5, 0.0]
fill(x,y,color='0.85')
show()

obj= matrix([2.0,3.0])
obj= transpose(obj)
corners= matrix([x,y])
corners= transpose(corners)
result= dot(corners,obj)
print ('Value of Objective Function at Each Corner Point\n'), result
