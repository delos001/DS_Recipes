
# Panda index objects hold axis labels and other metada (axis names, etc)
# See Mckinney Python for Data Analysis p118 table 5-3 for Index methods and properties list
# See Mckinney Python for Data Analysis p120 table 5-5 for reindex argument functions



#----------------------------------------------------------
#----------------------------------------------------------
# EXAMPLE 1
#----------------------------------------------------------
#----------------------------------------------------------

frame2=DataFrame(data,
                 columns=['year','state','pop','debt'],
                 index=['one','two','three','four','five'])


#----------------------------------------------------------
#----------------------------------------------------------
# EXAMPLE 2
#----------------------------------------------------------
#----------------------------------------------------------
obj=Series(range(3),index=['a','b','c'])  # sets index as a,b,c
index=obj.index
index[1:]  # produces values for 2nd through last data point:



#----------------------------------------------------------
# EXAMPLE 3
# creates a series
obj=Series([4.5,7.2,-5.3,3.6],index=['d','b','a','c'])
obj



#----------------------------------------------------------
# EXAMPLE 4
# reindex rearranges the data according to the new index order 
# and introduces any missing values that weren't already present

obj2=obj.reindex(['a','b','c','d','e'])


#----------------------------------------------------------
# EXAMPLE 5
# puts a value of zero for any new values (in this case 'e' from 
# above was new so had null).  now it has:
obj2=obj.reindex(['a','b','c','d','e'],fill_value=0)



#----------------------------------------------------------
# EXAMPLE 6
# sets frame as the specified data frame in 3x3 shape with the 
# specified index and column headers
frame=DataFrame(np.arange(9).reshape((3,3)),index=['a','c','d'],
    columns=['ohio','texas','california'])

# when you reindex it and add 'b', it produces NaN in row b
frame2=frame.reindex(['a','b','c','d'])



#----------------------------------------------------------
# EXAMPLE 7
# sets new series and the index tells where to start each color
# reindex ffill is 'forward fill': this fills each color forward 
# to the next index where it will start the next color
obj3=Series(['blue','purple','yellow'],index=[0,2,4])
obj3.reindex(range(6),method='ffill')


#----------------------------------------------------------
# EXAMPLE 8
# this is opposite of ffill, reindex with bfill which fills backwards 
# to the color ends at the index rather than starts
obj3=Series(['blue','purple','yellow'],index=[0,2,4])
obj3.reindex(range(6),method='bfill')
