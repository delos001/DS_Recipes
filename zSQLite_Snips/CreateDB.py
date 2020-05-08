
# In this example, the db has 2 tables


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
