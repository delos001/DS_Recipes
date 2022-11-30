import matplotlib.pyplot 
from matplotlib.pyplot import *
import numpy 

def f(x):
    f = (106*x)/(x**2+2)     
    return f

def integrate(a,b,n):
    sum = 0.0
    delta = (b-a)/n
    i = 0
    while i < n:
        sum = sum + delta*(f(a+delta*(i+1))+f(a+delta*i))/2.0
        i = i+1
    return sum

y = []
x = []
b = 20.0
a = 0.0
range = [10,20,30,40,50,100,250,500,1000,5000]

for n in range:
    area = integrate(a,b,n)
    x = x + [n]
    y = y + [area]

xlim(0,max(x)+60)
ylim(min(y)-0.5,max(y)+0.5)

plot(x,y)
scatter(x,y,s=30,c='r')
scatter(300,64.0,c='y')   
xlabel('Number of Subintervals')
ylabel('Estimated Area')
title('Plot Showing Numerical Integration Convergence')
show()

area=47+float(format(y[-1],'0.3f'))
print "Final Estimate of Area with %r subdivisions = %r" %(x[-1],area)


