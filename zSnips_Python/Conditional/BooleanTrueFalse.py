# In this script:
# Not statements
# And statements
# Or statements
# nested and/or/not statements


#----------------------------------------------------------
# NOT STATEMENT
bool_one = not True
print bool_one

bool_two = not 3**4 < 4**3
print bool_two

bool_three = not 10%3 <= 10%2
print bool_three

bool_four = not 3**2 + 4**2 != 5**2
print bool_four

bool_five = not not False
print bool_five


#----------------------------------------------------------
# AND STATEMENT
bool_one = False and False
print bool_one

bool_two = -(-(-(-2))) == -2 and 4>= 16**0.5
print bool_two

bool_three = 19%4 !=300/10/10 and False
print bool_three

bool_four = -(1**2) < 2**0 and 10%10 <= 20-10*2
print bool_four

bool_five = True and True
print bool_five



#----------------------------------------------------------
# OR STATEMENT

bool_one = 2**3 == 108%100 or 'Cleese' == 'King Arthur'
print bool_one

bool_two = True or False
print bool_two

bool_three = 100**0.5 >=50 or False
print bool_three

bool_four = True or True
print bool_four

bool_five = 1**100 == 100**1 or 3*2*1 != 3+2+1
print bool_five


#----------------------------------------------------------
# AND, OR, NOT
# Order of operations:
# 1: not is evaluated first;
# 2: and is evaluated next;
# 3: or is evaluated last.

bool_one = False or not True and True
print bool_one

bool_two = False and not True or True
print bool_two

bool_three = True and not (False or False)
print bool_three

bool_four = not not True or False and not True
print bool_four

bool_five = False or not (True and True)
print bool_five
