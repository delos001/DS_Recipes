

#----------------------------------------------------------
#----------------------------------------------------------
# Compare records in one data frame and see how many are NOT 
# included in another
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# isin: create new df containing values that are in the dfmail file, 
# acctno column but NOT in the dfcust file, acctno column 
counts boolean results (True =1, False =0) for the dfmailComp dataframe created above
dfcust=pd.read_csv('cust.csv', delimiter=',', header='infer', low_memory=False) 
dfmail=pd.read_csv('mail.csv', delimiter=',', header='infer', low_memory=False)
dfitem=pd.read_csv('item.csv', delimiter=',', header='infer', low_memory=False)

dfmailComp=dfmail.acctno.isin(dfcust.acctno)==False
dfrmailComp.sum()


#----------------------------------------------------------
# same as above (using False) code but this one uses ~ which means 'not' in pandas: 
# will give the number of items in the dfitem file, acctno column that are NOT 
# (because of ~) in the dfcust file, acctno column

# by moving the ~ to outside the parenthesis, it give a negative number.  
# in this case it gives -77122 in which 77122 is the total rows in the item file.  
# Since the negative number equals number of total rows, we know no records are in 
# item that are not in cust file
dfcust=pd.read_csv('cust.csv', delimiter=',', header='infer', low_memory=False) 
dfmail=pd.read_csv('mail.csv', delimiter=',', header='infer', low_memory=False)
dfitem=pd.read_csv('item.csv', delimiter=',', header='infer', low_memory=False)

(~dfitem.acctno.isin(dfcust.acctno)).sum()

~(dfitem.acctno.isin(dfcust.acctno)).sum()




#----------------------------------------------------------
#----------------------------------------------------------
# Compare records in one data frame and see how many are 
# included in another
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# determines if values in acctno column in dfmail dataframe are 
# in acctno column of dfcust data frame and sums them
dfcust=pd.read_csv('cust.csv', delimiter=',', header='infer', low_memory=False) 
dfmail=pd.read_csv('mail.csv', delimiter=',', header='infer', low_memory=False)
dfitem=pd.read_csv('item.csv', delimiter=',', header='infer', low_memory=False)

dfmail.acctno.isin(dfcust.acctno).sum()
