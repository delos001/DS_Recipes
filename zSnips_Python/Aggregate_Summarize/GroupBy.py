

# You can "string together" (sort of like piping) Pandas objects and methods.
# This applies the .groupby() method to passDF to group rows in passDF based on the 
# values in the column OriginApt. The values of Total are summed for each OriginApt.
passDF.groupby('OriginApt')['Total'].sum()
# another example grouped by originapt and carrier
dfPassRd.groupby(['OriginApt','Carrier'],as_index=False)['Total'].sum()

# Note that the above is different than doing
passDF.groupby('OriginApt').sum()['Total']


# how to get simple summaries or aggregates out of passDF
# We know that there wasn't arrival data for these airports, but there was 
#   departure data. 
# All we need to do is to sum up the Total values for each of the airports, 
#   like above. 
#   (The first way, above, not the second. What kind of Pandas object is the result?)

# But how about getting the largest departure carrier for each 
# of the airports? Here's one way we might get them:
passDF['maxPass']=passDF.groupby('OriginApt')['Total'].transform(max)
passDF[passDF.maxPass==passDF.Total][['OriginApt','Carrier']]


#----------------------------------------------------------
# GROUPING EXAMPLE WITH SUBSETTING DF
usap=('ABQ|BOI|BUF|CMH|SEA|TPA')
# sums columns based on grouping by originapt and carrier
grp = dfPassRd.groupby(['OriginApt','Carrier'],as_index=False)['Total'].sum()
# df of originapt codes specified in usap vector
d = grp[grp['OriginApt'].str.contains(usap)] 
# gets the carrier that has the max 'total' for each airport
e = d.groupby(['OriginApt'],as_index=False)['Carrier','Total'].max()



#----------------------------------------------------------
# ANOTHER EXAMPLE
# sets object to contain the variables I want in the OriginApt column
# sums all the departures from the destination airports that I included 
#   in the usap object
# sums the Total column for each location where the usap variables are 
 #  found in the OriginApt column
# prints a description plus the results
usap=('ABQ|BOI|BUF|CMH|SEA|TPA')
sum(dfPassRd['OriginApt'].str.contains(usap))
d=dfPassRd.loc[dfPassRd['OriginApt'].str.contains(usap),'Total'].sum()
print ('Total Departures for US Airports: %r')%d
