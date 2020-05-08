


# open a connection to an SQLite database file where 'xyz.db 
# (can exist anywhere on computer).  xyzconn is connection name 
# you specify dfcust is the dataframe and this is added to the 
# connection and names it 'customer'

# a new database file (.sqlite file) will be created automatically 
# the first time we try to connect to a database. However, we have 
# to be aware that it won’t have a table, yet
import sqlite3
xzyconn = sqlite3.connect('xyz.db')
dfcust.to_sql('customer',xyzconn)
c = conn.cursor()   # creates object for cursor to operate in sqlite


# If we are finished with our operations on the database file, 
# we have to close the connection via the .close() method
conn.close()

# if we performed any operation on the database other than sending 
# queries, we need to commit those changes via the .commit() method 
# before we close the connection:
conn.commit()
conn.close()
