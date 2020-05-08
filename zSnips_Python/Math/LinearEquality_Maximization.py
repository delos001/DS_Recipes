
# ex: five inequalities maximization

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy
from numpy import *

# x and y from 0 to 4.0, at 0.1 interval
x=arange(0,4.1,0.1)
y0=arange(0,4.1,0.1)

y1= 4.0-2.0*x  # eq1: 2x+y=4
y2= 2.0+x/2.0  # eq2: -x+2y<=4
y= 3-.75*x     # obj function: z=3x+4y: solve matrix for z
x1= 1.5+0.0*y0 # eq3: x<=1.5  note: written like this so x1 has same # of elements
xlim(0,4)      # equates to eq4: x>=0
ylim(0,4)      # equates to eq5: y>=0

xlabel('x-axis')
ylabel('y-axis')
title('Shaded Area Shows the Feasible Region')

plot(x,y2,'b')  # with blue line
plot(x,y1,'r')  # with red line
plot(x1,y0,'g') # with green line

print ('The dashed black line represents the objective function.')
plot(x,y,'k--')  # plots x vs y using color k and make it a dotted line

legend(['-x+2y <= 4','2x+y <= 4', 'x=1.5','12 = 3x+4y'], loc= 'best')

x= [0, 0, .8, 1.5, 1.5]
y= [0, 2.0, 2.4, 1.0, 0]
fill(x,y, color='grey', alpha=0.2)
show()

# creates matrix with the x and y values of the objective function
obj= matrix([3.0,4.0])
obj= transpose(obj)   # transposes the objective function
corners= matrix([x,y])  # sets corners
corners= transpose(corners)  # transposes corners
result= dot(corners,obj)  # multiplies corners times the transposes obj matrix

# prints specified text and then the results
print ('Value of Objective Function at Each Corner Point:\n'), result
# out:
# [[  0. ]
#  [  8. ]
#  [ 12. ]
#  [  8.5]
#  [  4.5]]
