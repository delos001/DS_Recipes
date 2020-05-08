

# ex: four inequalities

figure()
# # sets x and y range -3 to 10.1, at 0.1 interval
x= arange(-3,10.1,0.1)  
y= arange(-3,10.1,0.1)
y1= 0.4*x-2.0   # from inequality 2x-5y<=10
y2= 4.0-0.5*x   # from inequality x+2y<=8

xlim(-3,10)   # sets x limit ie: -3<x<10
ylim(-3,10)   # sets y lim
hlines(0,-3,10,color='k')  # sets horizontal grid lines
vlines(0,-3,10,color='k')  # sets vertical grid lines
grid(True)

xlabel('x-axis')
ylabel('y-axis')
title ('Shaded Area Shows the Feasible Region')

plot(x,y1,color='b', label='2x-5y=10')
plot(x,y2,color='r', label='x+2y=8')
legend(['2x-5y=10','x+2y=8'])


# The simplest approach for filling a polygon is to locate the
# corner points. Matplotlib will fill within these points.
x= [0.0, 0.0, 6.0, 0.0, 12.0, 8.0 ]
y= [0.0, 12.0, 0.0, 6.0, 0.0, 4.0

# OR an alternative for simpler problems without corner points
fill_between(x,y2,where=(y2<=y1), color= 'b')
fill_between(x,y1,where=(y1<=y2), color= 'b')

fill(x,y)
show()
