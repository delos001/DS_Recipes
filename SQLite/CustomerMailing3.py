from pandas import Series, DataFrame
import pandas as pd
import sqlite3
import pandas.io.sql

#Question1: import files
#read in three postgres files, with comma delimiter
#default header automatically infered by python
#low-memory=False: processes file in chunks.  There are too many columns to 
#manualy set each data type.  This will lower the memory needed to manage the 
#file

dfcust=pd.read_csv('cust.csv', delimiter=',', header='infer', low_memory=False) 
dfmail=pd.read_csv('mail.csv', delimiter=',', header='infer', low_memory=False)
dfitem=pd.read_csv('item.csv', delimiter=',', header='infer', low_memory=False)

#print first five records of mail file
print "First 5 lines of mail dataframe:"
print dfmail[:5] #prints line one through fifth line

dfcustshape=dfcust.shape #determine row and column number for cust file
print dfcustshape 


#Question2: verify no duplicate records in customer data
# 451 columns present per shape function
#performs record duplication search for cust file. Search performed across all
#columns, ie: no subset of columns specified for duplicatated function
dupdfcust=dfcust.duplicated().sum()
print('\nCust Data Duplicate Records Found:%r')%dupdfcust

#below looks for duplication by excluding transaction type and only includes
#account number, zip, ytd sales and ytd transaction count
dupdfcusttx=dfcust.duplicated(['acctno','zip','ytd_sales_2009',
                            'ytd_transactions_2009']).sum()
print('\nCust Data Duplicate Transaction Only Records Found:%r')%dupdfcusttx

#Question3: determine if there are records in item and mail that aren't in 
#customer files:
#create dataframe using isin command for mail vs. cust file
#Repeat in next line using isin command for item vs. cust file
#end command with false to find values in each df that are not in the cust df
dfmailComp=dfmail.acctno.isin(dfcust.acctno)==False
dfitemComp=dfitem.acctno.isin(dfcust.acctno)==False
 
#get sum of boolean results 'false' from dfmailComp an dfitemComp dataframe
dfmailComp.sum()  
dfitemComp.sum()

#Question4: create sqlite db and write cust, item, mail files as tables:
#create connection request object: xyzconn and create database: xyz.db 
xyzconn=sqlite3.connect('xyz.db')

#create cursor to work within sqlite
c=xyzconn.cursor()

dfcust.to_sql('customer',xyzconn) #upload dfcust to xyz database
dfmail.to_sql('mail',xyzconn) #upload dfmail to xyz database
dfitem.to_sql('item', xyzconn) #upload dfitem to xyz database

# select the rows from the customer file to make sure each file was
#transferred to the db
with xyzconn:
    c=xyzconn.cursor()
    c.execute('SELECT * FROM customer') #from customer table
    rowcust=c.fetchmany(2) #specifies the number of rows you want
    for row in rowcust:
        print row[:5] #too many columns in this file so only 5 col's selected
    c.execute('SELECT * FROM mail') #from mail table
    rowmail=c.fetchmany(5) #specifies the number of rows you want to view
    for row in rowmail:
        print row
    c.execute('SELECT * FROM item') #from item table
    rowitem=c.fetchmany(5) #specifies the number of rows you want to view
    for row in rowitem:
        print row

#Question5: create & export XYZ csv file to target mail marketing campaign
#add a column to the mail table to total the number of times each cust mailed
c.execute("ALTER TABLE mail ADD COLUMN 'Total_Send' INTEGER")

#sum values in each row of mail table to get total number of mailing sent for 
#each of the campaigns 
c.execute('UPDATE mail set Total_Send = mail_1+mail_2+mail_3+\
        mail_4+mail_5+mail_6+mail_7+mail_8+mail_9+mail_10+\
        mail_11+mail_12+mail_13+mail_14+mail_15+mail_16')

#create a table joining the total mailings sent to each customer and the 
#columsn specified in the customer table
c.execute('SELECT customer.acctno, customer.ytd_transactions_2009, \
        customer.ytd_sales_2009, customer.zhomeent, customer.zmobav, \
        customer.zcredit, customer.zhitech, mail.Total_Send FROM customer \
        INNER JOIN mail ON customer.acctno = mail.acctno')

#sets the query above to object rows for the campaign data
rows=c.fetchall()
cmpcsv=pd.DataFrame(rows) #turn rows object into dataframe call cmpcsv
print cmpcsv[:5] #check results to make sure they are correct

#add column headers to the cmpcsv dataframe
cmpcsv.columns=['Acct_No','YTD_Trans_2009','YTD_Sales_2009','ZHOMEENT',
                'ZMOBAV','ZCREDIT','ZTECH','Mail_Total']

#filter out rows where the total number of mailings sent to customers is <7
dfcmpfin=cmpcsv[cmpcsv.Mail_Total>=7]

#code the Y values to a 1 and all other values including NaN to a zero:
replace_vals={'Y':1,NaN:0,'U':0} #set list of values to replace
dfcmpout=dfcmpfin[4:].replace(replace_vals)
dfcmpout[4:].isnull().sum()  #check for null values after the replace function
'U'in dfcmpout[4:] #determines if 'U' is in the dataframe starting with col4

dfcmpout.to_csv('mail_cmp_final.csv')  #write final dataframe to csv


#Question6: create cross tabulation comparison
#create 1/0 frequency table with margins for each z=file to compare with total
#customer records to ensure coding was correct
zHometab=pd.crosstab(index=dfcmpout['ZHOMEENT'],columns='count', margins=True)
zMOtab=pd.crosstab(index=dfcmpout['ZMOBAV'],columns='count', margins=True)
zCCtab=pd.crosstab(index=dfcmpout['ZCREDIT'],columns='count', margins=True)
zHItab=pd.crosstab(index=dfcmpout['ZTECH'],columns='count', 
            margins=True)
#print dfcmpout specs to see number of rows to compare to cross tab values
dfcmpout.shape

#print each 1/0 grouped frequency for each column
print zHometab
print zMOtab
print zCCtab
print zHItab

#Question7: pickle the output file containing the campaign accounts to disk
dfcmpout.to_pickle('XYZmailcampaign.pkl')

#Save and close sqlite db
xyzconn.commit()
xyzconn.close()