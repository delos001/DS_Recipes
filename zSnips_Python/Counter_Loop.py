

#----------------------------------------------------------
# Sets counter to 0 prior to counting
Counter = 0

#----------------------------------------------------------
# Adds 1 to each previous counter value
Counter = counter + 1

#----------------------------------------------------------
# count element in a list
# For each element in list "mynames", set the counter to the 
# current counter value plus one for each new name
# Yeilds: 3 since there are three names in "mynames"
mynames=["adam", "brian", "charlie"]
counter=0

For x in mynames:
	Counter=counter+1
counter

#----------------------------------------------------------
# append values with specific criteria from one list to another
# For each element in list "mynames", set the original list 
# "string" to blank then add each name in "mynames" separated 
# by a space
# Yields: adam brian charlie
mynames = ["adam", "brian", "charlie"]
String = ""

For x in mynames:
	String = string + " " + x

string

#----------------------------------------------------------
# 
phrase = "Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away."
phraseNoVowels=""

# For each letter "x" in the phrase, only if it not a vowel 
# add it to the current "phraseNoVowels" list.  
For x in phrase:
	If x not in "AEIOUaeiou":
		PhraseNoVowels=phraseNoVowels + x

# The print the results:
Yields the phrase with the vowels removed: Prfctn s chvd, nt 
# whn thr s nthng mr t dd, bt whn thr s nthng lft t tk wy.
Print phraseNoVowels
