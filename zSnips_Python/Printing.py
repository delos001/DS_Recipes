#----------------------------------------------------------
## BASICS
#----------------------------------------------------------
# print basic
print (print object)

# print a new line
print new line: print('\n' your text)


#----------------------------------------------------------
# PRINTING VARIABLES
#----------------------------------------------------------

# -*- coding: utf-8 -*-
U=range(1,27,1)  

A=U[0:13]
B=U[13:]
C=U[7:20]

A=set(A)
B=set(B)
C=set(C)
U=set(U)
T=float(len(U))

print('Set A is %r')%A
print ('  Length A is %r')%len(A)
print('Set C is %r')%C
print ('  Length C is %r')%len(C)
print('Intersection of A,C is %r')%(A&C)
print ('  Length of A&C is %r')%len(A&C)

print ('\nx1 equals %r and y1 equals %r ') % (x1, y1)

Pr_A=round(len(A)/float(len(U)),3)
print('\nProbability of A is %r')%Pr_A

Pr_AgC=round(len(A&C)/float(len(C)),3)
print ('Probability of A given C is %r')%Pr_AgC

Bayes=(Pr_A*Pr_AgC)/((Pr_A)*(Pr_AgC)+(Pr_notC)*(Pr_AnC))
print ('\nBayes probability is %r')%Bayes


#----------------------------------------------------------
# PRINTING STRINGS
#----------------------------------------------------------
# use %s because it is a string
equation=str('y = y1 +slope*(x-x1)')  # turns eqn to string
print ('\nEquation of a line is %s') %equation

