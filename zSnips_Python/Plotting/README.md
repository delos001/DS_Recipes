
- http://matplotlib.org/gallery.html
---

## Needed to produce charts in numpy environment
```
import matplotlib.pyplot as plt
%matplotlib inline
```
## Options to change default size of plots in Jupyter Notebook:
```
pyplot.rcParams['figure.figsize'] = [10, 10]
pyplot.rcParams['figure.dpi'] = 100

pyplot.gcf().set_size_inches(10, 10) # don't change gcf
```
---

## Matplotlib convention

- convention 1: 
  - this will import the addon and the variables are set so you can plot it and show the plot
```
import matplotlib.pyplot as plt
```

- convention 2: 
  - this will import the addon and the variables are set so you can plot it and show the plot 
  but there is less writing with the last two lines because it is specified in line 2
```
import matplotlib.pyplot
from matplotlib.pyplot import plot, show
```

- convention 3: 
  - same as 2 above except the * all programs within matplotlib.pyplot are made available: 
  useful if long list of routines are being used
```
import matplotlib.pyplot
from matplotlib.pyplot import *
```

## Basic conventions

### Color
```
'b' blue
'g' green
'r' red
'c' cyan
'm' magenta
'y' yellow
'k' black
'w' white
```

### Plot features
```
title('Plot of Linear Equation '+equation)
xlabel ('x-axis')
ylabel ('y-axis')
xlim(-1,6)
ylim(0,8)
legend(('variable1', 'variable'),loc=2)
hlines(0,-2,6,color='r')
vlines(0,-2,6,color='r')
grid(True)
plot(x,y)
show()

figure() separates two plots so they aren't superimposed on one another
fill_between(x,y,z, color= 'b') fills between the lines
```
