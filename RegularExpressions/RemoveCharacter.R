

#---------------------------------------------------------------------------
# Specify character to remove
# ex: string*
# I want to get rid of the *

# use \\ to exlude characters.
# whatever you put after the \\ is replaced with whatever you put in second "".
# if you don't put anything, it removes the character
df$col. = gsub("\\*", "", df.col)

#---------------------------------------------------------------------------
# Remove non-ascii characters
Name2 = gsub("[^\x20-\x7E]", "", Name))

Name2 = str_replace_all(Name, "[^\x20-\x7E]", "")


#---------------------------------------------------------------------------
# Remove : remove all non characters that aren't letter or number (includes spaces)
Name = str_replace_all(Name, "[^[:alnum:]]", "")


# Trim white space
Name2 = trimws(which = c('left', 'right', 'both'), whitespace = '[ \\h\\v\t\r\n]')
