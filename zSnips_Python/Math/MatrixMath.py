
#----------------------------------------------------------
# EXAMPLE 1
# array matrix operations adding, subtracting, multiplying
import numpy 
from numpy import array, absolute

print ('\nExample 1 Section 2.3 Lial showing array addition page 72.')

m= array([[10,12,5],[15, 20, 8]])
n= array([[45, 35, 20],[65, 40, 35]])
q= m + n

print ('\nArrays in order: m , n and m+n')
print m 
print ('\n%s') %n  # starts new line and prints n as string
print ('\n%s') %q  # starts new line and prints q which is n+n

print ('\nSubtraction of n from m equals q')
q= m - n
print q

s= 2.0
print ('\nMultiplication of q by a scalar %r') %s
q= s*q
print q

print ('\nFunctions can be applied to an array such as absolute value')
q= absolute(q)  # returns the absolute value matrix q
print q



#----------------------------------------------------------
# EXAMPLE 2
# ex2: setting a matrix

import numpy as np
import numpy.linalg as npla


a=[[1.0,1.5,1.5],[18.0,20.0,21.0],[2.0,1.5,2.0]]
a=np.matrix(a)
print ('a = %r') %a
b=[750,11000,1000]
b=np.matrix(b)
b=np.transpose(b)
print ('b = %r') %b
ia=np.linalg.inv(a)
print ('ia = %r') %ia
i=np.dot(ia,a)
solution=np.dot(ia,b)
print ('solution = %r') %solution



#----------------------------------------------------------
# EXAMPLE 3

import numpy 
from numpy import *
from numpy.linalg import *  # easier to solve matrix

# ex1: solving equation using inverse
rhs= [96, 87, 74]
rhs=matrix(rhs)
rhs=transpose(rhs)  # transposes rhs
print ('\nRight Hand Side of Equation')
print rhs


A =[[1, 3, 4], [2, 1, 3], [4, 2, 1]]
A= matrix(A)
print ('\nMatrix A')
print A


print ('\nInverse of A')
IA= inv(A)    # sets IA as the inverse of matrix A (above)
print IA


print ('\nIdentity Matrix')  # setting identify matrix
I= dot(IA,A)   # matrix multiplication (IA * A)
I= int_(I)     # Converts floating point to integer
print I


result = dot(IA,rhs)  # solves by multiply Inverse matrix times matrix A
result = int_(result) # Converts floating point to integer
print ('\nSolution to Problem')
print result


# more efficient way to solve
print ('\nIllustration of solution with linalg.solve(,) function')
result2= linalg.solve(A,rhs)  # sets result2 to solution so matrix A and rhs
print int_(result2) # This converts floating point to integer.



#----------------------------------------------------------
# EXAMPLE 4
import numpy 
from numpy import *
from numpy.linalg import *

a=([6,5},[2,1])  # sets a as matrix
a=array(a)
b=[245,68]       # sets b as matrix
b=array(b)
x=numpy.linalg.solve(a,b)  # solves the matrix
print x


#----------------------------------------------------------
# EXAMPLE 5
# ex2: inverse matrix for inconsistent equation

print ('\nExample of an inverse matrix for inconsistent equations')
A= [[1,2,3],[-3,-2,-1], [-1,0,1]]  # matrix
A= array(A)     # A as an array
IA= inv(A)      # inverse of array A
print IA


#----------------------------------------------------------
# EXAMPLE 6
# ex3: matrix example
# solve for 'y' when you set these up

3x+10y=115
11x+4y=95

x = linspace (-1,15,100)  # plot these lines in a graph from -1 to 15 in 100 

y1=115.0/10.0 - (3.0/10.0)*x  # solved for 'y1' (the first y) as indicated above
y2=95.0/4.0 - (11.0/4)*x      # solved for 'y2' (the second y) as indicated above

figure() # prevents previous plots from being on this
xlabel('x-axis')
ylabel('y-axis')
plot (x, y1, 'r')  # red line
plot (x, y2, 'b')  # blue line
legend (('3x+10y=115','11x+4y=95'),loc=3)  # puts the equation in the legend
title ('Solving a System of Equations with a Unique Solution')
show()


#----------------------------------------------------------
# EXAMPLE 7
# ex4: plot a curve after solving a matrix

figure()  # figure stops image from being overlayed on previous graph

x=linspace(0,100,100)

y1=(0.064*x**2)+(0.84*x)  # y1 is the exponential equation
y55=(0.064*55**2)+(0.84*55)  # y55 is the result when x is 55

xlabel('x-axis')
ylabel('y-axis')

# c='y' tell what color to make the circle, s tells what size to make it
scatter(55,y55,c='y',s=100)
plot(x,y1)
show()
