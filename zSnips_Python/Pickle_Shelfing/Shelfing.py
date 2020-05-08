

#----------------------------------------------------------
# EXAMPLE 1
# create shelf object-----------------
import shelve

# list of names that you want to save for future python sessions
myElfNames=['Buddy','Andie','Obie','CatBallou']
# creating a shelve object, which is created in current working directory
myElf_db=shelve.open('myElf')

# write your list to a database by giving it a key: The key for the list is "Elves."
myElf_db['Elves'] = myElfNames 
# Closes the object and ensures that what's in the shelf is written to disk
myElf_db.close()  

# get shelf back out-------------------------
# sets object elfnamesback to open myelf
elfNamesBack=shelve.open('myElf')
# example output shows all the keys available: ['levels', 'airplanes', 'Elves']
list(elfNamesBack.keys())

# tells it to produce the list with the key 'Elves'
elfNamesBack['Elves']
# output: ['Buddy', 'Andie', 'Obie', 'CatBallou']



#----------------------------------------------------------
# EXAMPLE 2
# in this example, modify to remove the elf name CatBallou
Elves=elfNamesBack['Elves']

# since it is the last name in the list, we "pop" it out 
# which produces the following output: 'CatBallou'
Elves.pop() 

Print (Elves)  # output: ['Buddy', 'Andie', 'Obie']

# modified version of Elves back in
elfNamesBack['Elves'] = Elves 
elfNamesBack

# keys to the elves and the planes. Note that they are all 
# string values.  Output: ['levels', 'airplanes', 'Elves']
list(elfNamesBack.keys())

elfNamesBack['Elves']   # out: ['Buddy', 'Andie', 'Obie']

elfNamesBack.close()  # close our shelve data object file


#----------------------------------------------------------
# EXAMPLE 3
# in this example we want to put "CatBallou" back in our elf names list

# The same file, with a different session name.  The "writeback=True" 
# option allows caching in memory so that a shelf's sync() method or 
# its close() can update its disk file. This can be handy if your shelve 
# object is large, or if you have many changes to make to it.  
# how something you put into a shelve object "persists" depends on whether 
# you have specified the writeback=True option
elfPlanes=shelve.open('myElf',writeback=True)

elfPlanes['Elves'].append("CatBallou")  # appends the list Elves
Print (elfPlanes)

# This updates the file on disk.  
# The file is still open for reading and writing.
elfPlanes.sync()


#----------------------------------------------------------
# EXAMPLE 4
# adding a third object to the shelf

levels='low','medium','high'  # adding the tuple 'levels'
Print (levels)  # output: ('low', 'medium', 'high')

# "levels" is name of the tuple, and it's also used as the "key" in the shelf.
elfPlanes['levels']=levels 

Print (elfPlanes)
# output: {'levels': ('low', 'medium', 'high'), 
# 'airplanes': {'sixties': 'Jefferson', 'slower': 'propeller', 'faster': 'jet'}, 
# 'Elves': ['Buddy', 'Andie', 'Obie', 'CatBallou']}
# current version of elfPlanes is written for sure to disk file, and link to the file is closed.
elfPlanes.close() 

