

# EMPTY LIST
# set object to empty list and make it numeric type
propI<-numeric(0)


#----------------------------------------------------------
# APPEND TO A LIST
z<-c(5,9,1,0)   # basic list
append(z,c(3,2),after=2)

s<-c("x","y","z")
append(s,c("A","B"),after=2)


#----------------------------------------------------------
#----------------------------------------------------------
# WORKING WITH LISTS
#----------------------------------------------------------
#----------------------------------------------------------

x <- c(7.5, 8.2, 3.1, 5.6, 8.2, 9.3, 6.5, 7.0, 9.3, 1.2, 14.5, 6.2)
x[7:12]  # gives the number in the list in position 7 through 12
x[-(1:6)]  # excludes 1:6 so: gives same result as x[7:12]
x[c(1:5,10:12)]  # gives numbers of specified positions


#---------------------------------------------------------
#---------------------------------------------------------
# LIST TO DATAFRAME
#---------------------------------------------------------
#---------------------------------------------------------

## sample list
bwHLA_LBSPID = c('HLA-A Allele 1' = 805, 
                 'HLA-A Allele 2' = 878, 
                 'HLA-B Allele 1' = 806)

## create dataframe from bwHLA_LBSPID list
bwHLA_LBSPIDdf = purrr::map2_df(bwHLA_LBSPID, names(bwHLA_LBSPID), 
                                function(x, y){
                                  data.frame(
                                    LBTEST = y, 
                                    LBSPID = as.character(x))
                                })  
