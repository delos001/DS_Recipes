

#----------------------------------------------------------
#----------------------------------------------------------
# PANDAS
# http://pandas.pydata.org/pandas-docs/stable/dsintro.html
#----------------------------------------------------------
#----------------------------------------------------------

# pandas.DataFrame.iloc
# Purely integer-location based indexing for selection by position.
# .iloc[] is primarily integer position based (from 0 to length-1 of 
#   the axis), but may also be used with a boolean array

df.loc[label] # select by row label, e.g. df.loc['Fred']
df.iloc[n] # select by integer row location
df[n:m] # rows n through m inclusive (not like slicing)

df[[label]] # select column by label

df.ix[n,m] # get row n, column m
df[p] or df.p # select column p, e.g. df['A'] , or df[2]
df[TFvec] # select based on Boolean vector  – e.g. df[cond1 & cond2], or df[cond1 | cond2]
df.filter() # filter rows or columns, including by regex or fuzzy matching


DF.iloc[:,:4].head()  # select columns 0 through 3 and first five rows.
DF.ix[:,:3].head()    # select columns 0 through 3 and first five rows.  

obj[val)            # select single column of data frame
obj.ix[val]         # select single row or subset of rows from df
obj.ix[:,val]       # select single column or subset of columns
obj.ix[val1,val2]   # select both rows and columns
