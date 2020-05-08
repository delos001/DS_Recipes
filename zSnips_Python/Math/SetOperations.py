

#----------------------------------------------------------
# UNION


set()
U=set([1,2,3,4,5,6,7,8,9,10,11])
A=set([1,2,4,5,7])
B=set([2,4,5,7,9,11])

Uab=A | B   # creates union between set A and B
print ('\nUnion of A and B = %r \n') %Uab


#----------------------------------------------------------
# UNION OF SEVERAL SETS

set()
U=set([1,2,3,4,5,6,7,8,9,10,11])
A=set([1,2,4,5,7])
B=set([2,4,5,7,9,11])

Ac=U - A  # Ac is complement of A and B (complement function below)
Bc=U - B  # Bc is complement of A and B (complement function below)

R=Ac | Bc | AB  # creates union between Ac, Bc, & U
print ('Union of Ac, Bc and AB %r ') %R
print ('Original set U was %r ') %U



#----------------------------------------------------------
# INTERSECTION

set()
U=set([1,2,3,4,5,6,7,8,9,10,11])
A=set([1,2,4,5,7])
B=set([2,4,5,7,9,11])

AB=A & B  # creates intersection between set A and B
print ('Intersection of A and B = %r \n') %AB


#----------------------------------------------------------
# COMPLIMENT

set()
U=set([1,2,3,4,5,6,7,8,9,10,11])
A=set([1,2,4,5,7])
B=set([2,4,5,7,9,11])

Ac=U - A  # creates complement of A
Bc=U - B  # creates complement of B
print ('A complement = %r ') %Ac 
print ('B complement = %r \n') %Bc



#----------------------------------------------------------
# SYMETRIC DIFFERENCE

set()
U=set([1,2,3,4,5,6,7,8,9,10,11])
A=set([1,2,4,5,7])
B=set([2,4,5,7,9,11])

AsB=A ^ B   # creates symmetric difference between set A and B
print ('Symmetric difference of A and B = %r ') %AsB


#----------------------------------------------------------
# SYMETRIC DIFFERENCE 2

set()
U=set([1,2,3,4,5,6,7,8,9,10,11])
A=set([1,2,4,5,7])
B=set([2,4,5,7,9,11])

SD=(A | B) - (A & B)  # Method 2: Symmetric difference (by union & intersection)
print ('Symmetric difference by union and intersection = %r \n') %SD 


#----------------------------------------------------------
# ADDING ITEMS TO SETS

set()
U=set([1,2,3,4,5,6,7,8,9,10,11])
A=set([1,2,4,5,7])
B=set([2,4,5,7,9,11])

Add=set([12,13,14])
U=U | Add   # adds 12, 13, and 14 to set U
print ('Updated version of U = %r \n') %U



#----------------------------------------------------------
# REMOVING ITEMS FROM SETS

set()
U=set([1,2,3,4,5,6,7,8,9,10,11])
A=set([1,2,4,5,7])
B=set([2,4,5,7,9,11])

Addc=U - Add
U=U & Addc  # defines set U as U minus the Addc variable
print ('Original version of U = %r \n') %U



#----------------------------------------------------------
# CONVERT SET TO A LIST

set()
U=set([1,2,3,4,5,6,7,8,9,10,11])
A=set([1,2,4,5,7])
B=set([2,4,5,7,9,11])

U=list(U)   # defines set U as a list
print ('U is now a list. %r') %U
