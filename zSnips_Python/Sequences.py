

# range() includes the first, i.e. 1, but not the last element, i.e. 27.
# So this is from 1 to 26
# The third argument, 1, defines the step used between consecutive elements.

U=range(1,27,1) 


#----------------------------------------------------------
#----------------------------------------------------------
# NUMPY
#----------------------------------------------------------
#----------------------------------------------------------

arange()
# np.arange(start, stop, step, dtype)
np.arange(0,0.5,0.1)  # tarts at 0, stops at 0.5, interval of 0.1

n=10
print np.arange(10)

n=5
print np.arange(0,n+1)

n=2
print np.arange(0,n+1,0.1)
