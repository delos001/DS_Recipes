# -*- coding: utf-8 -*-
# MSPA 400 Session #4 Python Module #2

# Reading Assignment: 
# “Think Python” 2nd Edition Chapter 5 (5.1-5.12)
# “Think Python” 3rd Edition Chapter 5 (pages 49-57)

# Module #2 extends set operations presented in Module #1.  Probability rules 
# are applied to sets.  The rules are presented in Lial Sections 7.2-7.6.

# Generate the universe U.  Note that range(1,27,1) will be used to produce
# a list of 26 positive integers for set operations.  Remember, range() 
# includes the first, i.e. 1, but not the last element, i.e. 27.  The third 
# argument, 1, defines the step used between consecutive elements.  Note that 
# the functions used in this module are available from Python itself.

U=range(1,27,1)  

# Slice the list U into three subsets.  Note that slicing is inclusive of the
# first indexed element and exclusive of the last indexed element.  Also, the
# first element has 0 for an index.

A=U[0:13]
B=U[13:]
C=U[7:20]

A=set(A)
B=set(B)
C=set(C)
U=set(U)
print ('The universe U is %s ') %U

print ('\nA is %s') %A  # Compare these sets to the slice statements above.
print ('B is %s') %B
print ('C is %s\n') %C

# It is assumed in this module that each element of U occurs with equal 
# probability as would be the case with random sampling with replacement.
# This assumption allows the probability of a set to be calculated as the
# ratio of the length of the set (i.e. number of elements) divided by the
# overall length of U which in this Module is 26.  Note that %r and %s both
# can be used with strings and lists.

# Convert the length of T to floating point to avoid interger division.
# The function round() was defined in earlier modules as was float().

T=float(len(U)) 

# Demonstrate the null intersection and probability.
Null=A&B
print ('Probability of null intersection %r \n') %round((len(Null)/T),3)

# Demonstrate the Union Rule for Probability.

print ('Intersection of A and C is %r') %(A&C)
print ('Union of A and C %s\n') %(A|C)

P=(len(A) + len(C) -len(A&C))
print ('Probability of A union C = %r \n') %round((len(A|C)/T),3)
print ('Result of Union Rule Summation =  %r\n') %round((P/T),3)

# Demonstrate the calculation of Odds using the complement rule.

print ('Complement of C is %r') %(U-C)
print ('Odds of C are %r\n') %round((len(C)/float(len(U-C))),3)

print ('Complement of A intersection C is %r') %(U-(A&C))
P=(len(A&C)/float(len(U-(A&C))))
print ('Odds of A intersection C are %r\n') %round(P,3)

# Demonstrate conditional probability.
P=round(len(A&C)/float(len(C)),3)
print ('Conditional probability of A given C is %r') %P

# Demonstrate the product rule.
print ('Probability of A and C intersection is %r') %round((len(A&C)/T),3)
Q=len(C)/T
print ('Probability of C is %r') %round(Q,3)
print ('Product rule result for A and C intersection is %r') %round(P*Q,3)

# Exercise:  Refer to Section 7.6 of Lial.  Using the sets defined above and 
# set operations apply Bayes' Theorem.  Calculate the conditional
# probability of A given C, and the probability of C given A.

