# -*- coding: utf-8 -*-
# Math for Modelers Session #5 Python Module #1

# Reading assignment:
# “Think Python” 2nd Edition and Chapter 6 (6.1-6.9)
# “Think Python” 3rd Edition Chapter 6 (pages 61-71)

# Module #1 objectives: 1) introduce recursive functions, 2) demonstrate the
# use a recursive function by computing permutations and combinations, and 
# 3) use keyboard input.  

# Section 6.5 of "Think Python" shows the following factorial function.
# Note that the variable "result" is local to the functions which use it.

# Compare these functions to the definitions in Lial. 

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
        result=(factorial(n))/factorial(n-k)
        return result
             
def comb(n,k):
    result=perm(n,k)
    result=(result)/factorial(k)
    result=int(result)
    return result

# Section 5.11 of "Think Python" 2nd edition or pages 55-56 of the 3rd edition
# presents keyboard input.  Enter the number in the interpreter and hit enter.
# Keyboard input will be used for a factorial calculation in the next section.

print ('Enter a positive integer to obtain the factorial value.')
print ('Enter a negative integer to stop.') 
print ('In either case, hit enter or the code will not work.')

# The statement raw_input() accepts keyboard input and produces a string which
# must be converted to a numeric variable for further calculations.

n= raw_input()  
n= int(n)

if n > 0:
    result=factorial(n)
    print 'Factorial of %r is equal to %r\n' %(n,result)
else:
    print ('No calculation.\n')

# Example calculations follow. 

permutation = perm(10,5)
print "Permutation of 10 elements taken 5 at a time = %r\n" %permutation 
   
combination = comb(10,5)
print "Combination of 10 elements taken 5 at a time = %r\n" %combination

# Exercise #1: Using the functions as defined in the code check the calculations
# in Lial Section 8.1 Examples 3 and 9, and Section 8.2 Example 3. 

# Exercise #2: Using the concept of a "for" loop discussed in Section 10.3 
# of "Think Python", write a function that calculates factorials without
# using a recursive approach.



