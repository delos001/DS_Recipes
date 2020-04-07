# MSPA 400 Session #2 Python Module #1

# Reading assignment "Think Python" either 2nd or 3rd edition:
#    2nd Edition Chapter 3 (3.4-3.9), Chapter 10 (10.1-10.12)
#    3rd Edition Chapter 3 (pages 24-29), Chapter 10 (pages 105-115) 

# Module #1 objectives: 1) reproduce examples from Lial using Python, 
# and 2) demonstrate how to plot a system of nonlinear equations with Python.

# Instructions---

# Execute this script as a single program. The results will appear below 
# or in separate windows showing the plots.  Matplotlib.pyplot and numpy are
# necessary software which must be imported.  They are used frequently.

import matplotlib.pyplot
from matplotlib.pyplot import *
import numpy 
import math
from numpy import linspace

x= linspace(0,45,100)
y1= 4/(x+5)
y2= 4*np.log(x+5)-4.6670

xlabel('x-axis')
ylabel('y-axis')
plot (x, y1, 'r')
plot (x, y2, 'b')
legend (('D`(x) 4/(x+5)','D(x) 4ln(x+5)-4.6670'),loc=2)
title ('Rate of Temperature Change and Total Temperature Change')
show()

