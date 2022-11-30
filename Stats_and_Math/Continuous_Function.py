# -*- coding: utf-8 -*-
import numpy 
from numpy import sin, arange
import matplotlib.pyplot 
from matplotlib.pyplot import *

def g(x):
    g = (50+2.85*x+0.6519*x**2+0.00804*x**3) 
    return g

n=100  
powers=arange(0,n+1)
denominator=2.0**powers  
delta=28.0           

x_l=28-delta/denominator  
y_l=g(x_l)

ymax=800
ymin=900

figure()
xlim(0,56)
ylim(ymin,ymax)

plot(x_l,y_l,label ='interval (0,26]',color='r')

scatter(x_l,y_l,color='k',s=30)
scatter(28,g(28.0),c='y',s=40)

def g(x):
    g = (-1097 + 68.9*x)
    return g

n=100 

powers=arange(0,n+1)
denominator=2.0**powers  
delta=28.0           

x_r=28+delta/denominator   
y_r=g(x_r)

ymaxr=900
yminr=800

xlim(0,56)
ylim(yminr,ymaxr)

plot(x_r,y_r,label ='interval (26,56]',color='g')

scatter(x_r,y_r,color='r',s=30)
scatter(28,g(28.0),c='b',s=40)

legend(loc='best')
title ('Zoom into x=26 for Convergence to 26')
xlabel('x-axis')
ylabel('y-axis')
show()




