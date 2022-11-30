
#----------------------------------------------------------
# Convert columns to numeric. below will review entire df and convert columns
# that can be converted and leave rest alone

ratings_numdf=ratingsdf.apply(lambda x: pd.to_numeric(x, errors='ignore'))


#----------------------------------------------------------
# changes the entire data frame to a numeric data type
pd.to_numeric(s) 

#----------------------------------------------------------
# changes the entire data frame to a numeric data type
# does same thing.  raise is the default setting and tells python 
# to raise an error if it can't convert
pd.to_numeric(s, errors='raise')


#----------------------------------------------------------
# coerce invalid values to NaN as follow
pd.to_numeric(s, errors='coerce')


#----------------------------------------------------------
# ignores the errors and original series is untouched
pd.to_numeric(s, errors='ignore')


#----------------------------------------------------------
# apply to the entire data frame (where a is the data frame)
a = [['a', '1.2', '4.2'], ['b', '70', '0.03'], ['x', '5', '0']]
df = pd.DataFrame(a, columns=['col1','col2','col3'])
df[['col2','col3']] = df[['col2','col3']].apply(pd.to_numeric)

#----------------------------------------------------------

#----------------------------------------------------------
