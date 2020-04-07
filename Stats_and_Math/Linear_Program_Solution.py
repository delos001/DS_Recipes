# MSPA 400 Session #3 Python Module #3

# Reading assignment:  Investigate the Canopy Doc Manager.  Review the portion 
# dealing with Matplolib.  Review the gallery and the code used.

# Module #3 objectives: 1) plot inequalities, 2) show feasible regions, and 
# 3) solve a linear programming problem.

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 
from numpy import *

x= arange(0,30.1,0.1)
y= arange(0,30.1,0.1)
y1= 4x-16
y2= 11-2x


xlim(0,30)
ylim(0,30)

xlabel('x-axis')
ylabel('y-axis')
title('Shaded Area Shows the Feasible Region')

plot(x,y1,color='r')
plot(x,y2,color='g')


legend(['4x-y<=16','2x+y>=11'], loc='best')

x= [23.4, 25, 18.75, 16.7]
y= [0, 0, 6.25, 5.6]
fill(x,y, color='grey', alpha=0.2)
show()

x= [23.4, 25, 18.75, 16.7]
y= [0, 0, 6.25, 5.6]

obj= matrix([4800.0, 0.0])
obj= transpose(obj)
corners= matrix([x,y])
corners= transpose(corners)
result= dot(corners,obj)
print ('Value of Objective Function at Each Corner Point:\n'), result