
# In this example, create db with 2 tables
# then add columns
# query data from table
# perform join


#----------------------------------------------------------
#----------------------------------------------------------
# CREATE DB
#----------------------------------------------------------
#----------------------------------------------------------
import SQLite3

# create a connection object that represents the database
# You can also supply the special name :memory: to create 
# a database in RAM.
conn = sqlite3.connect('example.db')

xyz_file='xyz_db.sqlite'    # name of sqlite db

table_name1='cust_table1'   # name of first table to be created

table_name2='mail_table1'   # name of second table to be created

table_name3='item_table1'   # name of third table to be created

new_field='addcol1'         # name of the column

field_type1='INTEGER'       # column data type

conn=sqlite3.connect(xyz_file)  # create connection object 'xyzconn'

c=conn.cursor()             # create cursor to work within sqlite3


# creates a table and uses dictionaries to set the specs for the table: 
# tn is for table name, nf is for new field, ft is for field type 
# (these can be changed based on how you name them so they are meaningful)
# Out[14]: <sqlite3.Cursor at 0x19d80500>
c.execute('CREATE TABLE {tn} ({nf} {ft})'\
         .format(tn=table_name1,nf=new_field,ft=field_type1))

# creates a second table in the db with a primary key: 
# Out[18]: <sqlite3.Cursor at 0x19d80500>
c.execute('CREATE TABLE {tn} ({nf} {ft} PRIMARY KEY)'\
         .format(tn=table_name2,nf=new_field,ft=field_type1))

# creates a third table in the db with a primary key: 
# Out[19]: <sqlite3.Cursor at 0x19d80500>
c.execute('CREATE TABLE {tn} ({nf} {ft} PRIMARY KEY)'\
         .format(tn=table_name3,nf=new_field,ft=field_type1))


#----------------------------------------------------------
#----------------------------------------------------------
# ADD COLUMNS
#----------------------------------------------------------
#----------------------------------------------------------

# alter table: adds column called 'Total_Send' to the mail 
# table and sets the column type as integer
c.execute("ALTER TABLE mail ADD COLUMN 'Total_Send' INTEGER")

# update column value: updates the 'Total_Send' column in mail 
# table to add the values in each row specified
c.execute('UPDATE mail set Total_Send = mail_1+mail_2+mail_3+\
mail_4+mail_5+mail_6+mail_7+mail_8+mail_9+mail_10+\
mail_11+mail_12+mail_13+mail_14+mail_15+mail_16')


#----------------------------------------------------------
#----------------------------------------------------------
# QUERY TABLES
#----------------------------------------------------------
#----------------------------------------------------------

# Selecting rows that contain a certain value
table_name = 'my_table_2'    # table to be queried
id_column = 'my_1st_column'  # id_column

column_2 = 'my_2nd_column'
column_3 = 'my_3rd_column'

# limits selection to 10 rows that meet a certain criteria 
# (in this example, when the result is "Hi World"
c.execute('SELECT * FROM {tn} WHERE {cn}="Hi World" LIMIT 10'.\
        format(tn=table_name, cn=column_2))

# sets 'ten_rows' object to fetch all that was selected 
# (which is only 10 due to limit in first line
ten_rows = c.fetchall()
print('4):', ten_rows)


#----------------------------------------------------------
#----------------------------------------------------------
# PERFORM JOIN
#----------------------------------------------------------
#----------------------------------------------------------

# create a table joining the total mailings sent to each customer 
# and the columns specified in the customer table
c.execute('SELECT customer.acctno, customer.ytd_transactions_2009, \
customer.ytd_sales_2009, customer.zhomeent, customer.zmobav, \
customer.zcredit, customer.zhitech, mail.Total_Send FROM customer \
INNER JOIN mail ON customer.acctno = mail.acctno')

# #sets the query above to object rows for the campaign data
# ***for some reason this works but takes a really long time 
# so there is probably a better way
rows=c.fetchall()

# gets the rows collected from above and puts them in a data frame
cmpcsv=pd.DataFrame(rows)
