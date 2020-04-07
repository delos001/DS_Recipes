# -*- coding: utf-8 -*-
# MSPA 400 Session #4 Python Module #1

#Reading Assignment:
# “Think Python” 2nd Edition Chapter 5 (5.1-5.12)
# “Think Python” 3rd Edition Chapter 5 (pages 49-57).
# Review the Canopy Doc Manager to learn more about Matplotlib.

# Module #1 objective:  demonstrate set operations with Python and show their
# potential for data manipulation. 

# Instructions---The module is self contained.   
# The data for the following example are taken from Lial Shapter 7 Example 5.
# Various set operations will be performed.  The first steps are to define the
# lists of data which will then be converted into set objects.  Various set
# operations will be demonstrated.  Finally, a set will be converted to a list.

set()
U=set([1,2,3,4,5,6,7,8,9,10,11])
A=set([1,2,4,5,7])
B=set([2,4,5,7,9,11])

# In what follows I am generating new variables only to facilitate printing.
# The variables Uab, AB, Ac, Bc, AsB, R, Add, Addc and SD are for my
# convenience only.  The important thing is to study the set operations.

# Example of union operation
Uab=A | B
print ('\nUnion of A and B = %r \n') %Uab

# Example of intersection operation
AB=A & B
print ('Intersection of A and B = %r \n') %AB

# Example of finding the complement of A and B
Ac=U - A
Bc=U - B
print ('A complement = %r ') %Ac 
print ('B complement = %r \n') %Bc

# Example of finding the symmetric difference of A and b
# The symmetric difference are elements in A and B not common to both
AsB=A ^ B
print ('Symmetric difference of A and B =               %r ') %AsB

# Example showing another way to obtain the symmetric difference
SD=(A | B) - (A & B)
print ('Symmetric difference by union and intersection = %r \n') %SD 

# Union of several sets
R=Ac | Bc | AB
print ('Union of Ac, Bc and AB  %r ') %R
print ('Original set U was      %r ') %U

# Items can be added to sets using the union operation
Add=set([12,13,14])
U=U | Add
print ('Updated version of U =  %r \n') %U

# Removal is possible using the complement operation
Addc=U - Add
U=U & Addc
print ('Original version of U = %r \n') %U

# Following these operations, a set may be converted to a list.
U=list(U)
print ('U is now a list. %r') %U

# Exercise: Duplicate Examples 6 and 7 from Lial Section 7.1.
# Compare your code to the answer sheet.


