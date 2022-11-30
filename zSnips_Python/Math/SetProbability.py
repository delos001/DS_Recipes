
# It is assumed in this module that each element of U occurs 
# with equal probability as would be the case with random sampling 
# with replacement.  This assumption allows the probability of a 
# set to be calculated as the ratio of the length of the set (i.e. 
# number of elements) divided by the overall length of U which in 
# this Module is 26. 
# Note that %r and %s both can be used with strings and lists.

U=range(1,27,1)  # Defines range U from 1-26 in increments of 1

A=U[0:13]
B=U[13:]
C=U[7:20]

A=set(A)
B=set(B)
C=set(C)
U=set(U)

T=float(len(U))  # Converts length of T to floating point to avoid integer division

Null=A&B  # Defines null since intersection of A&B is null
print ('Probability of null intersection %r \n') %round((len(Null)/T),3)

#----------------------------------------------------------
# Demonstrate the Union Rule for Probability.
print ('Intersection of A and C is %r') %(A&C)
print ('Union of A and C %s\n') %(A|C)

# defines P using intersection rule (where they are the same)
P=(len(A) + len(C) -len(A&C))

# prints union of A,C divided by T (len of U) rounded to 3 places
# -Probability of A union C = 0.769 
print ('Probability of A union C = %r \n') %round((len(A|C)/T),3)

# prints same thing using P divided by T rounded to 3 places
# -Result of Union Rule Summation =  0.769
print ('Result of Union Rule Summation = %r\n') %round((P/T),3)



#----------------------------------------------------------
# Demonstrates calculation of Odds using complement rule
print ('Complement of C is %r') %(U-C)  # complement of C, given U

# prints odds of getting C 
# -Odds of C are 1.0
print ('Odds of C are %r\n') %round((len(C)/float(len(U-C))),3)

# prints values of U that aren't in set where A&C overlap
print ('Complement of A intersection C is %r') %(U-(A&C))

# defines P: A&C overlap(intersection) divided by complement of A 
# intersection C of U (see line above)
# Prints P rounded- Odds of A intersection C are 0.3
P=(len(A&C)/float(len(U-(A&C))))
print ('Odds of A intersection C are %r\n') %round(P,3)



#----------------------------------------------------------
# Demonstrate conditional probability
# defines P: length of where A&C overlap divided by length of C
# -Conditional probability of A given C is 0.462
P=round(len(A&C)/float(len(C)),3)
print ('Conditional probability of A given C is %r') %P



#----------------------------------------------------------
# Demonstrate the product rule

# prints intersection of A and C divided by T (float len of U)
# -Probability of A and C intersection is 0.231
print ('Probability of A and C intersection is %r') %round((len(A&C)/T),3)

# defines Q as C divided by T
# prints probability of C rounded
# -Probability of C is 0.5
Q=len(C)/T
print ('Probability of C is %r') %round(Q,3)

# performs product rule of P (see above) time Q
# -Product rule result for A and C intersection is 0.231
print ('Product rule result for A and C intersection is %r') %round(P*Q,3)
