

# adding two data frames together  (objs can be a variable assigned to two frames or use the [ ] and list them
# pd.concat(objs, axis=0, join='outer', join_axes=None, ignore_index=False,
#           keys=None, levels=None, names=None, verify_integrity=False,
#           copy=True)


#----------------------------------------------------------
# EXAMPLE 1
dict2A={'a':[1,2,3,4],'b':[5,6,7,8],'c':[10,9,8,7]}
dict2B={'a':[100,200,300,4000],'c':[50,60,70,80],'g':[1000,2000,3000,0000]}

frameA=pd.DataFrame(dict2A)
frameB=pd.DataFrame(dict2B)

concatAB=pd.concat([frameA,frameB])
concatAB



#----------------------------------------------------------
# EXAMPLE 2
# this sets unique index for each row (see below)
dict2A={'a':[1,2,3,4],'b':[5,6,7,8],'c':[10,9,8,7]}
dict2B={'a':[100,200,300,4000],'c':[50,60,70,80],
        'g':[1000,2000,3000,0000]}

frameA=pd.DataFrame(dict2A)
frameB=pd.DataFrame(dict2B)

concatAB=pd.concat([frameA,frameB], ignore_index=True)
concatAB


#---------------------------------------------------------
# EXAMPLE 
# merges the two dfs and specifies the column to merge them on.  
# it will default to the overlapping col name but its best to specify
df1=DataFrame({'key':['b','b','a','c','a','a','b'],
	                   'data1':range(7)})
df2=DataFrame({'key':['a','b','d'],
	                   'data2':range(3)})
	
pd.merge(df1,df2)

pd.merge(df1,df2, on='key')
