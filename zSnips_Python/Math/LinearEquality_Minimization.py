


# ex: inequalities, minimization with unbound region 
# (solve objective function using matrix)

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 
from numpy import *

# x and y from 0 to 20 at interval 0.1
x= arange(0,20.1,0.1)
y0= arange(0,20.1,0.1)
y1= 10.0-3.0*x  # eq1: x+3y>=15
y2= 5.0-x/3.0   # eq2: 3x+y>=10
y3=20+0.0x      # eq3: -0x+y=20  allows filling unbound region in plot
y4=[0]*len(x)   # eq4: y4 defines max between y1 and y2: filling btwn y3 and max

for k in range(0,len(x)):
	if y1[k] >= y2[k]:
		y4[k]=y1[k]
	if y2[k] > y1[k]:
		y4[k]=y2[k]

# objective function: z=2x+3y  solve the matrix for y1, y2
y5= 5.5-2.0*x/3.0
xlim(0,20)
ylim(0,20)
xlabel('x-axis')
ylabel('y-axis')
title('Shaded Area Shows the Feasible Region')
plot(x,y2,color='b')  # with blue line
plot(x,y1,color='r')  # with red line
plot(x,y5,'k--')      # plots x vs the objective eq
print ('Note that the dashed line passes through the optimum point')

# order of entry label in legend must match order of statements to match colors
legend(['x+3y >= 15','3x+y >= 10', '16.5 = 2x+3y'], loc='best')

# fills between the x, y3, y4 using color grey
fill_between(x,y3,y4, color='grey',alpha=0.2)
show()

# corner points by solving system y1 and y2 and also x>=0, y>=0
x= [0, 1.5, 15]
y= [10, 4.5, 0]


# solving using matrix function 
obj= matrix([2.0,3.0])  # set matrix based on objective function variables for x and y
obj= transpose(obj)  # transpose the objective matrix
corners= matrix([x,y])  # set corners as matrix of x and y
corners= transpose(corners)  # transpose corners
result= dot(corners,obj)  # multiply corners matrix times obj matrix
print ('Value of Objective Function at Each Corner Point\n'), result
