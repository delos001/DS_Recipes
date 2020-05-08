

#----------------------------------------------------------
# EXAMPLE 1
# binomial probability with user input

import numpy
import matplotlib.pyplot 
from matplotlib.pyplot import *

# The following three functions were used in Permutation 
# and Combinations section
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

# gives user instructions
print 'In each instance, hit enter after submitting the requested number.'
print 'Enter a positive integer for the number of repeated trials.'

n=raw_input()  # sets n as keyboard acceptable value
n=int(n)       # converts n from a string to an integer

# gives user instructions
print ('Enter the number of successes.') 
k=raw_input()    # sets k as keyboard acceptable value
k=int(k)         # converts k from string to an integer

# gives user instructions
print ('Enter the probability of success.')
p=raw_input()    # sets p as keyboard acceptable value
p=float(p)       # converts p from string to an integer

# calculates binomial probability
prob=(comb(n,k)) * (p**k) * ((1.0-p)**(n-k))
# prints the probability
print 'Binomial probability with n = %r, k = %r, p= %r is %r\n' %(n,k,p,prob)
# ex result:
# Binomial probability with n= 10, k= 2, p= 0.3 is 0.23347444049999988




#----------------------------------------------------------
# EXAMPLE 2
# binomial probability distribution
import numpy
import matplotlib.pyplot 
from matplotlib.pyplot import *

def binomial(n,k,p):    # defines # of repeated trials, successes, & prob
	# defines prob as the given formula using values from above
	prob=(comb(n,k))*(p**k)*((1.0-p)**(n-k))
	return prob   # produces calculation prob


print 'Binomial distribution with %r trials and p= %r follows.\n' %(n,p)
# sets distribution as a set
distribution=[]
# start loop using 'i' to represent values of k
for i in range (0,n+1):
	prob=binomial(n,i,p)   # defines prob as binomial from above using i
	print '# of successes= %r probability= %1.4f ' %(i,prob)

# results:
# of successes= 0 probability= 0.0282 
# of successes= 1 probability= 0.1211 
# of successes= 2 probability= 0.2335 
# of successes= 3 probability= 0.2668 
# of successes= 4 probability= 0.2001 
# of successes= 5 probability= 0.1029 
# of successes= 6 probability= 0.0368 
# of successes= 7 probability= 0.0090 
# of successes= 8 probability= 0.0014 
# of successes= 9 probability= 0.0001 
# of successes= 10 probability= 0.0000 


# defines distribution for a plot
distribution=distribution+[prob]

# x and y are both lists with the same number of elements.
x = range(0,n+1,1) 
y = distribution
# The plot is produced in layers. bar() places the red 
# bars of width 0.4 centered on x values. 
# The heigth is determined by y. 
bar(x, y, 
    width = 0.4, align = 'center', color = 'r')

# The plot() statement places the line plot on the chart. 
plot(x,y)
xlabel('Total Number of Trials')
ylabel('Probability of Success')
title('Binomial Probabilities ') 
show()
