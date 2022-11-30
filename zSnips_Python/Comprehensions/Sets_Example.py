
# Set is a dict without keys:
# have variou methods like:
# .difference(), .union(),issubset(), .add(), .remove(), .discard()

# You can use these to act upon or compare to other things like dicts or df's


#Set comprehensions are similar to lists but can represent a subset of a list
#sets don't contain duplicates
#sets can support union, intersection, difference, etc
#Creating a list
L6=['jason','d','Pamela','Brian','Alice','alex']

#if we only want elements from the list that begin with capital letters and 
#are more than 1 character we can create a set from the list that meet those
#criteria
S1={name[0].upper() + name[1:].lower() for name in L6 if len(name)>1}
S1



#----------------------------------------------------------
# BASIC EXAMPLE
#----------------------------------------------------------
basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana']
fruit = set(basket)               # create a set without duplicates
fruit
set(['orange', 'pear', 'apple', 'banana'])
'orange' in fruit                 # fast membership testing
True
'crabgrass' in fruit
False
# Demonstrate set operations on unique letters from two words

a = set('abracadabra')
b = set('alacazam')
a                                  # unique letters in a
set(['a', 'r', 'b', 'c', 'd'])
a - b                              # letters in a but not in b
set(['r', 'd', 'b'])
a | b                              # letters in either a or b
set(['a', 'c', 'r', 'd', 'b', 'm', 'z', 'l'])
a & b                              # letters in both a and b
set(['a', 'c'])
a ^ b                              # letters in a or b but not both
set(['r', 'd', 'b', 'm', 'z', 'l'])
