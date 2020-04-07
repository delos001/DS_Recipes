# -*- coding: utf-8 -*-
# MSPA 400 Session #5 Python Module #2

# Reading assignment:
# “Think Python” 2nd Edition Chapter 6 (6.1-6.9)
# “Think Python” 3rd Edition Chapter 6 (pages 61-71)

# Module #1 objectives: 1) introduce binomial probabilities,
# 2) demonstrate the calculation of binomial probabilities, and 3) display
# binomial distributions. (Functions used in Module #1 will be required.)
 

import numpy
import matplotlib.pyplot 
from matplotlib.pyplot import *

# The following three functions were used in Module #1. 

def factorial(n):
    if n == 0:
        return 1
    else:
        recurse = factorial(n-1)
        result = n*recurse
        return result
                 
def perm(n,k):
    if n == 0: 
        return 1
    if k > n:
        return -1
    else:
        result=1
        for i in range (0,n-k):
            result=result*(n-i)
        return result                            
             
def comb(n,k):
    result=perm(n,k)
    result=(float(result))/factorial(n-k)
    result=int(result)
    return result

# An example of code for calculating a binomial probability follows
# Section 5.11 of "Think Python" presents keyboard input.
# Keyboard input will be used for a binomial calculation.

# In the code which follows, note the type conversions from string to 
# integer, integer to floating point and back.

print 'In each instance, hit enter after submitting the requested number.'
print 'Enter a positive integer for the number of repeated trials.'

n=raw_input()
n=int(n)        # This converts n from a string to an integer.

print ('Enter the number of successes.') 
k=raw_input()
k=int(k)

print ('Enter the probability of success.')
p=raw_input()
p=float(p)      # This converts p from a string to a floating point number.

prob=(comb(n,k))*(p**k)*((1.0-p)**(n-k))
print 'Binomial probability with n= %r, k= %r, p= %r is %r\n' %(n,k,p,prob)

# The following example shows how to calculate a binomial distribution
# and print the result.  First a binomial function will be defined.  The
# values previously entered for the number of repeated trials, the 
# number of successes and the probability of success will be used.

def binomial(n,k,p):
    prob=(comb(n,k))*(p**k)*((1.0-p)**(n-k))
    return prob

print 'Binomial distribution with %r trials and p= %r follows.\n' %(n,p)
distribution=[]
for i in range (0,n+1):
    prob=binomial(n,i,p)
    print '# of successes= %r probability= %1.4f ' %(i,prob)
    distribution=distribution+[prob]

x=range(0,n+1,1)    # x and y are both lists with the same number of elements.
y=distribution

# The plot is produced in layers.  bar() places the red bars of width 0.4
# centered on x values. The heigth is determined by y.  The plot()
# statement places the line plot on the chart.  With only one show()
# statement, the figure() statement is unnecessary.

bar(x,y,width=0.4, align='center',color='r')
plot(x,y)
xlabel('Total Number of Trials')
ylabel('Probability of Success')
title('Binomial Probabilities ') 
show()

# Exercise #1: Using a variation of the code and functions defined, 
# check the calculations in Lial Section 8.4 Examples 2 and 3. 
# Note the distributions which are produced.

# Exercise #2: Using the function "binomial" as defined in the code, write 
# the code to verify the calculatons in Lial Section 8.5 Example 7. 

