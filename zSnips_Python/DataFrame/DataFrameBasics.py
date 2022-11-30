
# IN THIS SCRIPT
# Create DataFrame
# Name columns
# Identify if column present
# Remove columns
# Review dataframe column names or column contents
# Enter values or scalars for columns
# Replace column values


#----------------------------------------------------------
#----------------------------------------------------------
# CREATE DATAFRAME
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# EXAMPLE 1
data = {'state':['ohio','ohio','ohio','nevada','nevada'],
    'year':[2000,2001,2002,2001,2002],
    'pop':[1.5,1.7,3.6,2.4,2.9]}

frame = DataFrame(data)

# order that you want the columns to be displayed
DataFrame(data, columns=['year','state','pop'])
DataFrame(data, columns=['year','state','pop','debt'])


#----------------------------------------------------------
# EXAMPLE 2
# nest a dictionary within a dictionary to create a data frame:  
# outter dictionary = pop.  
# inner dictionaries = nevada and ohio
pop={'nevada':{2001:2.4, 2002:2.9},
    'ohio':{2000:1.5, 2001:1.7, 2002:3.6}}
frame3=DataFrame(pop)
frame3


#----------------------------------------------------------
# EXAMPLE 3
# creates dictionary of a series.  It only produces rows 
# specified in the index:
pdata = {'nevada': frame3['nevada'][:1],
	'ohio':frame3['ohio'][:2]}
DataFrame(pdata)



#----------------------------------------------------------
# EXAMPLE 4

# makes a copy with specified cols
new = old[['A', 'C', 'D']].copy()  

# uses filter (and creates a copy by default)
new = old.filter(['A','B','D'], axis=1)

# drops the columns you specify (use this if its faster to say 
# what you want removed then it is to add new using .copy function
new = old.drop('B', axis=1)



#----------------------------------------------------------
# EXAMPLE 5
# Dictionary to DF
import pandas as pd
from pandas import Series, DataFrame

dictA={'a':1,'b':2,'c':3}
dictB={'a':10,'b':20,'c':30}
dictC={'a':100,'b':200,'c':300}

ListODicts=[dictA, dictB, dictC]

ListODicts=pd.DataFrame(ListODicts)
ListODicts

#----------------------------------------------------------
#----------------------------------------------------------
# NAME COLUMNS
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# EXAMPLE 1
cmpcsv.columns = ['Acct_No','YTD_Trans_2009','YTD_Sales_2009'
                  'zHome_Ent','zMO_Buyer','zCC_Presence',
                  'zHi_Tech_Owner','Mail_Total']


#----------------------------------------------------------
# EXAMPLE 2
# names the column headers and index
frame3.index.name='year'; 
frame3.columns.name='state'



#----------------------------------------------------------
#----------------------------------------------------------
# IDENTIFY IF COLUMN PRESENT
#----------------------------------------------------------
#----------------------------------------------------------                

# determines if 'ohio' is a column header
'ohio' in frame3.columns


#----------------------------------------------------------
#----------------------------------------------------------
# REMOVE COLUMN
#----------------------------------------------------------
#---------------------------------------------------------- 

#----------------------------------------------------------
# EXAMPLE 1
# removes the column you specify
del frame2['test']

#----------------------------------------------------------
# EXAMPLE 2 
# sets object to contain column indexs I don't want
# create a new dataframe from previous that drops columns I don't want based
# on collist object and creates copy with the columns I want
collist=[1,2,13,14] 

authratedate=reviewsdf.drop(reviewsdf.columns[collist],1)



#----------------------------------------------------------
#----------------------------------------------------------
# DATA FRAME AND COLUMN CONTENTS
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# EXAMPLE 1
# see what COLUMNS are available in the dataframe:
frame2.columns

# output: Index([u'year', u'state', u'pop', u'debt'], dtype='object')



#----------------------------------------------------------
# EXAMPLE 2
# see what values are available for the column 'year'.  
# could use other columns such as state or pop
frame2.year




#----------------------------------------------------------
#----------------------------------------------------------
# ENTER COLUMN OR SCALAR VALUES
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# EXAMPLE 1
frame2['debt']=16.5



#----------------------------------------------------------
# EXAMPLE 2
# uses the arange function to assigns values to 'debt' column 
# (starting with 0).  the number (5) in this case must match 
# the number of rows
frame2['debt'] = np.arange(5.)
frame2



# as above, the arange number must match length of data frame 
# but if you assign series, it will be assigned according to the 
# data frame's index sets the 'debt' column to the val series 
# defined above (note that not all indexes were defined so pandas 
# insert NaN)

val=Series([-1.2,-1.5,-1.7],index=['two','four','five'])
frame2['debt']=val
frame2


#----------------------------------------------------------
# EXAMPLE 3
# add a new column called 'estern' and fills with boolean whether 
# the state is ohio or not
frame2['estern']=frame2.state=='ohio'
frame2


#----------------------------------------------------------
# EXAMPLE 4
# add a new column and manually enter the values based on the 
# index values
# frame2['test']=Series([1,2,3,4,5], 
index=['one','two','three','four','five'])



#----------------------------------------------------------
#----------------------------------------------------------
# REPLACE COLUMN VALUES
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# EXAMPLE 1

# replaces every instance of '\N' with np.NaN which is null value
dfrt.replace('\N',np.NaN)

#----------------------------------------------------------
# EXAMPLE 2
# creates an object to tell which things to replace
# replaces everything from col4 with the values specified in 
# the replace_vals object

# check for null values after the replace function
# determines if 'U' is in the dataframe starting with col4. 
# returns true or false
replace_vals={'Y':1,NaN:0,'U':0} 
dfcmpout=dfcmpfin[4:].replace(replace_vals)

dfcmpout[4:].isnull().sum() 
'U'in dfcmpout[4:]

