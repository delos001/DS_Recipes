


#----------------------------------------------------------
# EXAMPLE 1: plot two lines (basic)
x=[1,2,3,4]
y=[2,3,4,5]

title('Example Plot')
xlabel('x-axis')
ylabel('y-axis')
ylim(0,8)
xlim(0,7)
plot(x,y)
show()



#----------------------------------------------------------
# EXAMPLE 2: plot two lines
x=linspace(0,50,100)
y=20*x+100.0
z=24*x
figure()
plot(x,y)
plot(x,z)
legend(('cost', 'revenue'),loc=2)
title ('Break Even Analysis')
show()
