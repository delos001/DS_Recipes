# Math for Modelers Session #3 Module #1

# Reading assignment:  Investigate the Canopy Doc Manager.  Review the portion 
# dealing with Matplolib.  Review the gallery and the code used.

# Module #1 objectives: 1) plot inequalities with Matplotlib, and 
# 2) demonstrate how to show feasible regions.

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 
from numpy import*

x= arange(0,5.1,0.1)
z= arange(0,5.1,0.1)
y0= arange(0,12.1,0.1)
y1= 11.0-1.0*x
z1= 2.0*x
x1= 3.0+0.0*y0

xlim(0,5)
ylim(0,12)

xlabel('x-axis')
ylabel('y-axis')
title ('Shaded Area Shows the Feasible Region')

plot(x,y1,color='r')
plot(x,z1,color='b')
plot(x1,y0,'g')

legend(['x+y=10','x+3=3','-x+y=-3','y=(47/6)-(2/3)x'], loc=2)

x= [0, 0.0,  3.0, 3.0]
y= [0, 11.0, 0.0, 2.0]
fill(x,y,color='0.85')
fill(x,z,color='0.5')
show()

obj= matrix([2.0,4.0])
obj= transpose(obj)
corners= matrix([x,y])
corners= transpose(corners)
result= dot(corners,obj)
print ('Value of Objective Function at Each Corner Point\n'), result
