

#----------------------------------------------------------
# FILTER ON STRING
usap=('ABQ|BOI|BUF|CMH|SEA|TPA')
USOr = dfPassRd[dfPassRd['OriginApt'].str.contains(usap)]



#----------------------------------------------------------
# filter out rows that meet a specific criteria and create new dataframe
cmpcsv.columns=['Acct_No','YTD_Trans_2009','YTD_Sales_2009','zHome_Ent',
	'zMO_Buyer','zCC_Presence','zHi_Tech_Owner','Mail_Total']

dfcmpfin=cmpcsv[cmpcsv.Mail_Total>=7]
