# -*- coding: utf-8 -*-


#Lists are entered using the [] and can be number, strings, or 
#a combination of both.  Lists can also be created by arguments.

L1=[1,2,3,4,5]
L2=['a']
L3=[1,'a',2,'b',3,'c']
L4=[x**3 for x in range(5)]
L5=["charlie", "dennis", "pamela"]
L6=L5.append("jennifer") #add a new name to List 5
All_L=[L1,L2,L3,L4,L5]
All_L


#----------------------------------------------------------
# BASIC EXAMPLE
smallbirds=['finch','sparrow']  # list1
bigbirds=['hawk','eagle']        # list2
allbirds=[smallbirds, bigbirds]  # combines lists 1, 2
allbirds[1]       # get items in second list of combined list
allbirds[1][0]    # get second list, then get 1st item in that list 'hawk'


#----------------------------------------------------------
#----------------------------------------------------------
# APPEND LIST
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# BASIC EXAMPLE
myname=["adam", "brian"]
names2=["charlie", "dennis"]

myname.append(names2)


# BASIC EXAMPLE2 
myname=["adam", "brian"]
vowelnames=[]

For x in myname:
  # yields "adam": name begins with a vowel and was added to list "vowelnames"
	If x[0] in "aeiou":  # first letter for each word in myname
		Vowelnames.append(x)
vowelnames


#----------------------------------------------------------
#----------------------------------------------------------
# COUNT WORDS IN LIST
#----------------------------------------------------------
#----------------------------------------------------------
# this iterates over all the rows and produces word count for each.
import re

text_cnt = []
for i in data["Text"]:
    text_cnt.append(len(re.findall(r'\w+',i)))
