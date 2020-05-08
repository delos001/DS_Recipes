

#----------------------------------------------------------
# EXAMPLE
# If x = 4, produces a 1, else produces a 0.  
#     this sums all the observations if they equal 4 
x=sample(1:10, replace=TRUE)
sum(x==4)
store = sum(x==4)>0

#----------------------------------------------------------
# EXAMPLE
# returns true if the number of times a 4 is present in the 
#     store data is greater than 0, else returns false

storea=sample(1:10, replace=TRUE)
sum(storea==4)
sum(storea==4)>0


#----------------------------------------------------------
# EXAMPLE
# if the value that is randomly selected using the sample function 
#     is a 4, this puts a 1.  if not, it puts a zero.  
#     then this sums up all the observations that are greater than 0.
sum(sample(1:100, rep=TRUE)==4)>0



store2=rep(NA, 10)
for (i in 1:10){
  # for each i where value equals 4, put a 1, else put a zero
  store2[i]=sum(sample(1:10, replace = TRUE)==4)>0
}
store2      
sum(store2)     # sum the resulting store2 variable
mean(store2)
