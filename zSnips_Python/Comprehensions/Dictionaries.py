
#Dictionary comprehensions are sets containing a key that maps a value to one
#or more elements.  

myblanklist = {}   # defines a void dictionary


#----------------------------------------------------------
# Using S1 set, a dictionary is created
D1={'Alex':25, 'Alice':42, 'Brian':28, 'Jason':38, 'Pamela':46}
#leveraging the key, we can get information from the dictionary
D1['Pamela']

#I thought this exmaple below was clever.  It is directly from
#http://python-3-patterns-idioms-test.readthedocs.io/en/latest/Comprehensions.html
mcase = {'a':10, 'b': 34, 'A': 7, 'Z':3} #dict with varying case
#this adds up the values for the same letter by looking at the case of each letter
mcase_frequency = { k.lower() : mcase.get(k.lower(), 0) + 
    mcase.get(k.upper(), 0) for k in mcase.keys() }
mcase_frequency


#----------------------------------------------------------
# BASIC EXAMPLE
import pandas as pd
from pandas import Series, DataFrame

#Trick1
dictA={'a':1,'b':2,'c':3}
dictB={'a':10,'b':20,'c':30}
dictC={'a':100,'b':200,'c':300}

ListODicts=[dictA, dictB, dictC] #list from dictionaries created above
ListODicts=pd.DataFrame(ListODicts) #dataframe from list created above

#result is three columns and three rows combining the original dictionaries

#Trick2
dict2A={'a':[1,2,3,4],'b':[5,6,7,8],'c':[10,9,8,7]}
dict2B={'a':[100,200,300,4000],'c':[50,60,70,80],'g':[1000,2000,3000,0000]}

frameA=pd.DataFrame(dict2A)  #dataframe from dict2A
frameB=pd.DataFrame(dict2B)  #dataframe from dict2B

appendAB=frameA.append(frameB, ignore_index=True) #append frame a to b
concatAB=pd.concat([frameA,frameB],ignore_index=True) #concat frame a to b

#the result is an aggregated data frame of the two dictionaries with a unique
#index and missing values are indicated with NaN
