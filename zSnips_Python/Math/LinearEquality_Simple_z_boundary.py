

# ex: simple linear inequality with z boundary

import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 
from numpy import arange

x= arange(-2,6.1,0.1)  # arrange sets the range and intervals
y= -1.0 + x/4.0

xlim(-1,6)  # sets the plot limits


# data points are plotted using variable z to define the 
# boundary for the filled area.  z is a list with same 
# dimension as x and y
plot(x,y)
z= -2.0 + 0.0*x
plot(x,z)

# tells what region to fill (between the two lines)
fill_between(x,y,z, color= 'b')
show()
