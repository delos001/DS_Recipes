

#----------------------------------------------------------
#----------------------------------------------------------
# BASIC EXAMPLES lists
#----------------------------------------------------------
#----------------------------------------------------------
mylist=["a", "b", "c", "d"]
mylist[0]     # Specifies 1st letter/number in list: "a"
mylist[1]     # Specifies 2nd letter/number in list: "b"
mylist[1:3]   # Specifies 2nd-4th letters in list: "b", "c", "d"
mylist[:3]    # Specifies 1st-4th letters in list: "a", "b", "c", "d"
mylist[3:]    # Specifies 4th to last letter in list: "c", "d"


#----------------------------------------------------------
#----------------------------------------------------------
# BASIC EXAMPLES string
#----------------------------------------------------------
#----------------------------------------------------------
mystring="Hello World"  
mystring[0]     # Specifies 1st element of string: "H"
mystring[1]     # Specifies 2nd element of string: "e"
mystring[1:3]   # Specifies 2nd-4th element of string: "ell"
mystring[:3]    # "hell"
mystring[3:]    # "lo World"
# Specifies the last letter in the string by counting the string 
# length and subtracting 1 since the first letter is actually a 
# 0 (and not a 1)
mystring[len(mystring)-1]
mystring[-1]    # specifies last letter in string but with less code


#----------------------------------------------------------
# GET POSITION IN A LIST
List = ["a", "b", "c", "d"]
List.index("c")




