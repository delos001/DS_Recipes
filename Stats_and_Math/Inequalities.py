# MSPA 400 Session #3 Python Module #2

# Reading assignment:  Investigate the Canopy Doc Manager.  Review the portion 
# dealing with Matplolib.  Review the gallery and the code used.

# Module #2 objectivse: 1) plot inequalities, 2) show feasible
# regions, and 3) solve a linear programming problem.

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy
from numpy import *

x=arange(0,100.1,0.1)
y0=arange(0,40.1,0.1)
y1= 20.0-(x/5.0)
y2= (55.0/2.0)-0.5*x
y3= (100.0/3)-(2.0/3.0)*x




xlim(0.0,100)
ylim(0.0,40)

# Plot axes need to be labled,title specified and legend shown.

xlabel('x-axis')
ylabel('y-axis')
title('Shaded Area Shows the Feasible Region')

plot(x,y2,'b')
plot(x,y1,'r')
plot(x,y3,'y')



x= [0, 25, 35, 50]
y= [20, 15, 10, 0]
fill(x,y, color='grey', alpha=0.2)
show()

obj= matrix([40,85])
obj= transpose(obj)
corners= matrix([x,y])
corners= transpose(corners)
result= dot(corners,obj)
print ('Value of Objective Function at Each Corner Point:\n'), result



