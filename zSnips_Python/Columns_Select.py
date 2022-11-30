


# sets object to contain column indexes I don't want
# create a new dataframe from previous that drops columns 
# I don't want based on collist object and creates copy 
# with the columns I want
collist=[1,2,13,14]
ratingsdf=reviewsdf.drop(reviewsdf.columns[collist],1


#does the same thing as above.  creates new df that filters 
# for only the Ratings column
ratingsdf=reviewsdf.filter(like="Ratings')

                           
## Select columns using if statement and the df shape
## ix is all columns (data.shape[1] gives column number) that aren't 23abs
ix = [i for i in range(data.shape[1]) if i != 23]                           
