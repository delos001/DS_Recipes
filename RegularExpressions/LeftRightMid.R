

#---------------------------------------------------------
# start is first character, stop is last: 
#     so x,1,4, gets characters 1-4 of x
substr(x, start, stop)



#---------------------------------------------------------
# gets left characters to first space
# in this example, it wraps to change to integer, then to factor
ColumnName_fix = as.factor(as.integer(gsub( "\\s.*", "", ColumnName)))

Site = as.factor(as.integer(gsub( "\\-.*", "", ColumnName)


#---------------------------------------------------------
# gets first letters prior to first dash character
Site = as.factor(as.integer(gsub( "\\-.*", "", ColumnName)
