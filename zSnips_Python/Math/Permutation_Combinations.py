
#----------------------------------------------------------
# RECURSIVE FUNCTION

import numpy
import matplotlib.pyplot 
from matplotlib.pyplot import *


# This code provides the factorial of a number
# the factorial of 0 is 1 so this gets the 0 out of the way
def factorial(n):
	if n == 0:
		return 1
	else:
    # computes factors for each value of n until n == 0 
    # (loops down in n-1 steps)
		recurse = factorial(n-1)
		result = n*recurse
		return result

# Sets permutation parameters to calculate permutation
def perm(n,k):
	if n == 0:   # gets the 0 out of the way since that solution is 
		return 1   
	if k > n:    # if the k is greater than n, then the answer is -1
		return -1
	else:
    # calculates actual permutation for each factorial of n (see above)
		result=(factorial(n))/factorial(n-k)
		return result

# sets combination parameters to calculation the combination
def comb(n,k):
	result=perm(n,k)   # calculation the combination
  # calculates the cobmination using the result of the permutation 
  # above since combination is same as permutation except there is 
  # an extra factorial of k in the denominator
	result=(result)/factorial(k)
	result=int(result)
	return result
	
	
	
permutation = perm(10,5)  # calculates the permutation of the input values of 10,5
print "Permutation of 10 elements taken 5 at a time = %r\n" %permutation 
combination = comb(10,5)  # calculates the combination of the input values of 10,5
print "Combination of 10 elements taken 5 at a time = %r\n" %combination


#----------------------------------------------------------
# PERFORMS SAME AS ABOVE WITHOUT NEED TO CREATE RECURSIVE
def fact(n):
if n == 0:
	return 1
else:
	result=1
	for k in range(0,n):
		result = result*(k+1)
return result

#----------------------------------------------------------
# FACTORIAL

# gives instructions for the user to enter the factorial value
print ('Enter a positive integer to obtain the factorial value.')
print ('Enter a negative integer to stop.') 
print ('In either case, hit enter or the code will not work.')

n= raw_input()  # raw_input() makes the code accept keyboard input
n= int(n)

# if the keyborad input is greater than 0, it will produce the 
# factorial result using the result from above
if n > 0:
	result=factorial(n)
	print 'Factorial of %r is equal to %r\n' %(n,result)
	# if the input is less than zero, it produces a statement that 
	# says no calculation
	else:
		print ('No calculation.\n')
