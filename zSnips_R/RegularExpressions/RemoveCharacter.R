

#---------------------------------------------------------------------------
# EXAMPLE
# ex: string*
# I want to get rid of the *

# use \\ to exlude characters.
# whatever you put after the \\ is replaced with whatever you put in second "".
# if you don't put anything, it removes the character
df$col. = gsub("\\*", "", df.col)
