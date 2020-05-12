
#----------------------------------------------------------
# EXAMPLE 1
import pandas as pd
import sqlite3
import pandas.io.sql

# reads files in
dfcust=pd.read_csv('cust.csv', delimiter=',', header='infer', low_memory=False) 
dfmail=pd.read_csv('mail.csv', delimiter=',', header='infer', low_memory=False)
dfitem=pd.read_csv('item.csv', delimiter=',', header='infer', low_memory=False)


# creates connection named xzyconn and creates database named xyz.db
# sets c an an object for sqlite cursor within the xyzconn connection
# sends dfcust dataframe to the xyzconn (connection to the xyz db) and 
#   names the file 'customer'
xyzconn=sqlite3.connect('xyz.db')
c=xyzconn.cursor()
dfcust.to_sql('customer',xyzconn)

# view the contents of the mail file that was just transferred to the db
with xyzconn:
	c=xyzconn.cursor()   # object for sqlite cursor within the xyzconn connection
	c.execute('SELECT * FROM customer')  # selects from from customer tablein db
  
  # fectchmany allows to select the number of rows you want to view: 
  # 5 in this example (can use fetchall() and fetchone())
	rowcust=c.fetchmany(2) 
  
	for row in rowcust:
		print row[:5]   # only view 5 columns

  
  #  view the contents of the mail file that was just transferred to the db
  c.execute('SELECT * FROM mail') 
	rowmail=c.fetchmany(5) for row in rowmail:   # specifies num of rows
		print row
	c.execute('SELECT * FROM item')  # selects from the customer table in xyz db
	rowitem=c.fetchmany(5)   # select 5 rows
	for row in rowitem:
print row



#----------------------------------------------------------
# EXAMPLE 2
import pandas as pd
import sqlite3
import pandas.io.sql


table_name = 'my_table_2'    # sets object for table to be queried
id_column = 'my_1st_column'  # sets object for id_column

column_2 = 'my_2nd_column'   # sets object for column_2
column_3 = 'my_3rd_column'   # sets object for column_3

# limits selection to 10 rows that meet a certain criteria 
# (in this example, when the result is "Hi World"
c.execute('SELECT * FROM {tn} WHERE {cn}="Hi World" LIMIT 10'.\
        format(tn=table_name, cn=column_2))
        
# sets 'ten_rows' object to fetch all that was selected 
# (which is only 10 due to limit in first line
ten_rows = c.fetchall()
print('4):', ten_rows)
