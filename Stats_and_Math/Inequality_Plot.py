import matplotlib.pyplot
from matplotlib.pyplot import * 
import numpy 
from numpy import linspace

x=[9,2,3,4,2,5,9,10]
y=[85,52,55,68,67,86,83,73]

title('Scatter Plot Advertising vs. Sales ')
xlabel ('Cost (thousands of dollars)')
ylabel ('Widget Sales')

xlabel('Cost (thousands of dollars)')
ylabel('Widget Sales')
scatter(x,y)

x=linspace(0,15,15)
xlim(0,15)
ylim(0,100)
y1=(2.78*x+55.78)
legend(['y=2.78*x+55.78'])
plot(x,y1)
show()