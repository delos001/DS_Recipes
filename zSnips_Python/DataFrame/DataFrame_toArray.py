
# Data Frame Arrays
# like a series, values attributes returns data in the dataframe as a 2D ndarray


#----------------------------------------------------------
# EXAMPLE 1
frame3.values

# produces the values in the data frame as an array:
# array([[ nan,  1.5],
#        [ 2.4,  1.7],
#        [ 2.9,  3.6]])


#----------------------------------------------------------
# EXAMPLE 2
frame2.values

# see data frames above for the original frame2 output.  this has different column dtypes so the array output is different:
# array([[2000L, 'ohio', 1.5, nan],
#        [2001L, 'ohio', 1.7, -1.2],
#        [2002L, 'ohio', 3.6, nan],
#        [2001L, 'nevada', 2.4, -1.5],
#        [2002L, 'nevada', 2.9, -1.7]], dtype=object)
